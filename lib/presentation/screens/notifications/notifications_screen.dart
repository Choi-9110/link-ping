import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../data/models/ping_notification.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/user_provider.dart';
import '../../../services/firestore_service.dart';
import '../inquiry/inquiry_detail_screen.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(myNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          TextButton(
            onPressed: () {
              FirestoreService.instance.markAllNotificationsAsRead();
            },
            child: Text(l10n.markAllRead),
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    l10n.noNotifications,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    l10n.noNotificationsSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationTile(notification: notification);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.notificationLoadFailed)),
      ),
    );
  }
}

class _NotificationTile extends StatefulWidget {
  final PingNotification notification;

  const _NotificationTile({required this.notification});

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  bool _isVoting = false;

  PingNotification get notification => widget.notification;

  Future<void> _vote(bool approve) async {
    if (_isVoting) return;
    if (notification.modificationRequestId == null) return;

    setState(() => _isVoting = true);

    try {
      await FirestoreService.instance.voteOnModificationRequest(
        requestId: notification.modificationRequestId!,
        approve: approve,
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(approve ? l10n.approved : l10n.rejected),
          ),
        );
      }

      // 읽음 처리
      if (!notification.isRead) {
        await FirestoreService.instance.markNotificationAsRead(notification.id);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.voteFailed)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isVoting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // 타입별 설정
    Color iconBgColor;
    Color iconColor;
    IconData icon;
    String title;

    switch (notification.type) {
      case PingType.cheer:
        iconBgColor = Colors.pink.withValues(alpha: 0.1);
        iconColor = Colors.pink;
        icon = Icons.favorite;
        title = l10n.cheerReceivedFrom(notification.fromNickname);
        break;
      case PingType.tease:
        iconBgColor = Colors.orange.withValues(alpha: 0.1);
        iconColor = Colors.orange;
        icon = Icons.local_fire_department;
        title = l10n.teaseReceivedFrom(notification.fromNickname);
        break;
      case PingType.inquiryReply:
        iconBgColor = Colors.green.withValues(alpha: 0.1);
        iconColor = Colors.green;
        icon = Icons.support_agent;
        title = l10n.inquiryReplyArrived;
        break;
      case PingType.linkDeleted:
        iconBgColor = Colors.red.withValues(alpha: 0.1);
        iconColor = Colors.red;
        icon = Icons.delete_outline;
        title = l10n.linkAlarmDeleted;
        break;
      case PingType.modificationRequest:
        iconBgColor = Colors.blue.withValues(alpha: 0.1);
        iconColor = Colors.blue;
        icon = Icons.edit_notifications;
        title = l10n.timeModificationRequest;
        break;
      case PingType.modificationApproved:
        iconBgColor = Colors.green.withValues(alpha: 0.1);
        iconColor = Colors.green;
        icon = Icons.check_circle_outline;
        title = l10n.modificationApproved;
        break;
      case PingType.modificationRejected:
        iconBgColor = Colors.grey.withValues(alpha: 0.1);
        iconColor = Colors.grey;
        icon = Icons.cancel_outlined;
        title = l10n.modificationRejected;
        break;
      case PingType.modificationApplied:
        iconBgColor = Colors.amber.withValues(alpha: 0.1);
        iconColor = Colors.amber;
        icon = Icons.warning_amber;
        title = l10n.alarmTurnedOff;
        break;
      case PingType.referralAccepted:
        iconBgColor = Colors.purple.withValues(alpha: 0.1);
        iconColor = Colors.purple;
        icon = Icons.person_add;
        title = notification.fromNickname.isNotEmpty
            ? l10n.referralAcceptedTitle(notification.fromNickname)
            : l10n.referralAcceptedMessage;
        break;
    }

    final isInquiryReply = notification.type == PingType.inquiryReply;
    final isModificationRequest = notification.type == PingType.modificationRequest;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: notification.isRead
            ? colorScheme.surface
            : colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: isModificationRequest
            ? null // 수정 요청은 버튼으로만 처리
            : () {
                if (!notification.isRead) {
                  FirestoreService.instance.markNotificationAsRead(notification.id);
                }
                // 문의 답변이면 상세 페이지로 이동
                if (isInquiryReply && notification.inquiryId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InquiryDetailScreen(
                        inquiryId: notification.inquiryId!,
                      ),
                    ),
                  );
                }
              },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: Spacing.md),

              // 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),

                    // 메시지
                    Builder(builder: (context) {
                      // 수신자의 언어로 메시지 번역
                      final locale = Localizations.localeOf(context);
                      final langCode = locale.languageCode;
                      String displayMessage = notification.message;

                      // messageIndex가 있으면 수신자 언어로 번역
                      if (notification.messageIndex != null) {
                        if (notification.type == PingType.cheer) {
                          displayMessage = PingMessages.getCheerMessageForLang(
                            notification.messageIndex!,
                            langCode,
                          );
                        } else if (notification.type == PingType.tease) {
                          displayMessage = PingMessages.getTeaseMessageForLang(
                            notification.messageIndex!,
                            langCode,
                          );
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.all(Spacing.sm),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          displayMessage,
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }),
                    const SizedBox(height: Spacing.xs),

                    // 링크 제목 & 시간
                    Row(
                      children: [
                        Icon(
                          isInquiryReply ? Icons.help_outline : Icons.link,
                          size: 14,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            isInquiryReply
                                ? (notification.inquiryTitle ?? l10n.inquiry)
                                : notification.urlTitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatTime(notification.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),

                    // 문의 답변이면 탭하여 확인 안내
                    if (isInquiryReply) ...[
                      const SizedBox(height: Spacing.xs),
                      Text(
                        l10n.tapToViewReply,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    // 수정 요청이면 승인/거절 버튼
                    if (isModificationRequest) ...[
                      const SizedBox(height: Spacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isVoting ? null : () => _vote(false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                              child: _isVoting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(l10n.reject),
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: FilledButton(
                              onPressed: _isVoting ? null : () => _vote(true),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: _isVoting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(l10n.approve),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        l10n.noResponseWarning,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // 읽지 않음 표시
              if (!notification.isRead && !isModificationRequest)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return l10n.justNow;
    } else if (diff.inHours < 1) {
      return l10n.minutesAgo(diff.inMinutes);
    } else if (diff.inDays < 1) {
      return l10n.hoursAgo(diff.inHours);
    } else if (diff.inDays < 7) {
      return l10n.daysAgo(diff.inDays);
    } else {
      return '${time.month}/${time.day}';
    }
  }
}
