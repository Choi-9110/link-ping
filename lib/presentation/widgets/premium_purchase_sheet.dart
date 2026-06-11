import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/theme/spacing.dart';
import '../../l10n/app_localizations.dart';
import '../../services/badge_service.dart';
import '../../services/purchase_service.dart';

/// 프리미엄 구매 바텀시트
class PremiumPurchaseSheet extends ConsumerStatefulWidget {
  const PremiumPurchaseSheet({super.key});

  @override
  ConsumerState<PremiumPurchaseSheet> createState() =>
      _PremiumPurchaseSheetState();
}

class _PremiumPurchaseSheetState extends ConsumerState<PremiumPurchaseSheet> {
  bool _isLoading = false;
  String? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _initPurchase();
  }

  Future<void> _initPurchase() async {
    setState(() => _isLoading = true);

    // 결제 서비스 초기화
    await PurchaseService.instance.initialize();

    // 콜백 설정
    PurchaseService.instance.onPurchaseComplete = _onPurchaseComplete;
    PurchaseService.instance.onPurchaseRestored = _onPurchaseRestored;

    setState(() => _isLoading = false);
  }

  void _onPurchaseComplete(bool success, String? error) {
    if (!mounted) return;

    if (success) {
      // 프리미엄 뱃지 지급
      BadgeService.instance.recordPremiumPurchase();

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.premiumPurchaseSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? AppLocalizations.of(context)!.premiumPurchaseFailed),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  void _onPurchaseRestored() {
    if (!mounted) return;

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.premiumRestoreSuccess),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _buyProduct(ProductDetails product) async {
    setState(() {
      _isLoading = true;
      _selectedProductId = product.id;
    });

    await PurchaseService.instance.buyProduct(product);
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);
    await PurchaseService.instance.restorePurchases();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final purchaseService = PurchaseService.instance;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 상품 목록 + 혜택 통합 스크롤
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              children: [
                // 헤더
                const SizedBox(height: Spacing.lg),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.shade300,
                          Colors.amber.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  l10n.premiumHeadline,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  l10n.premiumSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: Spacing.lg),

                // 혜택 목록 (6개, 2줄씩)
                _buildBenefitItem(
                  icon: Icons.favorite,
                  iconColor: Colors.pink,
                  title: l10n.premiumBenefit1,
                  desc: l10n.premiumBenefit1Desc,
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                _buildBenefitItem(
                  icon: Icons.all_inclusive,
                  iconColor: colorScheme.primary,
                  title: l10n.premiumBenefit2,
                  desc: l10n.premiumBenefit2Desc,
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                _buildBenefitItem(
                  icon: Icons.alarm_add,
                  iconColor: Colors.teal,
                  title: l10n.premiumBenefit3,
                  desc: l10n.premiumBenefit3Desc,
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                _buildBenefitItem(
                  icon: Icons.toll,
                  iconColor: Colors.amber.shade700,
                  title: l10n.premiumBenefit4,
                  desc: l10n.premiumBenefit4Desc,
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                _buildBenefitItem(
                  icon: Icons.block,
                  iconColor: Colors.blue,
                  title: l10n.premiumBenefit5,
                  desc: l10n.premiumBenefit5Desc,
                  theme: theme,
                  colorScheme: colorScheme,
                ),
                _buildBenefitItem(
                  icon: Icons.cloud_done,
                  iconColor: Colors.purple,
                  title: l10n.premiumBenefit6,
                  desc: l10n.premiumBenefit6Desc,
                  theme: theme,
                  colorScheme: colorScheme,
                ),

                const SizedBox(height: Spacing.lg),

                // 상품 카드
                ..._buildProductList(purchaseService, l10n, colorScheme, theme),

                const SizedBox(height: Spacing.sm),

                // 복원 버튼
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : _restorePurchases,
                    child: Text(l10n.restorePurchases),
                  ),
                ),

                const SizedBox(height: Spacing.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProductList(
    PurchaseService purchaseService,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    if (_isLoading && purchaseService.products.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(Spacing.lg),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (!purchaseService.isAvailable) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Text(l10n.storeNotAvailable, style: theme.textTheme.bodyLarge),
          ),
        ),
      ];
    }
    if (purchaseService.products.isEmpty) {
      return [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.productsNotFound),
              const SizedBox(height: Spacing.md),
              TextButton(
                onPressed: () async {
                  setState(() => _isLoading = true);
                  await purchaseService.loadProducts();
                  setState(() => _isLoading = false);
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ];
    }
    return [
      if (purchaseService.yearlyProduct != null)
        _buildProductCard(
          product: purchaseService.yearlyProduct!,
          label: l10n.premiumYearly,
          isRecommended: true,
          colorScheme: colorScheme,
          theme: theme,
        ),
      if (purchaseService.monthlyProduct != null)
        _buildProductCard(
          product: purchaseService.monthlyProduct!,
          label: l10n.premiumMonthly,
          colorScheme: colorScheme,
          theme: theme,
        ),
      if (purchaseService.lifetimeProduct != null)
        _buildProductCard(
          product: purchaseService.lifetimeProduct!,
          label: l10n.premiumLifetime,
          colorScheme: colorScheme,
          theme: theme,
        ),
    ];
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String desc,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  desc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required ProductDetails product,
    required String label,
    required ColorScheme colorScheme,
    required ThemeData theme,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedProductId == product.id;
    final isCurrentlyLoading = _isLoading && isSelected;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : () => _buyProduct(product),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: isRecommended
                  ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRecommended
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                width: isRecommended ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            label,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isRecommended) ...[
                            const SizedBox(width: Spacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'BEST',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.price,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentlyLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.outline,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
