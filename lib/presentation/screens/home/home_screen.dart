import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/badge_localizations.dart';
import '../../../data/models/badge.dart';
import '../../../data/models/link_reminder.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/links_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/badge_service.dart';
import '../../../services/firestore_service.dart';
import '../../../services/pixel_emoji_service.dart';
import '../../../services/poring_service.dart';
import '../../../providers/poring_provider.dart';
import '../add_link/add_link_screen.dart';
import '../badges/badge_collection_screen.dart';
import '../edit_link/edit_link_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
// banner_ad_widget은 MainShell에서 통합 관리
import '../../widgets/native_ad_widget.dart';
import '../../widgets/share_preview_dialog.dart';
import '../../widgets/link_share_preview_dialog.dart';
import '../../widgets/poring_counter_widget.dart';
import '../../widgets/toast_overlay.dart';
import 'widgets/link_card.dart';
import 'widgets/empty_state.dart';

/// 배지 알림을 위한 GlobalKey
final homeScaffoldKey = GlobalKey<ScaffoldMessengerState>();

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late StreamSubscription _shareSubscription;

  @override
  void initState() {
    super.initState();
    // 배지 획득 콜백 설정
    BadgeService.instance.onNewBadges = _showBadgeNotification;
    // 파운더 배지 체크 (앱 최초 사용자)
    _checkFounderBadge();
    // 대기 중인 추천 포링 보상 체크
    _claimPendingPoringReward();
    // 외부 앱 공유 수신 리스너
    _listenForSharedIntent();
  }

  Future<void> _checkFounderBadge() async {
    await BadgeService.instance.checkFounderBadge();
  }

  Future<void> _claimPendingPoringReward() async {
    try {
      final claimed = await FirestoreService.instance
          .claimPendingPoringReward();
      if (claimed > 0) {
        // Hive 로컬 포링에 합산
        await PoringService.instance.addPoring(claimed);
        // Provider 상태 갱신
        ref.read(poringProvider.notifier).refresh();
        // 토스트 표시
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ToastOverlay.showSuccess(context, l10n.poringRewardClaimed(claimed));
        }
      }
    } catch (_) {
      // 보상 클레임 실패는 무시
    }
  }

  @override
  void dispose() {
    _shareSubscription.cancel();
    BadgeService.instance.onNewBadges = null;
    super.dispose();
  }

  void _listenForSharedIntent() {
    // 앱이 이미 실행 중일 때 공유 수신
    _shareSubscription = ReceiveSharingIntent.instance.getMediaStream().listen(
      _handleSharedMedia,
      onError: (error) => debugPrint('Share stream error: $error'),
    );

    // 앱이 공유로 처음 열렸을 때
    ReceiveSharingIntent.instance.getInitialMedia().then(
      _handleSharedMedia,
      onError: (e) => debugPrint('Initial media error: $e'),
    );
  }

  void _handleSharedMedia(List<SharedMediaFile> files) {
    if (files.isEmpty) return;
    final text = files.first.path;
    final url = _extractUrl(text);
    if (url != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddLinkScreen(initialUrl: url)),
      );
    }
    ReceiveSharingIntent.instance.reset();
  }

  String? _extractUrl(String text) {
    final urlRegex = RegExp(r'https?://[^\s]+');
    final match = urlRegex.firstMatch(text);
    return match?.group(0) ?? (text.startsWith('http') ? text : null);
  }

  void _showBadgeNotification(List<BadgeType> badges) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    for (final badge in badges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(badge.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.badgeEarned} ${badge.localizedName(context)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      badge.localizedDescription(context),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final links = ref.watch(linksProvider);
    final canAddMore = ref.watch(canAddMoreLinksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, _) {
            final authState = ref.watch(authStateProvider);
            final isGuest = authState.value?.isAnonymous ?? true;
            final guestProfile = ref.watch(guestProfileProvider);

            final String nickname;
            final String emoji;

            if (isGuest) {
              nickname = guestProfile.nickname;
              emoji = guestProfile.emoji;
            } else {
              final userProfile = ref.watch(userProfileProvider);
              nickname = userProfile.value?.nickname ?? guestProfile.nickname;
              emoji = userProfile.value?.profileEmoji ?? guestProfile.emoji;
            }

            return GestureDetector(
              onTap: () => _onSettings(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PixelEmojiService.buildPixelEmoji(emoji, size: 24),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      nickname,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          // 포링 카운터
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: PoringCounterWidget(),
          ),
          // 알림 아이콘 (읽지 않은 알림 수 표시)
          Consumer(
            builder: (context, ref, _) {
              final unreadCount = ref.watch(unreadNotificationCountProvider);
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => _onNotifications(context),
                  ),
                  if ((unreadCount.value ?? 0) > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${(unreadCount.value ?? 0) > 9 ? '9+' : unreadCount.value ?? 0}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _onSettings(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 스트릭/뱃지 헤더
          _buildStreakHeader(context),
          // 링크 목록 (프리미엄 아니면 2개마다 네이티브 광고)
          Expanded(
            child: links.isEmpty
                ? EmptyState(onAddLink: () => _onAddLink(context, canAddMore))
                : Consumer(
                    builder: (context, ref, _) {
                      final userProfile = ref.watch(userProfileProvider);
                      final isPremium = userProfile.value?.isPremium ?? false;

                      // 광고 포함한 총 아이템 수 계산
                      final adInterval = 2; // 2개마다 광고
                      final adCount = isPremium
                          ? 0
                          : (links.length / adInterval).floor();
                      final totalItems = links.length + adCount;

                      return ListView.builder(
                        padding: const EdgeInsets.all(Spacing.md),
                        itemCount: totalItems,
                        itemBuilder: (context, index) {
                          // 프리미엄이면 광고 없이 링크만
                          if (isPremium) {
                            final link = links[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: Spacing.sm,
                              ),
                              child: _LinkCardWithCount(
                                link: link,
                                onTap: () => _onCardTap(context, link),
                                onToggle: () => ref
                                    .read(linksProvider.notifier)
                                    .toggleLink(link.id),
                                onDelete: () => ref
                                    .read(linksProvider.notifier)
                                    .deleteLink(link.id),
                              ),
                            );
                          }

                          // 광고 위치 계산 (2, 5, 8, ...)
                          final adsBeforeIndex = (index / (adInterval + 1))
                              .floor();
                          final isAdPosition =
                              (index + 1) % (adInterval + 1) == 0 && index > 0;

                          if (isAdPosition) {
                            return const NativeAdWidget();
                          }

                          // 실제 링크 인덱스
                          final linkIndex = index - adsBeforeIndex;
                          if (linkIndex >= links.length) {
                            return const SizedBox.shrink();
                          }

                          final link = links[linkIndex];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: Spacing.sm),
                            child: _LinkCardWithCount(
                              link: link,
                              onTap: () => _onCardTap(context, link),
                              onToggle: () => ref
                                  .read(linksProvider.notifier)
                                  .toggleLink(link.id),
                              onDelete: () => ref
                                  .read(linksProvider.notifier)
                                  .deleteLink(link.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          // 배너 광고는 MainShell에서 통합 관리
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_fab',
        onPressed: () => _onAddLink(context, canAddMore),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStreakHeader(BuildContext context) {
    final links = ref.watch(linksProvider);

    return FutureBuilder<
      List<({BadgeType type, UserBadge? earned, int progress, int target})>
    >(
      future: BadgeService.instance.getAllBadgesWithProgress(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final badges = snapshot.data!;

        // 뱃지 우선순위 (낮을수록 높은 우선순위)
        int getBadgePriority(BadgeType type) {
          switch (type) {
            case BadgeType.firstLink:
              return 1; // 첫 링크 - 최우선
            case BadgeType.streak3:
              return 2; // 3일 스트릭
            case BadgeType.firstCheer:
              return 3; // 첫 응원
            case BadgeType.firstPoke:
              return 4; // 첫 찌르기
            case BadgeType.streak7:
              return 5; // 7일 스트릭
            case BadgeType.earlyBird:
              return 6;
            case BadgeType.nightOwl:
              return 7;
            case BadgeType.quickDraw:
              return 8;
            case BadgeType.speedDemon:
              return 9;
            case BadgeType.linkCollector:
              return 10;
            case BadgeType.cheerLeader:
              return 11;
            case BadgeType.poker:
              return 12;
            case BadgeType.streak30:
              return 13;
            case BadgeType.perfectWeek:
              return 14;
            default:
              return 99;
          }
        }

        // 특별 케이스: 첫 링크 뱃지 (링크가 없을 때 표시)
        final firstLinkBadge = badges.firstWhere(
          (b) => b.type == BadgeType.firstLink,
          orElse: () =>
              (type: BadgeType.firstLink, earned: null, progress: 0, target: 1),
        );

        if (links.isEmpty && firstLinkBadge.earned == null) {
          // 첫 링크가 없으면 "첫 링크" 뱃지 안내
          return _buildBadgeHint(context, firstLinkBadge.type, 0, 1);
        }

        // 달성 임박 뱃지 찾기 (90% 이상, 아직 미획득)
        final nearlyComplete = badges
            .where(
              (b) =>
                  b.earned == null &&
                  b.target > 0 &&
                  b.progress > 0 &&
                  (b.progress / b.target) >= 0.9,
            ) // 90% 이상
            .toList();

        // 우선순위 → 진행률 순으로 정렬
        nearlyComplete.sort((a, b) {
          final priorityCompare = getBadgePriority(
            a.type,
          ).compareTo(getBadgePriority(b.type));
          if (priorityCompare != 0) return priorityCompare;
          return (b.progress / b.target).compareTo(a.progress / a.target);
        });

        // 표시할 내용이 없으면 숨김
        if (nearlyComplete.isEmpty) {
          return const SizedBox.shrink();
        }

        final badge = nearlyComplete.first;
        return _buildBadgeHint(
          context,
          badge.type,
          badge.progress,
          badge.target,
        );
      },
    );
  }

  Widget _buildBadgeHint(
    BuildContext context,
    BadgeType type,
    int progress,
    int target,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BadgeCollectionScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          Spacing.md,
          Spacing.sm,
          Spacing.md,
          0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer,
              colorScheme.primaryContainer.withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(type.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    type.localizedName(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$progress/$target',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: target > 0 ? progress / target : 0,
                            minHeight: 6,
                            backgroundColor: colorScheme.outline.withValues(
                              alpha: 0.2,
                            ),
                            valueColor: AlwaysStoppedAnimation(
                              colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddLink(BuildContext context, bool canAddMore) async {
    if (!canAddMore) {
      _showPremiumDialog(context);
      return;
    }

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const AddLinkScreen()),
    );

    if (result != null) {
      await ref
          .read(linksProvider.notifier)
          .addLink(
            url: result['url'],
            title: result['title'],
            hour: result['hour'],
            minute: result['minute'],
            repeatDays: List<int>.from(result['repeatDays']),
            additionalTimes: result['additionalTimes'] as List<ReminderTime>?,
            endDate: result['endDate'] as DateTime?,
            isLocked: result['isLocked'] as bool? ?? false,
            category: result['category'] as LinkCategory?,
            soundId: result['soundId'] as String?,
          );

      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastOverlay.showSuccess(context, l10n.linkAdded);
      }
    }
  }

  void _onCardTap(BuildContext parentContext, LinkReminder link) {
    final l10n = AppLocalizations.of(parentContext)!;
    final colorScheme = Theme.of(parentContext).colorScheme;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(link.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        content: Row(
          children: [
            // 공유하기 버튼
            Expanded(
              child: _buildActionButton(
                context: dialogContext,
                icon: Icons.share_outlined,
                label: l10n.share,
                color: colorScheme.primary,
                onTap: () {
                  Navigator.pop(dialogContext);
                  _shareLink(parentContext, link);
                },
              ),
            ),
            const SizedBox(width: Spacing.sm),
            // 수정하기 버튼
            Expanded(
              child: _buildActionButton(
                context: dialogContext,
                icon: Icons.edit_outlined,
                label: l10n.edit,
                color: colorScheme.secondary,
                onTap: () {
                  Navigator.pop(dialogContext);
                  _goToEditLink(parentContext, link);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareLink(BuildContext context, LinkReminder link) {
    // 링크 생성 시 설정한 isLocked 값 사용 (물어보지 않음)
    _doShare(context, link);
  }

  void _doShare(BuildContext context, LinkReminder link) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    // 로딩 표시
    ToastOverlay.show(
      context,
      message: l10n.generatingShareLink,
      icon: Icons.link,
      duration: const Duration(seconds: 1),
    );

    try {
      // Firestore에 공유 링크 생성 (링크의 isLocked 값 + 언어 코드)
      final shareId = await FirestoreService.instance.createSharedLink(
        url: link.url,
        title: link.title,
        hour: link.hour,
        minute: link.minute,
        repeatDays: link.repeatDays,
        isLocked: link.isLocked,
        languageCode: locale.languageCode, // 공유자의 언어 코드 저장
      );

      // 고정 알람이면 로컬 링크에 sharedLinkId 저장 (삭제/수정 알림용)
      if (link.isLocked && link.sharedLinkId == null) {
        final updatedLink = link.copyWith(sharedLinkId: shareId);
        ref.read(linksProvider.notifier).updateLink(updatedLink);
      }

      // 공유 URL 생성
      final shareUrl = AppConstants.buildShareUrl(shareId);

      final timeText = '${link.getRepeatString(isKorean)} ${link.timeString}';
      if (!context.mounted) return;
      await LinkSharePreviewDialog.show(
        context,
        title: link.title,
        timeText: timeText,
        shareUrl: shareUrl,
        isLocked: link.isLocked,
        isKorean: isKorean,
      );
    } catch (e) {
      if (context.mounted) {
        // 링크 생성 실패 시 원본 링크로 공유
        final timeText = '${link.getRepeatString(isKorean)} ${link.timeString}';
        await LinkSharePreviewDialog.show(
          context,
          title: link.title,
          timeText: timeText,
          shareUrl: link.url,
          isLocked: link.isLocked,
          isKorean: isKorean,
        );
      }
    }
  }

  void _goToEditLink(BuildContext context, LinkReminder link) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => EditLinkScreen(link: link)),
    );

    if (result != null) {
      if (result['delete'] == true) {
        ref.read(linksProvider.notifier).deleteLink(result['id']);
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ToastOverlay.showSuccess(context, l10n.linkDeleted);
        }
        return;
      }

      final updatedLink = link.copyWith(
        url: result['url'],
        title: result['title'],
        hour: result['hour'],
        minute: result['minute'],
        repeatDays: List<int>.from(result['repeatDays']),
        additionalTimes: result['additionalTimes'] as List<ReminderTime>?,
        endDate: result['endDate'] as DateTime?,
        clearEndDate: result['clearEndDate'] as bool? ?? false,
        isLocked: result['isLocked'] as bool? ?? link.isLocked,
        category: result['category'] as LinkCategory?,
        clearCategory: result['clearCategory'] as bool? ?? false,
        soundId: result['soundId'] as String?,
        clearSoundId: result['clearSoundId'] as bool? ?? false,
      );
      ref.read(linksProvider.notifier).updateLink(updatedLink);

      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastOverlay.showSuccess(context, l10n.linkUpdated);
      }
    }
  }

  void _onNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  void _onSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    // 사용자 UID에서 초대 코드 생성
    final user = ref.read(authStateProvider).value;
    final referralCode = user != null
        ? FirestoreService.instance.generateReferralCode(user.uid)
        : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.linkLimitReached),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.linkLimitMessageBase, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            // 친구초대하기 버튼
            FilledButton.tonal(
              onPressed: () {
                Navigator.pop(context);
                _shareInvite(referralCode, isKorean);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.card_giftcard, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.inviteFriendForBonus),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.inviteFriendBonusDesc,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Text(l10n.viewPremium),
          ),
        ],
      ),
    );
  }

  void _shareInvite(String referralCode, bool isKorean) {
    SharePreviewDialog.show(
      context,
      referralCode: referralCode,
      isKorean: isKorean,
    );
  }
}

/// Firestore에서 saveCount를 가져오는 LinkCard 래퍼
class _LinkCardWithCount extends ConsumerWidget {
  final LinkReminder link;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _LinkCardWithCount({
    required this.link,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveCountAsync = ref.watch(urlSaveCountProvider(link.urlHash));
    final saveCount = saveCountAsync.value ?? 0;

    // Hot Link 배지 체크 (10명 이상 저장 시)
    if (saveCount >= 10) {
      BadgeService.instance.checkHotLinkBadge(saveCount);
    }

    return LinkCard(
      link: link,
      saveCount: saveCount,
      onTap: onTap,
      onToggle: onToggle,
      onDelete: onDelete,
    );
  }
}
