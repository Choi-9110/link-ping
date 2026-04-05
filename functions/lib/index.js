"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.iapVerify = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const VALID_PRODUCT_IDS = new Set([
    "linkping_premium_monthly",
    "linkping_premium_yearly",
    "linkping_premium_lifetime",
]);
/**
 * IAP 검증 엔드포인트
 * POST /iapVerify
 *
 * Apple App Store / Google Play 영수증을 검증하고
 * Firestore에 프리미엄 상태를 기록합니다.
 */
exports.iapVerify = functions.https.onRequest(async (req, res) => {
    // CORS
    res.set("Access-Control-Allow-Origin", "*");
    if (req.method === "OPTIONS") {
        res.set("Access-Control-Allow-Methods", "POST");
        res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");
        res.status(204).send("");
        return;
    }
    if (req.method !== "POST") {
        res.status(405).json({ valid: false, error: "Method not allowed" });
        return;
    }
    try {
        const body = req.body;
        // 기본 필드 검증
        if (!body.productId || !body.purchaseId || !body.platform) {
            functions.logger.warn("Missing required fields", { body });
            res.status(400).json({ valid: false, error: "Missing required fields" });
            return;
        }
        // 상품 ID 유효성
        if (!VALID_PRODUCT_IDS.has(body.productId)) {
            functions.logger.warn("Invalid product ID", { productId: body.productId });
            res.status(400).json({ valid: false, error: "Invalid product ID" });
            return;
        }
        let isValid = false;
        if (body.platform === "ios") {
            isValid = await verifyApple(body);
        }
        else if (body.platform === "android") {
            isValid = await verifyGoogle(body);
        }
        else {
            functions.logger.warn("Unknown platform", { platform: body.platform });
            res.status(400).json({ valid: false, error: "Unknown platform" });
            return;
        }
        // 검증 결과 로깅
        functions.logger.info("IAP verification result", {
            platform: body.platform,
            productId: body.productId,
            purchaseId: body.purchaseId,
            valid: isValid,
        });
        // 검증 기록 저장 (감사 로그)
        await admin.firestore().collection("iapVerifications").add({
            ...body,
            valid: isValid,
            verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        res.status(200).json({ valid: isValid });
    }
    catch (error) {
        functions.logger.error("IAP verification error", { error });
        res.status(500).json({ valid: false, error: "Internal server error" });
    }
});
/**
 * Apple App Store 영수증 검증
 * App Store Server API v2 사용
 */
async function verifyApple(body) {
    // serverVerificationData에는 Apple의 JWS(JSON Web Signature) 트랜잭션이 담김
    // in_app_purchase 플러그인이 StoreKit2를 사용하면 JWS 형식
    const receiptData = body.serverVerificationData;
    if (!receiptData) {
        functions.logger.warn("Apple: No receipt data");
        return false;
    }
    try {
        // JWS 토큰 디코딩 (헤더.페이로드.서명)
        const parts = receiptData.split(".");
        if (parts.length === 3) {
            // StoreKit2 JWS 형식 - 페이로드 디코딩하여 검증
            const payload = JSON.parse(Buffer.from(parts[1], "base64").toString("utf8"));
            functions.logger.info("Apple JWS payload", {
                productId: payload.productId,
                transactionId: payload.transactionId,
                environment: payload.environment,
            });
            // 상품 ID 매칭 확인
            if (payload.productId !== body.productId) {
                functions.logger.warn("Apple: Product ID mismatch", {
                    expected: body.productId,
                    got: payload.productId,
                });
                return false;
            }
            // Sandbox vs Production 구분 로깅
            if (payload.environment === "Sandbox") {
                functions.logger.info("Apple: Sandbox purchase detected");
            }
            return true;
        }
        // Legacy receipt 형식 (StoreKit1) - Apple 서버에 직접 검증
        // 레거시이지만 폴백으로 유지
        const verifyUrl = "https://buy.itunes.apple.com/verifyReceipt";
        const sandboxUrl = "https://sandbox.itunes.apple.com/verifyReceipt";
        const response = await fetch(verifyUrl, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ "receipt-data": receiptData }),
        });
        const result = await response.json();
        // status 21007 = sandbox 영수증 → sandbox 서버로 재시도
        if (result.status === 21007) {
            const sandboxResponse = await fetch(sandboxUrl, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ "receipt-data": receiptData }),
            });
            const sandboxResult = await sandboxResponse.json();
            return sandboxResult.status === 0;
        }
        return result.status === 0;
    }
    catch (error) {
        functions.logger.error("Apple verification error", { error });
        return false;
    }
}
/**
 * Google Play 영수증 검증
 * Google Play Developer API 사용
 */
async function verifyGoogle(body) {
    const purchaseToken = body.serverVerificationData;
    if (!purchaseToken) {
        functions.logger.warn("Google: No purchase token");
        return false;
    }
    try {
        // Firebase Admin SDK의 서비스 계정으로 Google API 호출
        const packageName = "com.drevv.linkping";
        // 구독 상품인지 일회성인지 구분
        const isSubscription = body.productId !== "linkping_premium_lifetime";
        const apiBase = "https://androidpublisher.googleapis.com/androidpublisher/v3";
        const accessToken = await getAccessToken();
        let apiUrl;
        if (isSubscription) {
            apiUrl =
                `${apiBase}/applications/${packageName}` +
                    `/purchases/subscriptions/${body.productId}` +
                    `/tokens/${purchaseToken}`;
        }
        else {
            apiUrl =
                `${apiBase}/applications/${packageName}` +
                    `/purchases/products/${body.productId}` +
                    `/tokens/${purchaseToken}`;
        }
        const response = await fetch(apiUrl, {
            headers: { Authorization: `Bearer ${accessToken}` },
        });
        if (!response.ok) {
            functions.logger.warn("Google API error", {
                status: response.status,
                body: await response.text(),
            });
            return false;
        }
        const result = await response.json();
        if (isSubscription) {
            // 구독: paymentState 1 = 결제 완료
            const valid = result.paymentState === 1 || result.paymentState === 2;
            functions.logger.info("Google subscription check", {
                paymentState: result.paymentState,
                valid,
            });
            return valid;
        }
        else {
            // 일회성: purchaseState 0 = 구매됨
            const valid = result.purchaseState === 0;
            functions.logger.info("Google product check", {
                purchaseState: result.purchaseState,
                valid,
            });
            return valid;
        }
    }
    catch (error) {
        functions.logger.error("Google verification error", { error });
        return false;
    }
}
/**
 * Google API 접근을 위한 액세스 토큰 획득
 * Firebase Admin SDK 서비스 계정 사용
 */
async function getAccessToken() {
    const credential = admin.app().options.credential;
    if (!credential) {
        throw new Error("No credential available");
    }
    const token = await credential.getAccessToken();
    return token.access_token;
}
//# sourceMappingURL=index.js.map