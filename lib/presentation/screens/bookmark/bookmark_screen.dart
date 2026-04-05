import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark.dart';
import '../../../providers/bookmark_provider.dart';
import '../../../providers/recommended_provider.dart';
import '../../widgets/toast_overlay.dart';
import 'bookmark_category_screen.dart';
import 'add_bookmark_screen.dart';
import 'recommended_list_screen.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider);
    final recommendedAsync = ref.watch(recommendedLinksProvider);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isKorean ? '북마크' : 'Bookmarks',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          // 추천 폴더 카드 (항상 최상단)
          _buildRecommendedFolder(
            context,
            recommendedAsync: recommendedAsync,
            isKorean: isKorean,
            theme: theme,
            colorScheme: theme.colorScheme,
          ),

          // 내 북마크 카테고리들
          ..._buildCategoryCards(context, ref, isKorean, theme),

          // 북마크 없을 때 안내
          if (bookmarks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
              child: Center(
                child: Text(
                  isKorean
                      ? '+ 버튼으로 북마크를 추가해보세요'
                      : 'Tap + to add your first bookmark',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'bookmark_fab',
        onPressed: () => _onAddBookmark(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 추천 폴더 카드 — 탭하면 추천 리스트 화면으로 이동
  Widget _buildRecommendedFolder(
    BuildContext context, {
    required AsyncValue recommendedAsync,
    required bool isKorean,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    // 추천 링크 개수
    final count = recommendedAsync.whenOrNull<int>(
          data: (recommended) => recommended.length,
        ) ??
        0;

    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      elevation: 0,
      color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('⭐', style: TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(
          isKorean ? '추천' : 'Recommended',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          count > 0
              ? (isKorean ? '$count개 링크' : '$count links')
              : (isKorean ? '건강한 습관 만들기' : 'Build healthy habits'),
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.outline,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.outline,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RecommendedListScreen(),
            ),
          );
        },
      ),
    );
  }

  /// 내 북마크 카테고리 카드들
  List<Widget> _buildCategoryCards(
    BuildContext context,
    WidgetRef ref,
    bool isKorean,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    final categoriesWithCount = BookmarkCategory.values
        .map((category) {
          final count = ref.watch(bookmarkCountByCategoryProvider(category));
          return (category: category, count: count);
        })
        .where((item) => item.count > 0)
        .toList();

    return categoriesWithCount.map((item) {
      return Card(
        margin: const EdgeInsets.only(bottom: Spacing.sm),
        elevation: 0,
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.xs,
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(item.category.emoji,
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
          title: Text(
            item.category.label(isKorean),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            isKorean ? '${item.count}개 링크' : '${item.count} links',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    BookmarkCategoryScreen(category: item.category),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  void _onAddBookmark(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddBookmarkScreen()),
    );
    if (result == true && context.mounted) {
      final locale = Localizations.localeOf(context);
      final isKorean = locale.languageCode == 'ko';
      ToastOverlay.showSuccess(
        context,
        isKorean ? '북마크가 추가되었어요' : 'Bookmark added',
      );
    }
  }
}
