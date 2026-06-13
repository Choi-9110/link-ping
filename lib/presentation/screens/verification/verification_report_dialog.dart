import 'package:flutter/material.dart';

import '../../widgets/dialog_actions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/verification_video.dart';
import '../../../providers/verification_provider.dart';
import '../../../services/verification_video_service.dart';

/// 인증 영상 신고/차단 다이얼로그.
class VerificationReportDialog extends ConsumerStatefulWidget {
  final VerificationVideo video;

  const VerificationReportDialog({super.key, required this.video});

  static Future<void> show(BuildContext context,
      {required VerificationVideo video}) {
    return showDialog(
      context: context,
      builder: (_) => VerificationReportDialog(video: video),
    );
  }

  @override
  ConsumerState<VerificationReportDialog> createState() =>
      _VerificationReportDialogState();
}

class _VerificationReportDialogState
    extends ConsumerState<VerificationReportDialog> {
  VerificationReportReason? _reason;
  bool _alsoBlock = false;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';

    return AlertDialog(
      title: Text(isKorean ? '신고하기' : 'Report'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isKorean ? '사유를 선택해주세요.' : 'Pick a reason.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: Spacing.sm),
          ...VerificationReportReason.values.map((r) {
            return RadioListTile<VerificationReportReason>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: r,
              groupValue: _reason,
              title: Text(r.label(isKorean)),
              onChanged: (v) => setState(() => _reason = v),
            );
          }),
          const SizedBox(height: Spacing.sm),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: _alsoBlock,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (v) => setState(() => _alsoBlock = v ?? false),
            title: Text(
              isKorean
                  ? '이 사용자 차단 (영상 더 안 보임)'
                  : 'Block this user (hide their videos)',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            isKorean
                ? '신고는 24시간 이내 검토됩니다.'
                : 'Reports are reviewed within 24 hours.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        DialogActions(buttons: [
          TextButton(
            onPressed: _submitting ? null : () => Navigator.pop(context),
            child: Text(isKorean ? '취소' : 'Cancel'),
          ),
          FilledButton(
            onPressed: (_reason == null || _submitting) ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(isKorean ? '제출' : 'Submit'),
          ),
        ]),
      ],
    );
  }

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null) return;
    setState(() => _submitting = true);

    final isKorean = Localizations.localeOf(context).languageCode == 'ko';
    try {
      await VerificationVideoService.instance.reportVideo(
        video: widget.video,
        reason: reason,
      );
      if (_alsoBlock) {
        await VerificationVideoService.instance.blockUser(
          targetUid: widget.video.uploaderUid,
          targetNickname: widget.video.uploaderNickname,
        );
        ref.invalidate(blockedUsersProvider);
      }
      if (widget.video.sharedLinkId != null) {
        ref.invalidate(
            verificationsBySharedLinkProvider(widget.video.sharedLinkId!));
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isKorean
                  ? '신고가 접수되었어요. 감사합니다.'
                  : 'Report submitted. Thank you.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${isKorean ? "실패" : "Failed"}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
