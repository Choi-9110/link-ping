import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/share_message_service.dart';

/// 링크 공유 미리보기 다이얼로그
/// 공유 전에 문구를 바꾸거나 직접 수정할 수 있음
class LinkSharePreviewDialog extends StatefulWidget {
  final String title;
  final String timeText;
  final String shareUrl;
  final bool isLocked;
  final bool isKorean;

  const LinkSharePreviewDialog({
    super.key,
    required this.title,
    required this.timeText,
    required this.shareUrl,
    required this.isLocked,
    required this.isKorean,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String timeText,
    required String shareUrl,
    required bool isLocked,
    required bool isKorean,
  }) {
    return showDialog(
      context: context,
      builder: (context) => LinkSharePreviewDialog(
        title: title,
        timeText: timeText,
        shareUrl: shareUrl,
        isLocked: isLocked,
        isKorean: isKorean,
      ),
    );
  }

  @override
  State<LinkSharePreviewDialog> createState() => _LinkSharePreviewDialogState();
}

class _LinkSharePreviewDialogState extends State<LinkSharePreviewDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _generateMessage());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _generateMessage() {
    return ShareMessageService.generateLinkShareMessage(
      title: widget.title,
      timeText: widget.timeText,
      shareUrl: widget.shareUrl,
      isLocked: widget.isLocked,
      isKorean: widget.isKorean,
    );
  }

  void _refreshMessage() {
    setState(() {
      _controller.text = _generateMessage();
    });
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _controller.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isKorean ? '복사되었습니다' : 'Copied'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _share() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    Navigator.pop(context);
    Share.share(message, subject: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isKorean ? '링크 공유 미리보기' : 'Link Share Preview'),
      content: SizedBox(
        width: 520,
        child: TextField(
          controller: _controller,
          minLines: 8,
          maxLines: 14,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.isKorean
                ? '공유 문구를 수정해보세요'
                : 'Customize your share message',
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: _refreshMessage,
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(widget.isKorean ? '다른 문구' : 'New phrasing'),
        ),
        TextButton.icon(
          onPressed: _copy,
          icon: const Icon(Icons.copy, size: 18),
          label: Text(widget.isKorean ? '복사' : 'Copy'),
        ),
        FilledButton.icon(
          onPressed: _share,
          icon: const Icon(Icons.send, size: 18),
          label: Text(widget.isKorean ? '공유하기' : 'Share'),
        ),
      ],
    );
  }
}
