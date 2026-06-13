import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../providers/verification_provider.dart';
import '../../../services/verification_video_service.dart';

/// 인증 영상 업로드 진행 + 결과 시트.
class VerificationUploadSheet extends ConsumerStatefulWidget {
  final File videoFile;
  final File? thumbnailFile;
  final String uploaderNickname;
  final String uploaderProfileEmoji;
  final int resolution;
  final String? sharedLinkId;

  const VerificationUploadSheet({
    super.key,
    required this.videoFile,
    this.thumbnailFile,
    required this.uploaderNickname,
    required this.uploaderProfileEmoji,
    required this.resolution,
    this.sharedLinkId,
  });

  static Future<bool?> show(
    BuildContext context, {
    required File videoFile,
    File? thumbnailFile,
    required String uploaderNickname,
    required String uploaderProfileEmoji,
    required int resolution,
    String? sharedLinkId,
  }) {
    return showModalBottomSheet<bool?>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => VerificationUploadSheet(
        videoFile: videoFile,
        thumbnailFile: thumbnailFile,
        uploaderNickname: uploaderNickname,
        uploaderProfileEmoji: uploaderProfileEmoji,
        resolution: resolution,
        sharedLinkId: sharedLinkId,
      ),
    );
  }

  @override
  ConsumerState<VerificationUploadSheet> createState() =>
      _VerificationUploadSheetState();
}

class _VerificationUploadSheetState
    extends ConsumerState<VerificationUploadSheet> {
  double _progress = 0;
  String? _error;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _upload();
  }

  Future<void> _upload() async {
    try {
      await VerificationVideoService.instance.uploadVerification(
        videoFile: widget.videoFile,
        thumbnailFile: widget.thumbnailFile,
        uploaderNickname: widget.uploaderNickname,
        uploaderProfileEmoji: widget.uploaderProfileEmoji,
        resolution: widget.resolution,
        sharedLinkId: widget.sharedLinkId,
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      // 업로드 성공 → 관련 갤러리 캐시 무효화 (다음 조회 시 새 영상 포함)
      if (widget.sharedLinkId != null) {
        ref.invalidate(
            verificationsBySharedLinkProvider(widget.sharedLinkId!));
      }
      ref.invalidate(myVerificationsProvider);

      if (mounted) setState(() => _done = true);
      // 잠깐 보여주고 닫기
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            if (_error != null) ...[
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: Spacing.md),
              Text(
                isKorean ? '업로드 실패' : 'Upload failed',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: Spacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(isKorean ? '닫기' : 'Close'),
                ),
              ),
            ] else if (_done) ...[
              const Icon(Icons.check_circle,
                  size: 56, color: Colors.green),
              const SizedBox(height: Spacing.md),
              Text(
                isKorean ? '인증 완료! 🎉' : 'Verified! 🎉',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                isKorean ? '함께 공유받은 친구들에게 전해질 거예요' : 'Your friends will see it',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ] else ...[
              Text(
                isKorean ? '인증 영상 업로드 중...' : 'Uploading proof...',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress > 0 ? _progress : null,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                '${(_progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                isKorean
                    ? '잠시만 기다려주세요 (보통 5초 이내)'
                    : 'Just a moment (usually under 5s)',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
