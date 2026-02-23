import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/share_message_service.dart';

/// 공유 미리보기 다이얼로그
/// 랜덤 메시지를 미리 보고, 다른 문구로 바꾸거나 공유할 수 있음
class SharePreviewDialog extends StatefulWidget {
  final String referralCode;
  final bool isKorean;

  const SharePreviewDialog({
    super.key,
    required this.referralCode,
    required this.isKorean,
  });

  /// 다이얼로그 표시
  static Future<void> show(
    BuildContext context, {
    required String referralCode,
    required bool isKorean,
  }) {
    return showDialog(
      context: context,
      builder: (context) => SharePreviewDialog(
        referralCode: referralCode,
        isKorean: isKorean,
      ),
    );
  }

  @override
  State<SharePreviewDialog> createState() => _SharePreviewDialogState();
}

class _SharePreviewDialogState extends State<SharePreviewDialog> {
  late String _currentMessage;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _generateNewMessage();
  }

  void _generateNewMessage() {
    _currentMessage = ShareMessageService.generateInviteMessage(
      referralCode: widget.referralCode,
      isKorean: widget.isKorean,
    );
  }

  Future<void> _refreshMessage() async {
    // 페이드 아웃
    setState(() => _opacity = 0.0);
    await Future.delayed(const Duration(milliseconds: 150));

    // 메시지 변경
    _generateNewMessage();

    // 페이드 인
    setState(() => _opacity = 1.0);
  }

  void _share() {
    Navigator.pop(context);
    Share.share(_currentMessage);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _currentMessage));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isKorean ? '복사되었습니다' : 'Copied'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.share, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(widget.isKorean ? '공유 미리보기' : 'Share Preview'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 메시지 미리보기 박스
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: SelectableText(
                  _currentMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 다른 문구 버튼
            OutlinedButton.icon(
              onPressed: _refreshMessage,
              icon: const Icon(Icons.refresh, size: 20),
              label: Text(widget.isKorean ? '다른 문구로 바꾸기' : 'Try different message'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // 복사 버튼
        TextButton.icon(
          onPressed: _copyToClipboard,
          icon: const Icon(Icons.copy, size: 18),
          label: Text(widget.isKorean ? '복사' : 'Copy'),
        ),
        // 공유 버튼
        FilledButton.icon(
          onPressed: _share,
          icon: const Icon(Icons.send, size: 18),
          label: Text(widget.isKorean ? '공유하기' : 'Share'),
        ),
      ],
    );
  }
}
