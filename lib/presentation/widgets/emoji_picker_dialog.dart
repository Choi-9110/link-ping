import 'package:flutter/material.dart';

import '../../core/theme/spacing.dart';
import '../../data/models/badge.dart';
import '../../l10n/app_localizations.dart';
import '../../services/badge_service.dart';
import '../../services/pixel_emoji_service.dart';

/// 픽셀 이모지 선택 다이얼로그
class EmojiPickerDialog extends StatefulWidget {
  final String currentEmoji;

  const EmojiPickerDialog({
    super.key,
    required this.currentEmoji,
  });

  @override
  State<EmojiPickerDialog> createState() => _EmojiPickerDialogState();
}

class _EmojiPickerDialogState extends State<EmojiPickerDialog> {
  List<UserBadge> _earnedBadges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEarnedBadges();
  }

  Future<void> _loadEarnedBadges() async {
    try {
      final stats = await BadgeService.instance.getStats();
      if (mounted) {
        setState(() {
          _earnedBadges = stats.badges;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 배지 이모지를 픽셀 ID로 변환
  String? _getBadgePixelId(String emoji) {
    return PixelEmojiService.emojiToPixel[emoji];
  }

  /// 오늘 획득한 배지인지 확인
  bool _isEarnedToday(DateTime earnedAt) {
    final now = DateTime.now();
    return earnedAt.year == now.year &&
        earnedAt.month == now.month &&
        earnedAt.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // 픽셀 이미지가 있는 배지만 필터링
    final badgesWithPixel = _earnedBadges.where((badge) {
      final pixelId = _getBadgePixelId(badge.type.emoji);
      return pixelId != null;
    }).toList();

    return AlertDialog(
      title: Text(l10n.selectProfileEmoji),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 획득한 배지 섹션 (있을 경우만)
              if (!_isLoading && badgesWithPixel.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.earnedBadges,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: Spacing.xs,
                    crossAxisSpacing: Spacing.xs,
                  ),
                  itemCount: badgesWithPixel.length,
                  itemBuilder: (context, index) {
                    final badge = badgesWithPixel[index];
                    final pixelId = _getBadgePixelId(badge.type.emoji)!;
                    final isSelected = pixelId == widget.currentEmoji ||
                        PixelEmojiService.emojiToPixel[widget.currentEmoji] ==
                            pixelId;
                    final isNew = _isEarnedToday(badge.earnedAt);

                    return GestureDetector(
                      onTap: () => Navigator.pop(context, pixelId),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary.withValues(alpha: 0.2)
                                  : colorScheme.primaryContainer
                                      .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected
                                  ? Border.all(
                                      color: colorScheme.primary, width: 2)
                                  : Border.all(
                                      color: colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(4),
                            child: PixelEmojiService.buildPixelEmoji(
                              pixelId,
                              size: 28,
                            ),
                          ),
                          // NEW 태그
                          if (isNew)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'N',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onError,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: Spacing.md),
                Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
                const SizedBox(height: Spacing.sm),
              ],

              // 로딩 표시
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: Spacing.sm),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),

              // 일반 이모지 섹션
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: Spacing.xs,
                  crossAxisSpacing: Spacing.xs,
                ),
                itemCount: PixelEmojiService.profilePixelEmojis.length,
                itemBuilder: (context, index) {
                  final pixelId = PixelEmojiService.profilePixelEmojis[index];
                  final isSelected = pixelId == widget.currentEmoji ||
                      PixelEmojiService.emojiToPixel[widget.currentEmoji] ==
                          pixelId;

                  return GestureDetector(
                    onTap: () => Navigator.pop(context, pixelId),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 2)
                            : null,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(4),
                      child: PixelEmojiService.buildPixelEmoji(
                        pixelId,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.sm,
        Spacing.md,
        Spacing.md,
      ),
    );
  }
}

/// 기존 이모지 목록 (하위 호환성)
const profileEmojis = [
  '😀', '😊', '🥰', '😎', '🤓', '🧐', '🤔', '😴',
  '🥳', '😇', '🤗', '🤭', '😏', '🙃', '😌', '🤩',
  '🐶', '🐱', '🐰', '🦊', '🐻', '🐼', '🐨', '🦁',
  '🐯', '🐮', '🐷', '🐸', '🐵', '🐔', '🐧', '🦄',
  '🌸', '🌺', '🌻', '🌷', '🍀', '🌵', '🍎', '🍑',
  '🍓', '🍕', '🍩', '🧁', '🍦', '☕', '🧋', '🍿',
  '⚽', '🏀', '🎾', '🎮', '🎸', '🎨', '📚', '💻',
  '🎯', '🏆', '💪', '🔥', '⭐', '💎', '🎁', '🚀',
];
