import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback? onAddLink;

  const EmptyState({
    super.key,
    this.onAddLink,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_outlined,
              size: 80,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              '저장한 링크를 알림으로\n받아보세요!',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              '인스타, 유튜브 영상을\n정해진 시간에 바로 열어요',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            if (onAddLink != null)
              FilledButton.icon(
                onPressed: onAddLink,
                icon: const Icon(Icons.add),
                label: const Text('첫 번째 링크 추가'),
              ),
          ],
        ),
      ),
    );
  }
}
