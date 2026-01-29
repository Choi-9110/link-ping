import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/badge.dart';
import '../../../services/badge_service.dart';

/// 뱃지 컬렉션 화면
class BadgeCollectionScreen extends ConsumerStatefulWidget {
  const BadgeCollectionScreen({super.key});

  @override
  ConsumerState<BadgeCollectionScreen> createState() =>
      _BadgeCollectionScreenState();
}

class _BadgeCollectionScreenState extends ConsumerState<BadgeCollectionScreen> {
  UserStats? _stats;
  List<({BadgeType type, UserBadge? earned})>? _badges;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await BadgeService.instance.getStats();
    final badges = await BadgeService.instance.getAllBadges();

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('뱃지 컬렉션'),
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
          // 스트릭 & 달성률
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                '🔥',
                '${stats.currentStreak}일',
                '연속 스트릭',
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
                '달성률',
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
                '뱃지 수집',
                Colors.white,
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          // 프로그레스 바
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
            '최장 스트릭: ${stats.longestStreak}일',
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
    ({BadgeType type, UserBadge? earned}) badge,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isEarned = badge.earned != null;

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
            Text(
              badge.type.emoji,
              style: TextStyle(
                fontSize: 36,
                color: isEarned ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            // 이름
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                badge.type.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isEarned ? null : colorScheme.outline,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 획득 날짜
            if (isEarned)
              Text(
                _formatDate(badge.earned!.earnedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(
    ({BadgeType type, UserBadge? earned}) badge,
    ThemeData theme,
  ) {
    final isEarned = badge.earned != null;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 이모지 (크게)
            Text(
              badge.type.emoji,
              style: TextStyle(
                fontSize: 72,
                color: isEarned ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: Spacing.md),
            // 이름
            Text(
              badge.type.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            // 설명
            Text(
              badge.type.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.lg),
            // 획득 상태
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
                  '${_formatDate(badge.earned!.earnedAt)} 획득',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  '아직 획득하지 않음',
                  style: TextStyle(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
