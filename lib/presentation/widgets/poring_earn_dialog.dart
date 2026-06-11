import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/brand_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/poring_provider.dart';
import '../../services/ad_service.dart';
import '../../services/poring_service.dart';
import 'linkku_logo.dart';
import 'toast_overlay.dart';

/// 포링 획득 전용 다이얼로그
class PoringEarnDialog extends ConsumerStatefulWidget {
  const PoringEarnDialog({super.key});

  @override
  ConsumerState<PoringEarnDialog> createState() => _PoringEarnDialogState();
}

class _PoringEarnDialogState extends ConsumerState<PoringEarnDialog> {
  bool _isLoadingAd = false;

  @override
  void initState() {
    super.initState();
    // 광고 미리 로드
    AdService.instance.loadRewardedAd(useTestAd: AdService.instance.useTestAds);
  }

  Future<void> _watchAd() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoadingAd) return;

    setState(() => _isLoadingAd = true);

    // 광고가 준비되지 않았으면 로딩 시도
    if (!AdService.instance.isRewardedAdReady) {
      await AdService.instance.loadRewardedAd(
        useTestAd: AdService.instance.useTestAds,
      );
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!AdService.instance.isRewardedAdReady) {
        if (mounted) {
          setState(() => _isLoadingAd = false);
          ToastOverlay.showError(context, l10n.adLoadFailed);
        }
        return;
      }
    }

    // 광고 표시
    await AdService.instance.showRewardedAd(
      useTestAd: AdService.instance.useTestAds,
      onRewarded: () async {
        if (mounted) {
          final success = await ref.read(poringProvider.notifier).earnPoring();
          if (success && mounted) {
            ToastOverlay.showSuccess(context, l10n.poringEarned);
          }
        }
      },
      onAdDismissed: () {
        // 다음 광고 미리 로드
        AdService.instance.loadRewardedAd(
          useTestAd: AdService.instance.useTestAds,
        );
      },
      onAdFailed: (error) {
        if (mounted) {
          ToastOverlay.showError(context, l10n.adLoadFailed);
        }
      },
    );

    if (mounted) {
      setState(() => _isLoadingAd = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final poringState = ref.watch(poringProvider);

    final dailyCount = poringState.dailyCount;
    final maxDaily = PoringService.maxDailyAds;
    final cooldown = poringState.cooldownSeconds;
    final balance = poringState.balance;
    final dailyLimitReached = poringState.dailyLimitReached;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          // 재화 "핑" 퍼플 오브
          const LinkkuCurrency(size: 24),
          const SizedBox(width: 8),
          Text(l10n.poringEarn),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 보유 핑 (재화 = 퍼플)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BrandTokens.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: BrandTokens.purple.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LinkkuCurrency(size: 28),
                const SizedBox(width: 8),
                Text(
                  '$balance',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: BrandTokens.purpleShade,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.poring,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: BrandTokens.purple,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 설명
          Text(
            l10n.poringEarnDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 일일 진행률
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: dailyCount / maxDaily,
                    minHeight: 8,
                    backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(
                      dailyLimitReached
                          ? BrandTokens.mint
                          : BrandTokens.purple,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.poringDailyProgress(dailyCount, maxDaily),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 광고 시청 버튼 또는 상태
          if (dailyLimitReached)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrandTokens.mint.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 완료 = 민트
                  const Icon(Icons.check_circle,
                      color: BrandTokens.mint, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.poringDailyLimitThanks(maxDaily),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: BrandTokens.mintShade,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: (cooldown > 0 || _isLoadingAd) ? null : _watchAd,
                icon: _isLoadingAd
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        cooldown > 0 ? Icons.timer : Icons.play_circle_outline,
                      ),
                label: Text(
                  cooldown > 0
                      ? l10n.poringCooldown(cooldown)
                      : l10n.poringWatchAd,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: BrandTokens.purple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: colorScheme.outline.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
