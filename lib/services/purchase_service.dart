import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'firestore_service.dart';

/// 인앱 결제 서비스
class PurchaseService {
  static final PurchaseService instance = PurchaseService._();
  PurchaseService._();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// 상품 ID (App Store Connect / Google Play Console에서 설정)
  static const String monthlySubscriptionId = 'linkping_premium_monthly';
  static const String yearlySubscriptionId = 'linkping_premium_yearly';
  static const String lifetimeId = 'linkping_premium_lifetime';

  static const Set<String> _productIds = {
    monthlySubscriptionId,
    yearlySubscriptionId,
    lifetimeId,
  };

  /// 사용 가능한 상품 목록
  List<ProductDetails> products = [];

  /// 초기화 상태
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// 스토어 사용 가능 여부
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  /// 구매 진행 중 여부
  bool _isPurchasing = false;
  bool get isPurchasing => _isPurchasing;

  /// 콜백
  void Function(bool success, String? error)? onPurchaseComplete;
  void Function()? onPurchaseRestored;

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      debugPrint('PurchaseService: Store not available');
      _isInitialized = true;
      return;
    }

    // iOS에서 이전 거래 완료 처리
    if (Platform.isIOS) {
      final iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
    }

    // 구매 스트림 리스닝
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint('PurchaseService error: $error'),
    );

    // 상품 정보 로드
    await loadProducts();

    _isInitialized = true;
    debugPrint('PurchaseService: Initialized');
  }

  /// 상품 정보 로드
  Future<void> loadProducts() async {
    if (!_isAvailable) return;

    final response = await _inAppPurchase.queryProductDetails(_productIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('PurchaseService: Products not found: ${response.notFoundIDs}');
    }

    products = response.productDetails;
    debugPrint('PurchaseService: Loaded ${products.length} products');

    for (final product in products) {
      debugPrint('  - ${product.id}: ${product.price}');
    }
  }

  /// 구매 스트림 핸들러
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      debugPrint('PurchaseService: ${purchase.productID} - ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _isPurchasing = true;
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // 구매/복원 성공
          final valid = await _verifyPurchase(purchase);
          if (valid) {
            await _deliverProduct(purchase);
            if (purchase.status == PurchaseStatus.restored) {
              onPurchaseRestored?.call();
            } else {
              onPurchaseComplete?.call(true, null);
            }
          } else {
            onPurchaseComplete?.call(false, 'Verification failed');
          }
          _isPurchasing = false;
          break;

        case PurchaseStatus.error:
          _isPurchasing = false;
          onPurchaseComplete?.call(
            false,
            purchase.error?.message ?? 'Unknown error',
          );
          break;

        case PurchaseStatus.canceled:
          _isPurchasing = false;
          onPurchaseComplete?.call(false, 'Canceled');
          break;
      }

      // 거래 완료 처리 (필수!)
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  /// 구매 검증 (서버 검증 권장, 여기선 간단히 처리)
  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // TODO: 프로덕션에서는 서버에서 영수증 검증 필요
    // 지금은 클라이언트에서만 처리
    return true;
  }

  /// 상품 전달 (프리미엄 활성화)
  Future<void> _deliverProduct(PurchaseDetails purchase) async {
    debugPrint('PurchaseService: Delivering ${purchase.productID}');

    // Firestore에 프리미엄 상태 저장
    await FirestoreService.instance.setPremiumStatus(
      isPremium: true,
      productId: purchase.productID,
      purchaseToken: purchase.purchaseID,
    );
  }

  /// 상품 구매
  Future<bool> buyProduct(ProductDetails product) async {
    if (!_isAvailable) {
      debugPrint('PurchaseService: Store not available');
      return false;
    }

    if (_isPurchasing) {
      debugPrint('PurchaseService: Already purchasing');
      return false;
    }

    _isPurchasing = true;

    final purchaseParam = PurchaseParam(productDetails: product);

    try {
      // 구독 상품인지 확인
      if (product.id == lifetimeId) {
        // 일회성 구매 (평생)
        return await _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      } else {
        // 구독
        return await _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      }
    } catch (e) {
      _isPurchasing = false;
      debugPrint('PurchaseService: Buy error: $e');
      return false;
    }
  }

  /// 구매 복원
  Future<void> restorePurchases() async {
    if (!_isAvailable) return;
    await _inAppPurchase.restorePurchases();
  }

  /// 상품 ID로 ProductDetails 찾기
  ProductDetails? getProduct(String productId) {
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  /// 월간 구독 상품
  ProductDetails? get monthlyProduct => getProduct(monthlySubscriptionId);

  /// 연간 구독 상품
  ProductDetails? get yearlyProduct => getProduct(yearlySubscriptionId);

  /// 평생 구매 상품
  ProductDetails? get lifetimeProduct => getProduct(lifetimeId);

  /// 정리
  void dispose() {
    _subscription?.cancel();
  }
}

/// iOS 결제 큐 델리게이트
class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
