import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'dialog_actions.dart';
import 'toast_overlay.dart';
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

  /// 연결 모드 안내: 'all'=다같이 링 / 'chain'=릴레이 링 / null=표시 안 함
  /// (모드는 원작자가 정하고 재공유자는 바꿀 수 없음 — 여기선 안내만)
  final String? visibility;

  const LinkSharePreviewDialog({
    super.key,
    required this.title,
    required this.timeText,
    required this.shareUrl,
    required this.isLocked,
    required this.isKorean,
    this.visibility,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String timeText,
    required String shareUrl,
    required bool isLocked,
    required bool isKorean,
    String? visibility,
  }) {
    return showDialog(
      context: context,
      builder: (context) => LinkSharePreviewDialog(
        title: title,
        timeText: timeText,
        shareUrl: shareUrl,
        isLocked: isLocked,
        isKorean: isKorean,
        visibility: visibility,
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
    ToastOverlay.showSuccess(
      context,
      widget.isKorean ? '복사되었습니다' : 'Copied',
    );
  }

  Future<void> _share() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    // iOS: 다이얼로그를 먼저 pop 하면 공유 시트가 사라지는(present 실패) 문제가 있어
    // 시트를 먼저 띄우고(present), 사용자가 닫은 뒤 다이얼로그를 닫는다.
    // iPad 대응으로 sharePositionOrigin 도 함께 전달.
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      message,
      subject: widget.title,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isKorean ? '링크 공유 미리보기' : 'Link Share Preview'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 연결 모드 안내 (원작자가 정한 모드 — 재공유자는 안내만 받음)
            if (widget.visibility != null) ...[
              Builder(builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                final isChain = widget.visibility == 'chain';
                final accent =
                    isChain ? colorScheme.secondary : colorScheme.primary;
                return Container(
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: accent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    isChain
                        ? AppLocalizations.of(context)!.ringBannerChain
                        : AppLocalizations.of(context)!.ringBannerAll,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                );
              }),
            ],
            TextField(
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
            // 리프래시 = 워딩 없이 아이콘만, 우측 옵션 느낌
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: _refreshMessage,
                icon: const Icon(Icons.refresh, size: 20),
                tooltip: widget.isKorean ? '다른 문구로' : 'New phrasing',
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
      actions: [
        DialogActions(buttons: [
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
        ]),
      ],
    );
  }
}
