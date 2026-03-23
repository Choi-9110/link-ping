import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/spacing.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/poring_provider.dart';
import '../../services/ad_service.dart';
import '../../services/alarm_sound_service.dart';
import '../../services/firestore_service.dart';
import 'premium_purchase_sheet.dart';
import 'toast_overlay.dart';

/// 1단계: 카테고리 선택 다이얼로그
/// 효과음 vs 알람 선택
class SoundCategoryDialog extends StatelessWidget {
  final bool isPremium;
  final String langCode;
  final String? initialSoundId;

  const SoundCategoryDialog({
    super.key,
    required this.isPremium,
    required this.langCode,
    this.initialSoundId,
  });

  /// 카테고리 선택 후 소리 선택까지 진행
  static Future<String?> show(
    BuildContext context, {
    String? initialSoundId,
    required bool isPremium,
    required String langCode,
  }) async {
    // 1단계: 카테고리 선택
    final category = await showDialog<SoundCategory>(
      context: context,
      builder: (context) => SoundCategoryDialog(
        isPremium: isPremium,
        langCode: langCode,
        initialSoundId: initialSoundId,
      ),
    );

    if (category == null || !context.mounted) return null;

    // 2단계: 선택한 카테고리의 소리 선택
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SoundPickerBottomSheet(
        category: category,
        initialSoundId: initialSoundId,
        isPremium: isPremium,
        langCode: langCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 제목
            Text(
              l10n.alarmSound,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              l10n.selectSoundCategory,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // 카테고리 선택 버튼들
            Row(
              children: [
                // 효과음
                Expanded(
                  child: _CategoryCard(
                    icon: Icons.notifications_active,
                    title: l10n.soundCategoryNotify,
                    description: l10n.soundCategoryNotifyDesc,
                    color: colorScheme.tertiary,
                    onTap: () => Navigator.pop(context, SoundCategory.effect),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                // 알람
                Expanded(
                  child: _CategoryCard(
                    icon: Icons.alarm,
                    title: l10n.soundCategoryAlarm,
                    description: l10n.soundCategoryAlarmDesc,
                    color: colorScheme.primary,
                    onTap: () => Navigator.pop(context, SoundCategory.alarm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 카테고리 카드 위젯
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2단계: 소리 선택 바텀시트
/// 선택한 카테고리의 소리만 표시
class SoundPickerBottomSheet extends ConsumerStatefulWidget {
  final SoundCategory category;
  final String? initialSoundId;
  final bool isPremium;
  final String langCode;

  const SoundPickerBottomSheet({
    super.key,
    required this.category,
    this.initialSoundId,
    required this.isPremium,
    required this.langCode,
  });

  @override
  ConsumerState<SoundPickerBottomSheet> createState() =>
      _SoundPickerBottomSheetState();
}

class _SoundPickerBottomSheetState
    extends ConsumerState<SoundPickerBottomSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late String _previewSoundId;
  String? _playingSoundId;
  StreamSubscription? _playerCompleteSubscription;

  // 포링으로 프리미엄 소리 해금한 경우 저장 전까지 자유 변경 가능
  bool _premiumUnlockedInSession = false;

  // 캐시된 사운드 리스트
  late final List<AlarmSound> _freeSounds;
  late final List<AlarmSound> _premiumSounds;

  @override
  void initState() {
    super.initState();
    _previewSoundId =
        widget.initialSoundId ??
        AlarmSoundService.instance.getSelectedSoundId();

    // 선택한 카테고리의 사운드만 가져오기
    final sounds = widget.category == SoundCategory.alarm
        ? AlarmSoundService.instance.getAlarmSounds()
        : AlarmSoundService.instance.getEffectSounds();

    _freeSounds = sounds.where((s) => !s.isPremium).toList();
    _premiumSounds = sounds.where((s) => s.isPremium).toList();

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _playingSoundId = null);
      }
    });

    // 프리미엄 유저가 아니면 보상형 광고 미리 로드
    if (!widget.isPremium) {
      AdService.instance.loadRewardedAd(
        useTestAd: AdService.instance.useTestAds,
      );
    }
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(AlarmSound sound) async {
    // 같은 소리 재생 중이면 중지
    if (_playingSoundId == sound.id) {
      await _audioPlayer.stop();
      setState(() => _playingSoundId = null);
      return;
    }

    // 선택된 소리 변경 + 재생
    setState(() {
      _previewSoundId = sound.id;
      _playingSoundId = sound.id;
    });

    try {
      // mp3 먼저 시도, 없으면 wav 시도
      try {
        await _audioPlayer.play(AssetSource('sounds/${sound.fileName}.mp3'));
      } catch (_) {
        await _audioPlayer.play(AssetSource('sounds/${sound.fileName}.wav'));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _playingSoundId = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.soundNotAvailable),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _confirm() {
    _audioPlayer.stop();

    // 프리미엄 소리인데 프리미엄 유저가 아닌 경우 다이얼로그 표시
    // 단, 이미 이 세션에서 포링으로 해금했으면 자유 변경 가능
    final sound = AlarmSoundService.instance.getSoundById(_previewSoundId);
    if (sound != null &&
        sound.isPremium &&
        !widget.isPremium &&
        !_premiumUnlockedInSession) {
      _showPremiumUnlockDialog(sound);
      return;
    }

    Navigator.pop(context, _previewSoundId);
  }

  /// 프리미엄 소리 해금 다이얼로그
  void _showPremiumUnlockDialog(AlarmSound sound) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.workspace_premium, color: colorScheme.secondary),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                l10n.premiumSoundUnlock,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 선택한 소리 표시
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.music_note, color: colorScheme.secondary),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      sound.getName(widget.langCode),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              l10n.premiumSoundUnlockDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          // 프리미엄 등록 버튼
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              // 프리미엄 구매 시트 열기
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const PremiumPurchaseSheet(),
              );
            },
            icon: const Icon(Icons.star, size: 18),
            label: Text(l10n.upgradeToPremium),
          ),
          // 포링으로 해금 버튼
          FilledButton.icon(
            onPressed: () => _unlockWithPoring(dialogContext),
            icon: Icon(
              Icons.notifications_active,
              size: 18,
              color: Colors.amber.shade200,
            ),
            label: Text(l10n.poringUnlock),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.all(Spacing.md),
      ),
    );
  }

  /// 포링으로 소리 해금 또는 광고 시청 후 획득+해금
  Future<void> _unlockWithPoring(BuildContext dialogContext) async {
    final l10n = AppLocalizations.of(context)!;
    final poringNotifier = ref.read(poringProvider.notifier);
    final poringState = ref.read(poringProvider);

    Navigator.pop(dialogContext);

    if (poringState.balance > 0) {
      // 포링 차감
      final success = await poringNotifier.spendPoring();
      if (success && mounted) {
        FirestoreService.instance.trackSoundChanged(soundId: _previewSoundId);
        ToastOverlay.showSuccess(context, l10n.poringSpent);
        // 세션 내 자유 변경 허용 — 바로 나가지 않고 다른 소리도 선택 가능
        setState(() => _premiumUnlockedInSession = true);
      }
    } else {
      // 광고 보고 포링 획득+차감
      if (!AdService.instance.isRewardedAdReady) {
        await AdService.instance.loadRewardedAd(
          useTestAd: AdService.instance.useTestAds,
        );
        await Future.delayed(const Duration(milliseconds: 1000));

        if (!AdService.instance.isRewardedAdReady) {
          if (mounted) {
            ToastOverlay.showError(context, l10n.adNotReady);
          }
          return;
        }
      }

      await AdService.instance.showRewardedAd(
        useTestAd: AdService.instance.useTestAds,
        onRewarded: () async {
          if (mounted) {
            await poringNotifier.earnPoring();
            await poringNotifier.spendPoring();
            FirestoreService.instance.trackSoundChanged(
              soundId: _previewSoundId,
            );
            ToastOverlay.showSuccess(context, l10n.poringSpent);
            // 세션 내 자유 변경 허용
            setState(() => _premiumUnlockedInSession = true);
          }
        },
        onAdFailed: (error) {
          if (mounted) {
            ToastOverlay.showError(context, l10n.adNotReady);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final previewSound = AlarmSoundService.instance.getSoundById(
      _previewSoundId,
    );

    final isAlarmCategory = widget.category == SoundCategory.alarm;
    final categoryTitle = isAlarmCategory
        ? l10n.soundCategoryAlarm
        : l10n.soundCategoryNotify;
    final categoryIcon = isAlarmCategory
        ? Icons.alarm
        : Icons.notifications_active;
    final categoryColor = isAlarmCategory
        ? colorScheme.primary
        : colorScheme.tertiary;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
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
          // 헤더
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(categoryIcon, color: categoryColor),
                const SizedBox(width: Spacing.xs),
                Text(
                  categoryTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: categoryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 선택된 소리 미리보기
          Container(
            margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  _playingSoundId != null ? Icons.volume_up : Icons.music_note,
                  color: categoryColor,
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.currentSound,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: categoryColor,
                        ),
                      ),
                      Text(
                        previewSound?.getName(widget.langCode) ??
                            l10n.alarmSound,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_playingSoundId != null)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: categoryColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.sm),
          // 소리 목록
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              cacheExtent: 500,
              children: [
                // 무료 소리
                _buildSoundGrid(_freeSounds, categoryColor),
                if (_premiumSounds.isNotEmpty) ...[
                  const SizedBox(height: Spacing.md),
                  _buildPremiumHeader(l10n),
                  const SizedBox(height: Spacing.sm),
                  _buildSoundGrid(_premiumSounds, categoryColor),
                ],
                const SizedBox(height: Spacing.lg),
              ],
            ),
          ),
          // 하단 확인 버튼
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: FilledButton(
                onPressed: _confirm,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: categoryColor,
                ),
                child: Text(l10n.ok),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(Icons.workspace_premium, size: 16, color: colorScheme.secondary),
        const SizedBox(width: 4),
        Text(
          l10n.premiumSounds,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.secondary,
          ),
        ),
        if (!widget.isPremium) ...[
          const SizedBox(width: 8),
          Icon(Icons.lock, size: 14, color: colorScheme.outline),
        ],
      ],
    );
  }

