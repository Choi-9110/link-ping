import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/utils/badge_localizations.dart';
import '../../../data/models/badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/badge_service.dart';
import '../../../services/pixel_emoji_service.dart';

/// 뱃지 컬렉션 화면
class BadgeCollectionScreen extends ConsumerStatefulWidget {
  const BadgeCollectionScreen({super.key});

  @override
  ConsumerState<BadgeCollectionScreen> createState() =>
      _BadgeCollectionScreenState();
}

class _BadgeCollectionScreenState extends ConsumerState<BadgeCollectionScreen> {
  UserStats? _stats;
  List<({BadgeType type, UserBadge? earned, int progress, int target})>? _badges;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // 먼저 Firestore 통계 기반으로 뱃지 동기화
    await BadgeService.instance.syncBadgesFromStats();

    final stats = await BadgeService.instance.getStats();
    final badges = await BadgeService.instance.getAllBadgesWithProgress();

    if (mounted) {
      setState(() {
        _stats = stats;
        _badges = badges;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.badgeCollection),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  // 통계 카드
                  SliverToBoxAdapter(
                    child: _buildStatsCard(theme, colorScheme),
                  ),

                  // 뱃지 그리드
                  SliverPadding(
                    padding: const EdgeInsets.all(Spacing.md),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: Spacing.sm,
                        crossAxisSpacing: Spacing.sm,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final badge = _badges![index];
                          return _buildBadgeCard(badge, theme, colorScheme);
                        },
                        childCount: _badges?.length ?? 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsCard(ThemeData theme, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final stats = _stats ?? const UserStats();
    final earnedCount = stats.badges.length;
    final totalCount = BadgeType.values.length;

    return Container(
      margin: const EdgeInsets.all(Spacing.md),
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Streak & Achievement
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                '🔥',
                l10n.daysCount(stats.currentStreak),
                l10n.currentStreak,
                Colors.white,
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white24,
              ),
              _buildStatItem(
                '📊',
                '${stats.achievementRate.toStringAsFixed(0)}%',
                l10n.achievementRate,
                Colors.white,
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white24,
              ),
              _buildStatItem(
                '🏆',
                '$earnedCount/$totalCount',
                l10n.badgeCollected,
                Colors.white,
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: earnedCount / totalCount,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.longestStreak(stats.longestStreak),
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String emoji, String value, String label, Color textColor) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard(
    ({BadgeType type, UserBadge? earned, int progress, int target}) badge,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isEarned = badge.earned != null;
    final hasProgress = !isEarned && badge.target > 0 && badge.progress > 0;
    final progressRatio = badge.target > 0 ? badge.progress / badge.target : 0.0;

    return GestureDetector(
      onTap: () => _showBadgeDetail(badge, theme),
      child: Container(
        decoration: BoxDecoration(
          color: isEarned
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: isEarned
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이모지
            Opacity(
              opacity: isEarned ? 1.0 : 0.4,
              child: PixelEmojiService.buildPixelEmoji(
                badge.type.emoji,
                size: 40,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            // 이름
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                badge.type.localizedName(context),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isEarned ? null : colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 획득 날짜 또는 진행률
            if (isEarned)
              Text(
                _formatDate(badge.earned!.earnedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else if (hasProgress)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Column(
                  children: [
                    Text(
                      '${badge.progress}/${badge.target}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progressRatio,
                        minHeight: 4,
                        backgroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(
    ({BadgeType type, UserBadge? earned, int progress, int target}) badge,
    ThemeData theme,
  ) {
    final isEarned = badge.earned != null;
    final hasProgress = !isEarned && badge.target > 0 && badge.progress > 0;
    final progressRatio = badge.target > 0 ? badge.progress / badge.target : 0.0;

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext)!;
        return Container(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 이모지 (크게)
              Opacity(
                opacity: isEarned ? 1.0 : 0.4,
                child: PixelEmojiService.buildPixelEmoji(
                  badge.type.emoji,
                  size: 80,
                ),
              ),
              const SizedBox(height: Spacing.md),
              // 이름
              Text(
                badge.type.localizedName(sheetContext),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              // 설명
              Text(
                badge.type.localizedDescription(sheetContext),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.lg),
              // 획득 상태 또는 진행률
              if (isEarned)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.badgeEarnedOn(_formatDate(badge.earned!.earnedAt)),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (hasProgress)
                Column(
                  children: [
                    Text(
                      l10n.badgeProgress(badge.progress, badge.target),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    SizedBox(
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressRatio,
                          minHeight: 10,
                          backgroundColor: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      l10n.badgeProgressPercent((progressRatio * 100).toInt()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.badgeNotYetEarned,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: Spacing.xl),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
