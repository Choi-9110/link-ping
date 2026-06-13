import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark_folder.dart';
import '../../../providers/bookmark_folder_provider.dart';
import 'folder_edit_sheet.dart';

/// 폴더 선택 바텀시트. 선택한 폴더의 id를 반환.
/// 폴더가 하나도 없으면 "새 폴더 만들기" 버튼만 노출.
class FolderPickerSheet extends ConsumerWidget {
  final String? currentFolderId;

  const FolderPickerSheet({super.key, this.currentFolderId});

  static Future<String?> show(
    BuildContext context, {
    String? currentFolderId,
  }) {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FolderPickerSheet(currentFolderId: currentFolderId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';
    final folders = ref.watch(bookmarkFoldersProvider);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Spacing.md),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              child: Row(
                children: [
                  Text(
                    isKorean ? '폴더 선택' : 'Pick a folder',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () async {
                      final created = await FolderEditSheet.show(context);
                      if (created != null && context.mounted) {
                        Navigator.pop(context, created.id);
                      }
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(isKorean ? '새 폴더' : 'New'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: folders.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(Spacing.xl),
                      child: Column(
                        children: [
                          Icon(Icons.folder_outlined,
                              size: 48,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                          const SizedBox(height: Spacing.md),
                          Text(
                            isKorean
                                ? '폴더가 없어요. 새 폴더부터 만들어주세요'
                                : 'No folders yet. Create one first',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final f = folders[index];
                        return _buildFolderTile(
                          context,
                          folder: f,
                          selected: f.id == currentFolderId,
                          theme: theme,
                          colorScheme: colorScheme,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderTile(
    BuildContext context, {
    required BookmarkFolder folder,
    required bool selected,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(folder.emoji, style: const TextStyle(fontSize: 20)),
        ),
      ),
      title: Text(
        folder.name,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : null,
      onTap: () => Navigator.pop(context, folder.id),
    );
  }
}
