import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/verification_media_cache.dart';

import '../../../core/theme/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/link_reminder.dart';
import '../../../data/models/verification_video.dart';
import '../../../providers/links_provider.dart';
import '../../../providers/verification_provider.dart';
import '../../../services/pending_verification_service.dart';
import '../../../services/pixel_emoji_service.dart';
import '../../../services/verification_seen_service.dart';
import '../../widgets/linkku_logo.dart';
import '../../widgets/toast_overlay.dart';
import 'verification_player_screen.dart';
import 'verification_record_screen.dart';

/// 인증 갤러리 (탭 루트) — **링크별로 묶어서** 보여준다.
/// 같은 링크를 공유·저장한 사람들끼리의 인증 모음이 한 줄(그룹 카드)이고,
/// 카드를 탭하면 해당 링크의 그리드 갤러리로 들어간다.
class VerificationGalleryScreen extends ConsumerWidget {
  const VerificationGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final links = ref.watch(linksProvider);

    // 공유 중인 내 링크들 (인증의 단위 = 링크 폴더) — 최근 생성순
    final sharedLinks = links.where((l) => l.sharedLinkId != null).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.proofGalleryTitle),
      ),
      body: RefreshIndicator(
        // 패밀리 전체 무효화 → 모든 폴더 새로고침
        onRefresh: () async => ref.invalidate(linkVerificationsProvider),
        child: sharedLinks.isEmpty
            ? _buildEmpty(l10n, theme, colorScheme)
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                    Spacing.md, Spacing.md, Spacing.md, Spacing.xl * 2),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: Spacing.md,
                  crossAxisSpacing: Spacing.md,
                  childAspectRatio: 0.95,
                ),
                itemCount: sharedLinks.length,
                itemBuilder: (context, index) => _LinkFolderTile(
                  link: sharedLinks[index],
                ),
              ),
      ),
    );
  }

  Widget _buildEmpty(
      AppLocalizations l10n, ThemeData theme, ColorScheme colorScheme) {
    return ListView(
      children: [
        const SizedBox(height: 140),
        const Center(child: LinkkuSymbol(size: 88)),
        const SizedBox(height: Spacing.lg),
        Center(
          child: Text(
            l10n.proofNoSharedAlarms,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Center(
          child: Text(
            l10n.proofNoSharedAlarmsHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// 링크(약속) 단위 — **도트 폴더** 타일.
/// 같은 링크를 공유·저장한 사람들의 인증이 이 폴더에 모인다.
/// (릴레이 링이면 내 이웃의 인증만 — linkVerificationsProvider 가 모드를 따름)
/// 탭하면 해당 링크 전용 그리드 갤러리로 진입.
class _LinkFolderTile extends ConsumerWidget {
  const _LinkFolderTile({
    required this.link,
  });

  final LinkReminder link;

  String _latestAgo(AppLocalizations l10n, List<VerificationVideo> videos) {
    final diff = DateTime.now().difference(videos.first.createdAt);
    if (diff.inMinutes < 60) return l10n.timeAgoMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeAgoHours(diff.inHours);
    return l10n.timeAgoDays(diff.inDays);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final videos =
        ref.watch(linkVerificationsProvider(link.id)).valueOrNull ??
            const <VerificationVideo>[];
    final hasVideos = videos.isNotEmpty;

    // 안 읽음 뱃지: 내가 마지막으로 폴더를 연 뒤에 올라온 (남의) 인증이 있으면 표시
    ref.watch(verificationSeenRevProvider);
    final hasUnseen = VerificationSeenService.hasUnseen(
      sharedLinkId: link.sharedLinkId!,
      videos: videos,
      myUid: FirebaseAuth.instance.currentUser?.uid,
    );

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // 폴더 열람 = 지금까지 올라온 인증을 본 것으로 처리 → 안 읽음 뱃지 제거
          final watermark = VerificationSeenService.latestCreatedAt(videos);
          if (watermark != null) {
            VerificationSeenService.markSeen(link.sharedLinkId!, watermark);
            ref.read(verificationSeenRevProvider.notifier).state++;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LinkVerificationGalleryScreen(link: link),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorScheme.outline),
          ),
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 도트 폴더 + 안 읽음 뱃지 (새 인증이 올라왔을 때만 빨간 점)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Opacity(
                    opacity: hasVideos ? 1.0 : 0.45,
                    child: PixelEmojiService.buildPixelEmoji(
                      'badge_filebox',
                      size: 76,
                    ),
                  ),
                  if (hasUnseen)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: colorScheme.surface, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              // 링크 제목
              Text(
                link.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: hasVideos ? null : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hasVideos
                    ? l10n.proofLatest(_latestAgo(l10n, videos))
                    : l10n.proofNoneYet,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: hasVideos
                      ? colorScheme.secondary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 링크 1개의 인증 그리드 갤러리.
/// "같은 링크를 공유·저장한 사람들"의 인증만 모아 보여준다.
class LinkVerificationGalleryScreen extends ConsumerWidget {
  const LinkVerificationGalleryScreen({super.key, required this.link});

  final LinkReminder link;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final sharedLinkId = link.sharedLinkId!;
    // 연결 모드(다같이/릴레이)에 맞는 노출 범위로 가져온다
    final videosAsync = ref.watch(linkVerificationsProvider(link.id));
    final myUid = FirebaseAuth.instance.currentUser?.uid;

    void refreshAll() {
      ref.invalidate(linkVerificationsProvider(link.id));
      ref.invalidate(verificationsBySharedLinkProvider(sharedLinkId));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(link.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: RefreshIndicator(
        onRefresh: () async => refreshAll(),
        child: videosAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: [
              const SizedBox(height: 200),
              Center(
                child: Text(
                  l10n.proofLoadFailed,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          data: (videos) => GridView.builder(
            padding: const EdgeInsets.fromLTRB(
                Spacing.md, Spacing.md, Spacing.md, Spacing.xl * 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: Spacing.sm,
              crossAxisSpacing: Spacing.sm,
              childAspectRatio: 3 / 4,
            ),
            // +1 = 맨 앞 "나도 인증하기" (이 링크로 바로 촬영)
            itemCount: videos.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _RecordTile(
                  onTap: () async {
                    // 인증은 알람 울린 뒤 윈도우(10분) 안에만 가능 — 아무 때나 막음
                    if (!PendingVerificationService.canVerifyNow(sharedLinkId)) {
                      ToastOverlay.showInfo(
                        context,
                        l10n.proofVerifyWindowClosed(
                            PendingVerificationService.window.inMinutes),
                      );
                      return;
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerificationRecordScreen(
                          alarmTitle: link.title,
                          sharedLinkId: sharedLinkId,
                        ),
                      ),
                    );
                    refreshAll();
                  },
                );
              }
              final video = videos[index - 1];
              return _VideoTile(
                video: video,
                isMine: video.uploaderUid == myUid,
                onChanged: refreshAll,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// "나도 인증하기" CTA 타일
class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.videocam, color: colorScheme.primary, size: 30),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              l10n.proofRecordMine,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 인증 영상 타일 (썸네일 + 업로더 + 길이)
class _VideoTile extends StatelessWidget {
  const _VideoTile({
    required this.video,
    required this.isMine,
    required this.onChanged,
  });

  final VerificationVideo video;
  final bool isMine;
  final VoidCallback onChanged;

  String _timeAgo(AppLocalizations l10n) {
    final diff = DateTime.now().difference(video.createdAt);
    if (diff.inMinutes < 60) return l10n.timeAgoMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeAgoHours(diff.inHours);
    return l10n.timeAgoDays(diff.inDays);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationPlayerScreen(video: video),
          ),
        );
        onChanged();
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: isMine
              ? Border.all(color: colorScheme.primary, width: 2)
              : Border.all(color: colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
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
                        errorWidget: (_, __, ___) => _placeholder(),
                      )
                    else
                      _placeholder(),
                    const Center(
                      child: Icon(Icons.play_circle_fill,
                          size: 40, color: Colors.white70),
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
                            l10n.proofMineBadge,
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
                        child: Text(
                          '${video.durationSeconds}″',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Text(video.uploaderProfileEmoji,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      video.uploaderNickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    _timeAgo(l10n),
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.black,
        child: Center(
          child: Icon(Icons.videocam,
              size: 32, color: Colors.white.withValues(alpha: 0.4)),
        ),
      );
}
