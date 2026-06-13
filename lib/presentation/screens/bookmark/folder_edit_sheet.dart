import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark_folder.dart';
import '../../../providers/bookmark_folder_provider.dart';

/// 폴더 생성/편집 바텀시트.
class FolderEditSheet extends ConsumerStatefulWidget {
  /// 편집 모드일 때 전달. null이면 생성 모드.
  final BookmarkFolder? folder;

  const FolderEditSheet({super.key, this.folder});

  static Future<BookmarkFolder?> show(
    BuildContext context, {
    BookmarkFolder? folder,
  }) {
    return showModalBottomSheet<BookmarkFolder?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // ※ 반드시 시트 자신의 context 로 viewInsets 를 읽어야
      //   키보드가 올라올 때 패딩이 같이 올라간다.
      //   (바깥 context 로 읽으면 빌더가 리빌드되지 않아 키보드에 가려짐)
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: FolderEditSheet(folder: folder),
      ),
    );
  }

  @override
  ConsumerState<FolderEditSheet> createState() => _FolderEditSheetState();
}

class _FolderEditSheetState extends ConsumerState<FolderEditSheet> {
  late final TextEditingController _nameController;
  late String _emoji;
  bool _saving = false;

  static const _emojiOptions = [
    '⭐', '🏃', '📚', '🍳', '🎬', '🛍️', '📰', '💪',
    '💼', '🎵', '📝', '🎮', '✈️', '💰', '❤️', '🧘',
    '🍔', '🐱', '🌱', '🎨', '📷', '🔥', '✨', '🎯',
  ];

  bool get _isEdit => widget.folder != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.folder?.name ?? '');
    _emoji = widget.folder?.emoji ?? '⭐';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          Spacing.lg,
          Spacing.md,
          Spacing.lg,
          Spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
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
            Text(
              _isEdit
                  ? (isKorean ? '폴더 편집' : 'Edit Folder')
                  : (isKorean ? '새 폴더 만들기' : 'New Folder'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // 미리보기 (큰 이모지 + 현재 이름)
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(_emoji, style: const TextStyle(fontSize: 40)),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // 이모지 선택 — 키보드 가리지 않도록 이름 입력 위에 배치
            Text(
              isKorean ? '이모지 선택' : 'Pick an emoji',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojiOptions.map((e) {
                final selected = e == _emoji;
                return GestureDetector(
                  onTap: () {
                    // 이모지 탭 시 키보드 닫기 — 선택 후 바로 이름 입력으로 자연스럽게 전환
                    FocusScope.of(context).unfocus();
                    setState(() => _emoji = e);
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: selected
                          ? Border.all(color: colorScheme.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(e, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: Spacing.lg),

            // 폴더 이름 입력 (키보드 자동 노출 X — 사용자가 탭해야 키보드 뜸)
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: isKorean ? '폴더 이름' : 'Folder name',
                hintText: isKorean ? '예: 내 알바' : 'e.g., My side hustle',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLength: 20,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: Spacing.md),

            // 저장 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isEdit
                            ? (isKorean ? '저장' : 'Save')
                            : (isKorean ? '폴더 만들기' : 'Create Folder'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(isKorean ? '폴더 이름을 입력해주세요' : 'Please enter a folder name'),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final notifier = ref.read(bookmarkFoldersProvider.notifier);
      late final BookmarkFolder result;
      if (_isEdit) {
        result = widget.folder!.copyWith(name: name, emoji: _emoji);
        await notifier.updateFolder(result);
      } else {
        result = await notifier.createFolder(name: name, emoji: _emoji);
      }
      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${isKorean ? "저장 실패" : "Save failed"}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
