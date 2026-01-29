import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/badge.dart';
import '../../../data/models/link_reminder.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/links_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/badge_service.dart';
import '../../../services/firestore_service.dart';
import '../add_link/add_link_screen.dart';
import '../edit_link/edit_link_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import '../../widgets/banner_ad_widget.dart';
import '../../widgets/native_ad_widget.dart';
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
  @override
  void initState() {
    super.initState();
    // 배지 획득 콜백 설정
    BadgeService.instance.onNewBadges = _showBadgeNotification;
    // 파운더 배지 체크 (앱 최초 사용자)
    _checkFounderBadge();
  }

  Future<void> _checkFounderBadge() async {
    await BadgeService.instance.checkFounderBadge();
  }

  @override
  void dispose() {
    BadgeService.instance.onNewBadges = null;
    super.dispose();
  }

  void _showBadgeNotification(List<BadgeType> badges) {
    if (!mounted) return;
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
                      '배지 획득! ${badge.name}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      badge.description,
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
        title: const Text('LinkPing'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Spacing.sm),
            child: Center(
              child: Consumer(
                builder: (context, ref, _) {
                  final authState = ref.watch(authStateProvider);
                  final isGuest = authState.value?.isAnonymous ?? true;

                  // 로컬 닉네임 (게스트 때 저장한 것)
                  final localNickname = AuthService.instance.getGuestNickname();

                  if (isGuest) {
                    // 게스트는 로컬 닉네임 사용
                    return Text(
                      localNickname,
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }

                  // 회원은 Firestore에서 닉네임 가져오기 (없으면 로컬 닉네임 사용)
                  final userProfile = ref.watch(userProfileProvider);
                  final nickname = userProfile.value?.nickname ?? localNickname;
                  return Text(
                    nickname,
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                },
              ),
            ),
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
                          '${unreadCount.value! > 9 ? '9+' : unreadCount.value}',
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
          // 링크 목록 (프리미엄 아니면 3개마다 네이티브 광고)
          Expanded(
            child: links.isEmpty
                ? EmptyState(onAddLink: () => _onAddLink(context, canAddMore))
                : Consumer(
                    builder: (context, ref, _) {
                      final userProfile = ref.watch(userProfileProvider);
                      final isPremium = userProfile.value?.isPremium ?? false;

                      // 광고 포함한 총 아이템 수 계산
                      final adInterval = 3; // 3개마다 광고
                      final adCount = isPremium ? 0 : (links.length / adInterval).floor();
                      final totalItems = links.length + adCount;

                      return ListView.builder(
                        padding: const EdgeInsets.all(Spacing.md),
                        itemCount: totalItems,
                        itemBuilder: (context, index) {
                          // 프리미엄이면 광고 없이 링크만
                          if (isPremium) {
                            final link = links[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: Spacing.sm),
                              child: _LinkCardWithCount(
                                link: link,
                                onTap: () => _onCardTap(context, link),
                                onToggle: () => ref.read(linksProvider.notifier).toggleLink(link.id),
                                onDelete: () => ref.read(linksProvider.notifier).deleteLink(link.id),
                              ),
                            );
                          }

                          // 광고 위치 계산 (3, 7, 11, ...)
                          final adsBeforeIndex = (index / (adInterval + 1)).floor();
                          final isAdPosition = (index + 1) % (adInterval + 1) == 0 && index > 0;

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
                              onToggle: () => ref.read(linksProvider.notifier).toggleLink(link.id),
                              onDelete: () => ref.read(linksProvider.notifier).deleteLink(link.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          // 배너 광고 (프리미엄 사용자는 제외)
          Consumer(
            builder: (context, ref, _) {
              final userProfile = ref.watch(userProfileProvider);
              final isPremium = userProfile.value?.isPremium ?? false;

              if (isPremium) return const SizedBox.shrink();

              return const SafeArea(
                top: false,
                child: BannerAdWidget(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60), // 광고 높이만큼 위로
        child: FloatingActionButton(
          onPressed: () => _onAddLink(context, canAddMore),
          child: const Icon(Icons.add),
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
      MaterialPageRoute(
        builder: (context) => const AddLinkScreen(),
      ),
    );

    if (result != null) {
      await ref.read(linksProvider.notifier).addLink(
            url: result['url'],
            title: result['title'],
            hour: result['hour'],
            minute: result['minute'],
            repeatDays: List<int>.from(result['repeatDays']),
            additionalTimes: result['additionalTimes'] as List<ReminderTime>?,
            endDate: result['endDate'] as DateTime?,
          );

      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.linkAdded)),
        );
      }
    }
  }

  void _onCardTap(BuildContext context, LinkReminder link) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          link.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        contentPadding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.md),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 공유하기
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(l10n.share),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                Navigator.pop(context);
                _shareLink(context, link);
              },
            ),
            // 수정하기
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.edit),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                Navigator.pop(context);
                _goToEditLink(context, link);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareLink(BuildContext context, LinkReminder link) async {
    final l10n = AppLocalizations.of(context)!;

    // 로딩 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('공유 링크 생성 중...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      // Firestore에 공유 링크 생성
      final shareId = await FirestoreService.instance.createSharedLink(
        url: link.url,
        title: link.title,
        hour: link.hour,
        minute: link.minute,
        repeatDays: link.repeatDays,
      );

      // 공유 URL 생성 (TODO: 실제 도메인으로 변경)
      const baseUrl = 'https://linkping.app';
      final shareUrl = '$baseUrl/s/$shareId';

      final timeText = '${link.repeatString} ${link.timeString}';
      final message = '${link.title}\n⏰ $timeText\n\n$shareUrl';

      Share.share(message, subject: link.title);
    } catch (e) {
      if (context.mounted) {
        // 실패 시 기존 방식으로 공유
        final timeText = '${link.repeatString} ${link.timeString}';
        final message = l10n.shareMessage(timeText, link.url);
        Share.share(message, subject: link.title);
      }
    }
  }

  void _goToEditLink(BuildContext context, LinkReminder link) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditLinkScreen(link: link),
      ),
    );

    if (result != null) {
      if (result['delete'] == true) {
        ref.read(linksProvider.notifier).deleteLink(result['id']);
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.linkDeleted)),
          );
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
      );
      ref.read(linksProvider.notifier).updateLink(updatedLink);

      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.linkUpdated)),
        );
      }
    }
  }

  void _onNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
    );
  }

  void _onSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.linkLimitReached),
        content: Text(l10n.linkLimitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.premiumLater),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            child: Text(l10n.viewPremium),
          ),
        ],
      ),
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
