import 'package:flutter/material.dart';

import '../../widgets/dialog_actions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark_folder.dart';
import '../../../providers/bookmark_folder_provider.dart';
import '../../../providers/recommended_provider.dart';
import '../../../services/bookmark_tutorial_service.dart';
import 'bookmark_folder_screen.dart';
import 'bookmark_tutorial_banner.dart';
import 'folder_edit_sheet.dart';
import 'recommended_list_screen.dart';

class BookmarkScreen extends ConsumerStatefulWidget {
  const BookmarkScreen({super.key});

  @override
  ConsumerState<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends ConsumerState<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final folders = ref.watch(bookmarkFoldersProvider);
    final recommendedAsync = ref.watch(recommendedLinksProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    // 튜토리얼 표시 조건: 폴더 0개 + 미완료 + step 이 시작 전(notStarted)이거나 createFolder.
    // 신규 유저는 기본값이 notStarted 라서 createFolder 단일 비교만 하면 영영 안 떴음.
    final tutorialStep = BookmarkTutorialService.currentStep;
    final showTutorial = folders.isEmpty &&
        !BookmarkTutorialService.isCompleted &&
        (tutorialStep == BookmarkTutorialStep.notStarted ||
            tutorialStep == BookmarkTutorialStep.createFolder);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isKorean ? '북마크' : 'Bookmarks',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListView(
            padding: const EdgeInsets.all(Spacing.md),
            children: [
              _buildRecommendedFolder(
                context,
                recommendedAsync: recommendedAsync,
                isKorean: isKorean,
                theme: theme,
                colorScheme: colorScheme,
              ),
              if (folders.isEmpty)
                _buildEmptyHint(isKorean, theme, colorScheme)
              else
                ...folders.map((f) => _buildFolderCard(
                      context,
                      folder: f,
                      isKorean: isKorean,
                      theme: theme,
                      colorScheme: colorScheme,
                    )),
            ],
          ),
          // 튜토리얼 배너 — Stack 자식으로 인라인 렌더 (Overlay 안 씀).
          // showTutorial 일 때만 트리에 추가 → Positioned + 빈 자식 충돌 회피.
          if (showTutorial)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BookmarkTutorialBanner(
                visible: true,
                step: BookmarkTutorialStep.createFolder,
                onCta: () async {
                  if (!BookmarkTutorialService.isCompleted) {
                    await BookmarkTutorialService.setStep(
                        BookmarkTutorialStep.createFolder);
                  }
                  _onAddFolder();
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'bookmark_fab',
        onPressed: _onAddFolder,
        icon: const Icon(Icons.create_new_folder_outlined),
        label: Text(isKorean ? '새 폴더' : 'New Folder'),
      ),
    );
  }

  Widget _buildEmptyHint(
      bool isKorean, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            isKorean
                ? '아직 폴더가 없어요\n오른쪽 아래 + 버튼으로 첫 폴더를 만들어보세요'
                : 'No folders yet\nTap + below to create your first folder',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedFolder(
    BuildContext context, {
    required AsyncValue recommendedAsync,
    required bool isKorean,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
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
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
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

  Widget _buildFolderCard(
    BuildContext context, {
    required BookmarkFolder folder,
    required bool isKorean,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    final count = ref.watch(bookmarkCountByFolderProvider(folder.id));

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
            child: Text(folder.emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(
          folder.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          isKorean ? '$count개 링크' : '$count links',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookmarkFolderScreen(folderId: folder.id),
            ),
          );
        },
        onLongPress: () => _onFolderLongPress(folder, isKorean),
      ),
    );
  }

  Future<void> _onAddFolder() async {
    final created = await FolderEditSheet.show(context);
    if (created != null && mounted) {
      // 튜토리얼 진행 중이라면 다음 단계로 (자동 네비게이션 X, setState 로 배너만 갱신)
      if (!BookmarkTutorialService.isCompleted) {
        await BookmarkTutorialService.setStep(BookmarkTutorialStep.addLink);
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> _onFolderLongPress(
      BookmarkFolder folder, bool isKorean) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(isKorean ? '폴더 편집' : 'Edit Folder'),
              onTap: () async {
                Navigator.pop(ctx);
                await FolderEditSheet.show(context, folder: folder);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              title: Text(
                isKorean ? '폴더 삭제' : 'Delete Folder',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                await _confirmDeleteFolder(folder, isKorean);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteFolder(
      BookmarkFolder folder, bool isKorean) async {
    final count = ref.read(bookmarkCountByFolderProvider(folder.id));
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isKorean ? '폴더를 삭제할까요?' : 'Delete this folder?'),
        content: Text(
          count > 0
              ? (isKorean
                  ? '폴더 안의 $count개 북마크도 함께 삭제돼요.'
                  : 'The $count bookmarks inside will also be deleted.')
              : (isKorean ? '되돌릴 수 없어요.' : 'This cannot be undone.'),
        ),
        actions: [
          DialogActions(buttons: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(isKorean ? '취소' : 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                isKorean ? '삭제' : 'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ]),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(bookmarkFoldersProvider.notifier).deleteFolder(folder.id);
    }
  }
}
