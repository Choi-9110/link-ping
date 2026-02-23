import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/poring_provider.dart';
import 'poring_earn_dialog.dart';

/// AppBar용 포링 카운터 위젯
/// 탭하면 포링 획득 다이얼로그 열림
class PoringCounterWidget extends ConsumerWidget {
  const PoringCounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poringState = ref.watch(poringProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final displayText = poringState.isPremium
        ? '\u221e' // ∞
        : '${poringState.balance}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: poringState.isPremium
            ? null
            : () => showDialog(
                  context: context,
                  builder: (_) => const PoringEarnDialog(),
                ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.amber.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.toll,
                size: 16,
                color: Colors.amber.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
