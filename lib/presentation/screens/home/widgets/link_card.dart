import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../widgets/dialog_actions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../data/models/link_reminder.dart';
import '../../../../data/models/verification_video.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/verification_provider.dart';
import '../../../../services/url_launcher_service.dart';
import '../../../../services/verification_seen_service.dart';
import '../../../widgets/saved_users_bottom_sheet.dart';
import '../../verification/verification_gallery_sheet.dart';

class LinkCard extends ConsumerWidget {
  final LinkReminder link;
  final int saveCount;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const LinkCard({
    super.key,
    required this.link,
    required this.saveCount,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  void _showSavedUsers(BuildContext context) {
    if (link.sharedLinkId == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SavedUsersBottomSheet(
        sharedLinkId: link.sharedLinkId!,
        urlTitle: link.title,
        outgoingShareId: link.outgoingShareId,
      ),
    );
  }

  void _showVerifications(BuildContext context) {
    if (link.sharedLinkId == null) return;
    VerificationGallerySheet.show(
      context,
      sharedLinkId: link.sharedLinkId!,
      linkTitle: link.title,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final verifVideos = link.sharedLinkId == null
        ? const <VerificationVideo>[]
        : (ref
                .watch(verificationsBySharedLinkProvider(link.sharedLinkId!))
                .value ??
            const <VerificationVideo>[]);
    final verificationCount = verifVideos.length;
    // 안 읽음 표시: 내가 마지막으로 본 뒤 올라온 (남의) 인증이 있으면 빨간 점
    ref.watch(verificationSeenRevProvider);
    final hasUnseenVerif = link.sharedLinkId != null &&
        VerificationSeenService.hasUnseen(
          sharedLinkId: link.sharedLinkId!,
          videos: verifVideos,
          myUid: FirebaseAuth.instance.currentUser?.uid,
        );

    return Dismissible(
      key: Key(link.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.md),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            final dialogL10n = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
              title: Text(dialogL10n.delete),
              content: Text(dialogL10n.deleteConfirm),
              actions: [
                DialogActions(buttons: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(dialogL10n.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(dialogL10n.delete),
                  ),
                ]),
              ],
            );
          },
        );
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: link.isEnabled
                ? colorScheme.outline
                : colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 좌측: 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 카테고리 뱃지
                      if (link.category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Builder(builder: (context) {
                            final locale = Localizations.localeOf(context);
                            final isKorean = locale.languageCode == 'ko';
                            return Text(
                              link.category!.displayName(isKorean),
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                      ],
                      // 제목
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              link.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: link.isEnabled ? null : colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // 잠금 링크 표시
                          if (link.isLocked) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock,
                                    size: 12,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    l10n.locked,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      // 요일 칩 (월~일) — 선택 요일 코랄 강조
                      _buildDayChips(context),
                      // URL(서비스명) — 맨 아래 (제목만 알림이면 숨김)
                      if (link.url.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.link,
                                size: 14, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _getServiceName(link.url),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      // 저장 수 + 인증 영상
                      if (saveCount > 0 || verificationCount > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (saveCount > 0)
                              GestureDetector(
                                onTap: () => _showSavedUsers(context),
                                child: Text(
                                  l10n.savedByCount(saveCount),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (saveCount > 0 && verificationCount > 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                child: Text(
                                  '·',
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant),
                                ),
                              ),
                            if (verificationCount > 0)
                              GestureDetector(
                                onTap: () {
                                  // 열람 처리 → 안 읽음 점 제거
                                  final watermark =
                                      VerificationSeenService.latestCreatedAt(
                                          verifVideos);
                                  if (watermark != null &&
                                      link.sharedLinkId != null) {
                                    VerificationSeenService.markSeen(
                                        link.sharedLinkId!, watermark);
                                    ref
                                        .read(verificationSeenRevProvider
                                            .notifier)
                                        .state++;
                                  }
                                  _showVerifications(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.tertiaryContainer
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('🎬',
                                          style: TextStyle(fontSize: 11)),
                                      // 개수는 의미 없음 → 새 인증이 있을 때만 빨간 점
                                      if (hasUnseenVerif) ...[
                                        const SizedBox(width: 4),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: colorScheme.error,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // 우측: 토글(시간 위) → 시간(크게) → 반복/디데이
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 토글
                    Switch(
                      value: link.isEnabled,
                      onChanged: (_) => onToggle(),
                    ),
                    const SizedBox(height: 2),
                    // 시간 — 코랄 강조 (여러 시간이면 축소돼 들어감)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 130),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          link.timeString,
                          maxLines: 1,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: link.isEnabled
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // 반복 요약 (종료일 있으면 D-day 강조)
                    Builder(builder: (context) {
                      final isKorean =
                          Localizations.localeOf(context).languageCode == 'ko';
                      return Text(
                        link.hasEndDate
                            ? link.dDayString
                            : link.getRepeatString(isKorean),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: link.hasEndDate && link.isEnabled
                              ? colorScheme.secondary
                              : colorScheme.onSurfaceVariant,
                          fontWeight:
                              link.hasEndDate ? FontWeight.w700 : null,
                        ),
                      );
                    }),
                    if (link.hasEndDate)
                      Text(
                        '~${_formatDate(link.endDate!)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 요일 칩 (월~일 순). 선택 요일 = 코랄, 미선택 = 흐림.
  /// 모델 repeatDays 는 0=일 ~ 6=토.
  Widget _buildDayChips(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const order = [1, 2, 3, 4, 5, 6, 0]; // 표시 순서: 월~일
    // 언어별 요일 머리글자 (ARB: dayChipLabels, 쉼표 구분 월~일 순)
    final labels = AppLocalizations.of(context)!.dayChipLabels.split(',');

    return Opacity(
      opacity: link.isEnabled ? 1 : 0.55,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 7; i++) ...[
            if (i > 0) const SizedBox(width: 5),
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: link.repeatDays.contains(order[i])
                    ? colorScheme.primary.withValues(alpha: 0.15)
                    : colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: link.repeatDays.contains(order[i])
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// URL에서 서비스명 추출
  String _getServiceName(String url) {
    try {
      // 전화번호인 경우
      final normalizedUrl = UrlLauncherService.ensureScheme(url);
      if (UrlLauncherService.isPhoneUrl(normalizedUrl)) {
        final phoneNumber = UrlLauncherService.getDisplayPhoneNumber(normalizedUrl);
        return '📞 $phoneNumber';
      }

      final host = Uri.parse(normalizedUrl).host.toLowerCase();

      // 주요 서비스 매핑 (영어 브랜드명)
      if (host.contains('naver')) return 'Naver';
      if (host.contains('youtube') || host.contains('youtu.be')) return 'YouTube';
      if (host.contains('instagram')) return 'Instagram';
      if (host.contains('tiktok')) return 'TikTok';
      if (host.contains('twitter') || host.contains('x.com')) return 'X';
      if (host.contains('facebook')) return 'Facebook';
      if (host.contains('kakao')) return 'Kakao';
      if (host.contains('google')) return 'Google';
      if (host.contains('github')) return 'GitHub';
      if (host.contains('notion')) return 'Notion';
      if (host.contains('velog')) return 'Velog';
      if (host.contains('tistory')) return 'Tistory';
      if (host.contains('brunch')) return 'Brunch';
      if (host.contains('linkedin')) return 'LinkedIn';
      if (host.contains('reddit')) return 'Reddit';
      if (host.contains('twitch')) return 'Twitch';
      if (host.contains('spotify')) return 'Spotify';
      if (host.contains('apple')) return 'Apple';
      if (host.contains('amazon')) return 'Amazon';
      if (host.contains('coupang')) return 'Coupang';

      // 매핑되지 않으면 호스트 반환 (www. 제거)
      return host.replaceFirst('www.', '');
    } catch (_) {
      return url;
    }
  }

  /// 날짜 포맷
  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
