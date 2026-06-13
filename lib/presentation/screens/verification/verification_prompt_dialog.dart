import 'package:flutter/material.dart';

import '../../widgets/dialog_actions.dart';

import '../../../core/theme/spacing.dart';
import '../../../services/pending_verification_service.dart';
import 'verification_record_screen.dart';

/// 알람 다녀온 직후 노출되는 인증 영상 프롬프트.
class VerificationPromptDialog {
  static bool _showing = false;

  /// 보류 중인 인증이 있으면 다이얼로그를 띄움.
  /// pending 정보를 소진하면 [PendingVerificationService.clear] 호출.
  static Future<void> showIfPending(BuildContext context) async {
    if (_showing) return;
    final pending = PendingVerificationService.read();
    if (pending == null) return;
    if (!context.mounted) return;
    _showing = true;
    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _PromptDialog(pending: pending),
      );
    } finally {
      _showing = false;
    }
  }
}

class _PromptDialog extends StatelessWidget {
  final PendingVerification pending;

  const _PromptDialog({required this.pending});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Text('🎬', style: TextStyle(fontSize: 28)),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              isKorean ? '방금 다녀온 알람!' : 'Just back?',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pending.title.isEmpty
                      ? (isKorean ? '알람' : 'Alarm')
                      : pending.title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  pending.url,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: colorScheme.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            isKorean
                ? '잘 해냈으면 3초 인증 영상 한 컷 어때요?\n같이 공유받은 친구들이 응원해줄 거예요 💪'
                : 'Nice job! Record a 3-sec proof for friends to cheer you on? 💪',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
      actions: [
        DialogActions(buttons: [
        TextButton(
          onPressed: () async {
            await PendingVerificationService.clear();
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(isKorean ? '다음에' : 'Maybe later'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.videocam),
          label: Text(isKorean ? '인증할게!' : 'Record'),
          onPressed: () async {
            await PendingVerificationService.clear();
            if (!context.mounted) return;
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerificationRecordScreen(
                  alarmTitle: pending.title,
                  sharedLinkId: pending.sharedLinkId,
                ),
              ),
            );
          },
        ),
        ]),
      ],
    );
  }
}
