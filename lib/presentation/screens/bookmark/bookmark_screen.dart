import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark.dart';
import '../../../providers/bookmark_provider.dart';
import '../../widgets/toast_overlay.dart';
import 'bookmark_category_screen.dart';
import 'add_bookmark_screen.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider);
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
      body: bookmarks.isEmpty
          ? _buildEmptyState(context, isKorean)
          : _buildCategoryList(context, ref, isKorean),
      floatingActionButton: FloatingActionButton(
        heroTag: 'bookmark_fab',
        onPressed: () => _onAddBookmark(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isKorean) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark_outline,
            size: 64,
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            isKorean ? '저장한 북마크가 없어요' : 'No bookmarks yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            isKorean
                ? '링크를 카테고리별로 저장해보세요!'
                : 'Save links by category!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    WidgetRef ref,
    bool isKorean,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 북마크가 있는 카테고리만 표시
    final categoriesWithCount = BookmarkCategory.values
        .map((category) {
          final count = ref.watch(bookmarkCountByCategoryProvider(category));
          return (category: category, count: count);
        })
        .where((item) => item.count > 0)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(Spacing.md),
      itemCount: categoriesWithCount.length,
      itemBuilder: (context, index) {
        final item = categoriesWithCount[index];
        return _buildCategoryCard(
          context,
          category: item.category,
          count: item.count,
          isKorean: isKorean,
          theme: theme,
          colorScheme: colorScheme,
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required BookmarkCategory category,
    required int count,
    required bool isKorean,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
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
            child: Text(category.emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(
          category.label(isKorean),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          isKorean ? '$count개 링크' : '$count links',
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
              builder: (_) => BookmarkCategoryScreen(category: category),
            ),
          );
        },
      ),
    );
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
