import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/verification_video.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/verification_provider.dart';
import '../../../services/pixel_emoji_service.dart';
import '../../../services/verification_video_service.dart';
import 'verification_report_dialog.dart';
import 'verification_viewers_screen.dart';

/// 인증 영상 풀스크린 플레이어. 자동 재생 + 무한 루프 (3초).
class VerificationPlayerScreen extends ConsumerStatefulWidget {
  final VerificationVideo video;

  const VerificationPlayerScreen({super.key, required this.video});

  @override
  ConsumerState<VerificationPlayerScreen> createState() =>
      _VerificationPlayerScreenState();
}

class _VerificationPlayerScreenState
    extends ConsumerState<VerificationPlayerScreen> {
  VideoPlayerController? _controller;
  bool _viewRecorded = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl));
      if (mounted) setState(() => _controller = controller);
      await controller.initialize();
      if (!mounted) return;
      await controller.setLooping(true);
      if (!mounted) return;
      setState(() {});
      controller.play();

      // 시청 기록
      if (!_viewRecorded) {
        _viewRecorded = true;
        VerificationVideoService.instance.recordView(widget.video);
      }
    } catch (e) {
      if (mounted) setState(() => _initError = '$e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isKorean ? '영상 삭제할까요?' : 'Delete this proof?'),
        content: Text(
          isKorean
              ? '복구할 수 없어요. 시청자도 더 이상 못 봐요.'
              : 'This cannot be undone. Viewers will lose access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(isKorean ? '취소' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isKorean ? '삭제' : 'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await VerificationVideoService.instance.deleteVideo(widget.video);
      if (widget.video.sharedLinkId != null) {
        ref.invalidate(
            verificationsBySharedLinkProvider(widget.video.sharedLinkId!));
      }
      ref.invalidate(myVerificationsProvider);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';
    final profile = ref.watch(userProfileProvider).value;
    final isMyVideo = profile?.uid == widget.video.uploaderUid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            PixelEmojiService.buildPixelEmoji(
              widget.video.uploaderProfileEmoji,
              size: 28,
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                widget.video.uploaderNickname,
                style: const TextStyle(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (isMyVideo)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'viewers') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VerificationViewersScreen(video: widget.video),
                    ),
                  );
                } else if (value == 'delete') {
                  _confirmDelete();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'viewers',
                  child: Row(
                    children: [
                      const Icon(Icons.visibility, size: 18),
                      const SizedBox(width: 8),
                      Text(isKorean ? '누가 봤지? 💎' : 'Who viewed 💎'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 18,
                          color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 8),
                      Text(
                        isKorean ? '삭제' : 'Delete',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.flag_outlined),
              tooltip: isKorean ? '신고/차단' : 'Report / Block',
              onPressed: () => VerificationReportDialog.show(
                context,
                video: widget.video,
              ),
            ),
        ],
      ),
      body: Center(
        child: _initError != null
            ? Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.white54),
                    const SizedBox(height: Spacing.md),
                    Text(
                      isKorean
                          ? '영상을 불러올 수 없어요\n(만료되었거나 삭제됨)'
                          : 'Could not load video\n(expired or deleted)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            : _controller == null || !_controller!.value.isInitialized
                ? const CircularProgressIndicator(color: Colors.white)
                : AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
      ),
    );
  }
}
