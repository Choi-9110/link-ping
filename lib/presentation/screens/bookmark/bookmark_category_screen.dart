import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark.dart';
import '../../../providers/bookmark_provider.dart';
import '../../../services/url_launcher_service.dart';
import '../add_link/add_link_screen.dart';
import '../../widgets/toast_overlay.dart';

class BookmarkCategoryScreen extends ConsumerWidget {
  final BookmarkCategory category;

  const BookmarkCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksByCategoryProvider(category));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return Scaffold(
      appBar: AppBar(
        title: Text(category.displayName(isKorean)),
      ),
      body: bookmarks.isEmpty
          ? Center(
              child: Text(
                isKorean ? '이 카테고리에 북마크가 없어요' : 'No bookmarks in this category',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return _buildBookmarkCard(
                  context,
                  ref,
                  bookmark: bookmark,
                  isKorean: isKorean,
                  theme: theme,
                  colorScheme: colorScheme,
                );
              },
            ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context,
    WidgetRef ref, {
    required Bookmark bookmark,
    required bool isKorean,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showActions(context, ref, bookmark, isKorean),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookmark.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                bookmark.url,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (bookmark.memo != null && bookmark.memo!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  bookmark.memo!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showActions(
    BuildContext context,
    WidgetRef ref,
    Bookmark bookmark,
    bool isKorean,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          bookmark.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        content: Row(
          children: [
            // 알람 만들기
            Expanded(
              child: _buildActionButton(
                context: dialogContext,
                icon: Icons.notifications_outlined,
                label: isKorean ? '알람 만들기' : 'Create Alarm',
                color: colorScheme.primary,
                onTap: () {
                  Navigator.pop(dialogContext);
                  _createAlarm(context, bookmark);
                },
              ),
            ),
            const SizedBox(width: Spacing.sm),
            // 이동하기
            Expanded(
              child: _buildActionButton(
                context: dialogContext,
                icon: Icons.open_in_new,
                label: isKorean ? '이동하기' : 'Open Link',
                color: colorScheme.secondary,
                onTap: () {
                  Navigator.pop(dialogContext);
                  UrlLauncherService.openUrl(bookmark.url);
                },
              ),
            ),
          ],
        ),
        actions: [
          // 삭제 버튼
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteBookmark(context, ref, bookmark, isKorean);
            },
            child: Text(
              isKorean ? '삭제' : 'Delete',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createAlarm(BuildContext context, Bookmark bookmark) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddLinkScreen(initialUrl: bookmark.url),
      ),
    );
  }

  void _deleteBookmark(
    BuildContext context,
    WidgetRef ref,
    Bookmark bookmark,
    bool isKorean,
  ) {
    ref.read(bookmarksProvider.notifier).deleteBookmark(bookmark.id);
    ToastOverlay.showSuccess(
      context,
      isKorean ? '북마크가 삭제되었어요' : 'Bookmark deleted',
    );
  }
}
