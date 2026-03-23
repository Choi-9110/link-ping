# IAP 검증 API 계약 (P0)

## Endpoint
- `POST /iap/verify`
- Content-Type: `application/json`

## Request body 예시
```json
{
  "platform": "ios",
  "productId": "linkping_premium_yearly",
  "purchaseId": "1000001234567890",
  "transactionDate": "1730000000000",
  "status": "purchased",
  "source": "app_store",
  "localVerificationData": "...",
  "serverVerificationData": "..."
}
```

## Response body
```json
{ "valid": true }
```
또는
```json
{ "valid": false }
```

## 동작 규칙
- HTTP 2xx + `valid:true` => 프리미엄 지급
- 그 외(HTTP 오류/파싱 실패/`valid:false`) => 검증 실패 처리

## 권장
- Apple: App Store Server API 또는 서버 영수증 검증
- Google: Google Play Developer API로 purchase token 검증
