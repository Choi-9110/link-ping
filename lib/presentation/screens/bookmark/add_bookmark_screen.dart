import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/bookmark.dart';
import '../../../providers/bookmark_provider.dart';

class AddBookmarkScreen extends ConsumerStatefulWidget {
  final String? initialUrl;

  const AddBookmarkScreen({super.key, this.initialUrl});

  @override
  ConsumerState<AddBookmarkScreen> createState() => _AddBookmarkScreenState();
}

class _AddBookmarkScreenState extends ConsumerState<AddBookmarkScreen> {
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  final _memoController = TextEditingController();
  BookmarkCategory _selectedCategory = BookmarkCategory.other;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
    }
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isKorean ? '북마크 추가' : 'Add Bookmark'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // URL 입력
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

            // 제목 입력
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

            // 메모 입력
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
              maxLines: 2,
            ),
            const SizedBox(height: Spacing.lg),

            // 카테고리 선택
            Text(
              isKorean ? '카테고리' : 'Category',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: BookmarkCategory.values.map((category) {
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category.displayName(isKorean)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = category);
                    }
                  },
                  selectedColor: colorScheme.primaryContainer,
                  checkmarkColor: colorScheme.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: Spacing.xl),

            // 저장 버튼
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
                        isKorean ? '저장하기' : 'Save',
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
        SnackBar(content: Text(isKorean ? '제목을 입력해주세요' : 'Please enter a title')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(bookmarksProvider.notifier).addBookmark(
            url: url,
            title: title,
            category: _selectedCategory,
            memo: _memoController.text.trim().isNotEmpty
                ? _memoController.text.trim()
                : null,
          );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isKorean ? '저장 실패: $e' : 'Save failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
