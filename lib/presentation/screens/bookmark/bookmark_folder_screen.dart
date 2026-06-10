import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark.dart';
import '../../../data/models/bookmark_folder.dart';
import '../../../providers/bookmark_folder_provider.dart';
import '../../../providers/bookmark_provider.dart';
import '../../../services/bookmark_tutorial_service.dart';
import '../../../services/url_launcher_service.dart';
import '../../widgets/toast_overlay.dart';
import '../add_link/add_link_screen.dart';
import 'add_bookmark_screen.dart';
import 'folder_edit_sheet.dart';

class BookmarkFolderScreen extends ConsumerStatefulWidget {
  final String folderId;
  const BookmarkFolderScreen({super.key, required this.folderId});

  @override
  ConsumerState<BookmarkFolderScreen> createState() =>
      _BookmarkFolderScreenState();
}

class _BookmarkFolderScreenState extends ConsumerState<BookmarkFolderScreen> {
  @override
  Widget build(BuildContext context) {
    final folder = ref.watch(folderByIdProvider(widget.folderId));
    final bookmarks = ref.watch(bookmarksByFolderProvider(widget.folderId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    if (folder == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(isKorean ? '폴더를 찾을 수 없어요' : 'Folder not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.displayName()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: isKorean ? '폴더 편집' : 'Edit Folder',
            onPressed: () => FolderEditSheet.show(context, folder: folder),
          ),
        ],
      ),
      // 빈 상태 안내는 _buildEmpty 의 텍스트 + FAB 로 충분. 별도 튜토리얼 배너는 제거
      // (Stack + Positioned 조합에서 RenderPhysicalShape 미배치 에러가 반복적으로 발생).
      body: bookmarks.isEmpty
          ? _buildEmpty(isKorean, theme, colorScheme)
          : ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return _buildBookmarkCard(
                  context,
                  bookmark: bookmarks[index],
                  folder: folder,
                  isKorean: isKorean,
                  theme: theme,
                  colorScheme: colorScheme,
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'folder_add_link_fab',
        onPressed: _onAddBookmark,
        icon: const Icon(Icons.add_link),
        label: Text(isKorean ? '링크 추가' : 'Add Link'),
      ),
    );
  }

  Widget _buildEmpty(bool isKorean, ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.link,
            size: 56,
            color: colorScheme.outline.withValues(alpha: 0.4),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            isKorean
                ? '아직 링크가 없어요\n오른쪽 아래 + 버튼으로 추가해보세요'
                : 'No links yet\nTap + below to add one',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(
    BuildContext context, {
    required Bookmark bookmark,
    required BookmarkFolder folder,
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
        onTap: () => _showActions(bookmark, folder, isKorean),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookmark.title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                bookmark.url,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (bookmark.memo != null && bookmark.memo!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  bookmark.memo!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                  maxLines: 3,
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
      Bookmark bookmark, BookmarkFolder folder, bool isKorean) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Spacing.lg, Spacing.md, Spacing.lg, Spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookmark.url,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.open_in_new, color: colorScheme.primary),
              title: Text(isKorean ? '링크 열기' : 'Open Link'),
              onTap: () {
                Navigator.pop(ctx);
                UrlLauncherService.openUrl(bookmark.url);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm_add, color: colorScheme.tertiary),
              title: Text(isKorean ? '알람 만들기' : 'Create Alarm'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddLinkScreen(initialUrl: bookmark.url),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(isKorean ? '편집' : 'Edit'),
              onTap: () async {
                Navigator.pop(ctx);
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddBookmarkScreen(
                      folderId: folder.id,
                      bookmarkToEdit: bookmark,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: colorScheme.error),
              title: Text(
                isKorean ? '삭제' : 'Delete',
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(bookmarksProvider.notifier).deleteBookmark(bookmark.id);
                ToastOverlay.showSuccess(
                  context,
                  isKorean ? '북마크가 삭제되었어요' : 'Bookmark deleted',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAddBookmark() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddBookmarkScreen(folderId: widget.folderId),
      ),
    );
    if (ok == true && mounted) {
      final locale = Localizations.localeOf(context);
      final isKorean = locale.languageCode == 'ko';
      ToastOverlay.showSuccess(
        context,
        isKorean ? '북마크가 추가되었어요' : 'Bookmark added',
      );
      // 튜토리얼 단계 완료 표시
      if (!BookmarkTutorialService.isCompleted) {
        await BookmarkTutorialService.markCompleted();
        if (mounted) setState(() {});
      }
    }
  }
}
