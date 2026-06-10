import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark.dart';
import '../../../providers/bookmark_folder_provider.dart';
import '../../../providers/bookmark_provider.dart';
import 'folder_picker_sheet.dart';

/// 북마크 추가/편집 화면.
/// - folderId가 주어지면 해당 폴더로 저장 (폴더 선택 단계 생략)
/// - bookmarkToEdit이 주어지면 편집 모드
class AddBookmarkScreen extends ConsumerStatefulWidget {
  final String? initialUrl;
  final String? folderId;
  final Bookmark? bookmarkToEdit;

  const AddBookmarkScreen({
    super.key,
    this.initialUrl,
    this.folderId,
    this.bookmarkToEdit,
  });

  @override
  ConsumerState<AddBookmarkScreen> createState() => _AddBookmarkScreenState();
}

class _AddBookmarkScreenState extends ConsumerState<AddBookmarkScreen> {
  late final TextEditingController _urlController;
  late final TextEditingController _titleController;
  late final TextEditingController _memoController;
  String? _selectedFolderId;
  bool _isSaving = false;

  bool get _isEdit => widget.bookmarkToEdit != null;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: widget.bookmarkToEdit?.url ?? widget.initialUrl ?? '',
    );
    _titleController =
        TextEditingController(text: widget.bookmarkToEdit?.title ?? '');
    _memoController =
        TextEditingController(text: widget.bookmarkToEdit?.memo ?? '');
    _selectedFolderId = widget.bookmarkToEdit?.folderId ?? widget.folderId;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';
    final selectedFolder = _selectedFolderId == null
        ? null
        : ref.watch(folderByIdProvider(_selectedFolderId!));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit
              ? (isKorean ? '북마크 편집' : 'Edit Bookmark')
              : (isKorean ? '북마크 추가' : 'Add Bookmark'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL',
                hintText: 'https://',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: Spacing.md),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: isKorean ? '제목' : 'Title',
                hintText: isKorean ? '북마크 이름' : 'Bookmark name',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: Spacing.md),
            TextField(
              controller: _memoController,
              decoration: InputDecoration(
                labelText: isKorean ? '메모 (선택)' : 'Memo (optional)',
                hintText: isKorean ? '간단한 메모' : 'Quick note',
                prefixIcon: const Icon(Icons.note_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              isKorean ? '폴더' : 'Folder',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickFolder,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.md,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    if (selectedFolder != null) ...[
                      Text(selectedFolder.emoji,
                          style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Text(
                          selectedFolder.name,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ] else ...[
                      Icon(Icons.folder_outlined,
                          color: colorScheme.outline),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Text(
                          isKorean ? '폴더 선택하기' : 'Pick a folder',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isEdit
                            ? (isKorean ? '저장' : 'Save')
                            : (isKorean ? '저장하기' : 'Save'),
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

  Future<void> _pickFolder() async {
    final id = await FolderPickerSheet.show(
      context,
      currentFolderId: _selectedFolderId,
    );
    if (id != null) setState(() => _selectedFolderId = id);
  }

  Future<void> _save() async {
    final url = _urlController.text.trim();
    final title = _titleController.text.trim();
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isKorean ? 'URL을 입력해주세요' : 'Please enter a URL')),
      );
      return;
    }
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isKorean ? '제목을 입력해주세요' : 'Please enter a title')),
      );
      return;
    }
    if (_selectedFolderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isKorean ? '폴더를 선택해주세요' : 'Please pick a folder')),
      );
      return;
    }

    final normalizedUrl = _normalizeUrl(url);
    final memo = _memoController.text.trim();

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(bookmarksProvider.notifier);
      if (_isEdit) {
        final updated = widget.bookmarkToEdit!.copyWith(
          url: normalizedUrl,
          title: title,
          folderId: _selectedFolderId,
          memo: memo.isEmpty ? null : memo,
          clearMemo: memo.isEmpty,
        );
        await notifier.updateBookmark(updated);
      } else {
        await notifier.addBookmark(
          url: normalizedUrl,
          title: title,
          folderId: _selectedFolderId!,
          memo: memo.isEmpty ? null : memo,
        );
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isKorean ? '저장 실패: $e' : 'Save failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// URL에 scheme이 없으면 https:// 자동 추가.
  /// 전화번호(010-, +1234) 같은 케이스는 그대로 둠.
  String _normalizeUrl(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return trimmed;
    final lower = trimmed.toLowerCase();
    if (lower.startsWith('http://') ||
        lower.startsWith('https://') ||
        lower.startsWith('tel:') ||
        lower.startsWith('mailto:') ||
        lower.startsWith('sms:')) {
      return trimmed;
    }
    // 전화번호처럼 보이면 그대로 둠 (숫자/+/- 만)
    final phoneLike = RegExp(r'^[+0-9\-\s()]+$').hasMatch(trimmed);
    if (phoneLike) return trimmed;
    return 'https://$trimmed';
  }
}
