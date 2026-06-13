import 'package:flutter/material.dart';

import '../../../core/theme/brand_tokens.dart';
import '../../../core/theme/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/linkku_logo.dart';

/// 링꾸 도감 (티저).
///
/// 현재는 기본 링꾸 1마리만 해금, 나머지는 "곧 만나요" 실루엣.
/// 다마고치/펫 시스템(성격·수집)은 출시 후 단계적으로 도입 예정 —
/// 여기선 "앞으로 친구들이 온다"는 느낌만 전달한다.
class LinkkuDexScreen extends StatelessWidget {
  const LinkkuDexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // 로스터: 링꾸만 해금, 나머지는 실루엣(곧)
    const total = 6;
    const unlocked = 1;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.linkkuDexTitle)),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          // 인트로 + 수집 카운터
          Text(
            l10n.linkkuDexCollect,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.linkkuDexComingHint,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: Spacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: BrandTokens.purple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unlocked / $total',
                style: TextStyle(
                  fontFamily: BrandTokens.fontPixel,
                  color: BrandTokens.purple,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),

          // 도감 그리드
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: Spacing.md,
            crossAxisSpacing: Spacing.md,
            childAspectRatio: 0.92,
            children: [
              _DexCard(
                unlocked: true,
                name: l10n.appName,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LinkkuDexDetailScreen(),
                  ),
                ),
              ),
              for (int i = 0; i < total - unlocked; i++)
                const _DexCard(unlocked: false, name: '???'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DexCard extends StatelessWidget {
  const _DexCard({
    required this.unlocked,
    required this.name,
    this.onTap,
  });

  final bool unlocked;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorScheme.outline),
          ),
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (unlocked)
                const LinkkuSymbol(size: 72)
              else
                Opacity(
                  opacity: 0.35,
                  child: Icon(
                    Icons.help_outline,
                    size: 60,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: Spacing.sm),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: unlocked ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                unlocked ? l10n.linkkuDexDefault : l10n.linkkuDexComingSoon,
                style: TextStyle(
                  fontSize: 11,
                  color: unlocked ? BrandTokens.mint : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 링꾸 상세 — 확대 + 성격/소개. (성격 시스템은 출시 후 도입)
class LinkkuDexDetailScreen extends StatelessWidget {
  const LinkkuDexDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          // 확대된 링꾸
          Center(
            child: Container(
              padding: const EdgeInsets.all(Spacing.xl),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.outline),
              ),
              child: const LinkkuSymbol(
                variant: LinkkuSymbolVariant.spark,
                size: 160,
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Center(
            child: Text(
              l10n.appName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              l10n.linkkuDexSubtitle,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: Spacing.lg),

          // 성격 섹션 (티저)
          _InfoSection(
            title: l10n.linkkuPersonality,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  children: [
                    _Chip(label: l10n.linkkuTraitCaring),
                    _Chip(label: l10n.linkkuTraitAttentive),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  l10n.linkkuPersonalityDesc,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),

          // 앞으로 (티저)
          _InfoSection(
            title: l10n.linkkuWhatsNext,
            child: Text(
              l10n.linkkuWhatsNextDesc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          child,
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: BrandTokens.mint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: BrandTokens.mintShade,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
