import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/linkku_logo.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 마스코트 "링꾸" — 빈 화면 브랜드 모먼트
            const LinkkuSymbol(size: 104),
            const SizedBox(height: Spacing.lg),
            Text(
              l10n.emptyStateTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              l10n.emptyStateSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            if (onAddLink != null)
              FilledButton.icon(
                onPressed: onAddLink,
                icon: const Icon(Icons.add),
                label: Text(l10n.addLink),
              ),
          ],
        ),
      ),
    );
  }
}
