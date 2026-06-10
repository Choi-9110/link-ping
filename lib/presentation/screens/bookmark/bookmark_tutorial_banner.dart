import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../services/bookmark_tutorial_service.dart';

/// 인라인 튜토리얼 안내 배너. Scaffold body 의 Stack 자식으로 사용.
/// OverlayEntry 대신 사용 → 라우트 전환 시 자동으로 정리됨 (위젯 dispose 됨).
class BookmarkTutorialBanner extends StatelessWidget {
  /// 표시 여부 (false 면 빈 SizedBox 반환).
  final bool visible;
  final BookmarkTutorialStep step;
  final VoidCallback onCta;

  const BookmarkTutorialBanner({
    super.key,
    required this.visible,
    required this.step,
    required this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';

    final (title, message, cta) = switch (step) {
      BookmarkTutorialStep.createFolder => (
          isKorean ? '환영해요! 👋' : 'Welcome! 👋',
          isKorean
              ? '먼저 폴더부터 만들어볼까요?\n오른쪽 아래 "새 폴더" 버튼을 눌러주세요.'
              : 'Let’s start by creating a folder.\nTap the "New Folder" button.',
          isKorean ? '폴더 만들기' : 'Create Folder',
        ),
      BookmarkTutorialStep.addLink => (
          isKorean ? '폴더 완성! 🎉' : 'Folder created! 🎉',
          isKorean
              ? '이제 이 폴더 안에 링크를 추가해봐요.\n오른쪽 아래 "링크 추가" 버튼을 눌러주세요.'
              : 'Now add a link to this folder.\nTap the "Add Link" button.',
          isKorean ? '링크 추가' : 'Add Link',
        ),
      _ => (null, null, null),
    };

    if (title == null) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.md,
          0,
          Spacing.md,
          Spacing.md + 80, // FAB 위쪽으로 배치
        ),
        child: Material(
          elevation: 6,
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onInverseSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await BookmarkTutorialService.skip();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          isKorean ? '건너뛰기' : 'Skip',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                colorScheme.onInverseSurface.withValues(alpha: 0.7),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onInverseSurface.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.south, size: 16, color: Colors.white70),
                    const SizedBox(width: 6),
                    FilledButton(
                      onPressed: onCta,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: Text(cta!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