  Widget _buildSoundGrid(List<AlarmSound> sounds, Color accentColor) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: sounds.map((sound) {
        final isSelected = _previewSoundId == sound.id;
        final isPlaying = _playingSoundId == sound.id;
        final isLocked =
            sound.isPremium && !widget.isPremium && !_premiumUnlockedInSession;

        return GestureDetector(
          onTap: () => _playSound(sound),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? accentColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : colorScheme.outline.withValues(alpha: 0.5),
                width: isPlaying ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // NEW 태그
                if (sound.isNew) ...[
                  _buildTag('NEW', Colors.green, isSelected),
                  const SizedBox(width: 4),
                ],
                // HOT 태그
                if (sound.isHot && !sound.isNew) ...[
                  _buildTag('HOT', Colors.deepOrange, isSelected),
                  const SizedBox(width: 4),
                ],
                if (isPlaying) ...[
                  Icon(
                    Icons.volume_up,
                    size: 16,
                    color: isSelected ? colorScheme.onPrimary : accentColor,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  sound.getName(widget.langCode),
                  style: TextStyle(
                    color: isSelected ? colorScheme.onPrimary : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
                if (isLocked) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.lock,
                    size: 14,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.outline,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// NEW/HOT 태그 빌더
  Widget _buildTag(String text, Color color, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.3) : color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.white,
        ),
      ),
    );
  }
}
