import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/link_reminder.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/links_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/auth_service.dart';
import '../add_link/add_link_screen.dart';
import '../edit_link/edit_link_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/link_card.dart';
import 'widgets/empty_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

                  if (isGuest) {
                    // 게스트는 로컬에서 닉네임 가져오기
                    final nickname = AuthService.instance.getGuestNickname();
                    return Text(
                      nickname,
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }

                  // 회원은 Firestore에서 닉네임 가져오기
                  final userProfile = ref.watch(userProfileProvider);
                  final nickname = userProfile.value?.nickname ?? '게스트';
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
      body: links.isEmpty
          ? EmptyState(onAddLink: () => _onAddLink(context, ref, canAddMore))
          : ListView.builder(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: links.length,
              itemBuilder: (context, index) {
                final link = links[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: _LinkCardWithCount(
                    link: link,
                    onTap: () => _onEditLink(context, ref, link),
                    onToggle: () => ref.read(linksProvider.notifier).toggleLink(link.id),
                    onDelete: () => ref.read(linksProvider.notifier).deleteLink(link.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddLink(context, ref, canAddMore),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onAddLink(BuildContext context, WidgetRef ref, bool canAddMore) async {
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
          );

      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.linkAdded)),
        );
      }
    }
  }

  void _onEditLink(BuildContext context, WidgetRef ref, LinkReminder link) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditLinkScreen(link: link),
      ),
    );

    if (result != null) {
      final l10n = AppLocalizations.of(context)!;
      if (result['delete'] == true) {
        ref.read(linksProvider.notifier).deleteLink(result['id']);
        if (context.mounted) {
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
      );
      ref.read(linksProvider.notifier).updateLink(updatedLink);

      if (context.mounted) {
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

    return LinkCard(
      link: link,
      saveCount: saveCountAsync.value ?? 0,
      onTap: onTap,
      onToggle: onToggle,
      onDelete: onDelete,
    );
  }
}
