import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/verification_media_cache.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/verification_video.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/verification_provider.dart';
import '../../../services/pixel_emoji_service.dart';
import 'verification_player_screen.dart';

/// 특정 sharedLinkId 의 모든 인증 영상 갤러리 (바텀시트).
class VerificationGallerySheet extends ConsumerWidget {
  final String sharedLinkId;
  final String linkTitle;

  const VerificationGallerySheet({
    super.key,
    required this.sharedLinkId,
    required this.linkTitle,
  });

  static Future<void> show(
    BuildContext context, {
    required String sharedLinkId,
    required String linkTitle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => VerificationGallerySheet(
        sharedLinkId: sharedLinkId,
        linkTitle: linkTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';
    final asyncVideos =
        ref.watch(verificationsBySharedLinkProvider(sharedLinkId));
    final myUid = ref.watch(userProfileProvider).value?.uid;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Column(
          children: [
            const SizedBox(height: Spacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              child: Row(
                children: [
                  const Text('🎬', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isKorean ? '3초 인증' : '3-sec Proofs',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          linkTitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.sm),
            const Divider(height: 1),
            Expanded(
              child: asyncVideos.when(
                data: (videos) {
                  if (videos.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.xl),
                        child: Text(
                          isKorean
                              ? '아직 올라온 인증이 없어요.\n첫 인증을 올려서 친구들을 자극해보세요 💪'
                              : 'No proofs yet.\nUpload the first one to motivate friends 💪',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(Spacing.md),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: Spacing.sm,
                      crossAxisSpacing: Spacing.sm,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return _buildTile(
                        context,
                        video: videos[index],
                        isMine: videos[index].uploaderUid == myUid,
                        isKorean: isKorean,
                        theme: theme,
                        colorScheme: colorScheme,
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required VerificationVideo video,
    required bool isMine,
    required bool isKorean,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationPlayerScreen(video: video),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: isMine
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (video.thumbnailUrl != null)
                      CachedNetworkImage(
                        imageUrl: video.thumbnailUrl!,
                        cacheManager: VerificationMediaCache.instance,
                        fit: BoxFit.cover,
                        // 타일 크기에 맞춰 디코딩 — 메모리/스크롤 버벅임 방지
                        memCacheWidth: 400,
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.black,
                          child: Center(
                            child: Icon(
                              Icons.videocam,
                              size: 32,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        color: Colors.black,
                        child: Center(
                          child: Icon(
                            Icons.videocam,
                            size: 32,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 36,
                        color: Colors.white70,
                      ),
                    ),
                    if (isMine)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isKorean ? '내 영상' : 'Mine',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.visibility,
                                size: 10, color: Colors.white),
                            const SizedBox(width: 2),
                            Text(
                              '${video.viewCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm, vertical: 6),
              child: Row(
                children: [
                  PixelEmojiService.buildPixelEmoji(
                    video.uploaderProfileEmoji,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      video.uploaderNickname,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
