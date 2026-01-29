import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/theme/spacing.dart';
import '../../data/models/ping_notification.dart';
import '../../data/models/saved_by_user.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user_provider.dart';
import '../../services/badge_service.dart';
import '../../services/firestore_service.dart';

class SavedUsersBottomSheet extends ConsumerStatefulWidget {
  final String urlHash;
  final String urlTitle;

  const SavedUsersBottomSheet({
    super.key,
    required this.urlHash,
    required this.urlTitle,
  });

  @override
  ConsumerState<SavedUsersBottomSheet> createState() => _SavedUsersBottomSheetState();
}

class _SavedUsersBottomSheetState extends ConsumerState<SavedUsersBottomSheet> {
  final Set<String> _sendingPing = {};

  static const _rateLimitMinutes = 5;
  static const _rateLimitKey = 'lastPingSentAt';

  /// 발송 제한 체크 (무료: 5분 내 1회, 프리미엄: 무제한)
  bool _canSendPing() {
    final isPremium = ref.read(userProfileProvider).value?.isPremium ?? false;
    if (isPremium) return true;

    final settingsBox = Hive.box('settings');
    final lastSentAt = settingsBox.get(_rateLimitKey) as int?;
    if (lastSentAt == null) return true;

    final lastSentTime = DateTime.fromMillisecondsSinceEpoch(lastSentAt);
    final diff = DateTime.now().difference(lastSentTime).inMinutes;
    return diff >= _rateLimitMinutes;
  }

  /// 마지막 발송 시간 저장
  Future<void> _recordPingSent() async {
    final settingsBox = Hive.box('settings');
    await settingsBox.put(_rateLimitKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// 남은 대기 시간 (분)
  int _getRemainingMinutes() {
    final settingsBox = Hive.box('settings');
    final lastSentAt = settingsBox.get(_rateLimitKey) as int?;
    if (lastSentAt == null) return 0;

    final lastSentTime = DateTime.fromMillisecondsSinceEpoch(lastSentAt);
    final diff = DateTime.now().difference(lastSentTime).inMinutes;
    return _rateLimitMinutes - diff;
  }

  /// 메시지 선택 팝업 표시 후 전송
  Future<void> _showMessageDialog(SavedByUser user, PingType type) async {
    // 자기 자신에게는 보내지 않음
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.uid == user.uid) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cannotSendToSelf)),
        );
      }
      return;
    }

    // 발송 제한 체크
    if (!_canSendPing()) {
      if (mounted) {
        final remaining = _getRemainingMinutes();
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pingRateLimited(remaining))),
        );
      }
      return;
    }

    final messages = type == PingType.cheer
        ? PingMessages.cheerMessages
        : PingMessages.teaseMessages;

    final selectedMessage = await showDialog<String>(
      context: context,
      builder: (context) => _MessageSelectionDialog(
        type: type,
        messages: messages,
        recipientName: user.nickname,
      ),
    );

    if (selectedMessage != null && mounted) {
      await _sendPing(user, type, selectedMessage);
    }
  }

  Future<void> _sendPing(SavedByUser user, PingType type, String message) async {
    setState(() => _sendingPing.add('${user.uid}_${type.name}'));

    try {
      await FirestoreService.instance.sendPing(
        toUid: user.uid,
        type: type,
        urlTitle: widget.urlTitle,
        customMessage: message,
      );

      // 배지 기록 (응원/찌르기)
      if (type == PingType.cheer) {
        await BadgeService.instance.recordCheer();
      } else {
        await BadgeService.instance.recordPoke();
      }

      // 발송 시간 기록 (무료 사용자용)
      await _recordPingSent();

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              type == PingType.cheer
                  ? l10n.cheerSent(user.nickname)
                  : l10n.teaseSent(user.nickname),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.sendFailed)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sendingPing.remove('${user.uid}_${type.name}'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final savedUsersAsync = ref.watch(savedByUsersProvider(widget.urlHash));
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들
          Container(
            margin: const EdgeInsets.only(top: Spacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 제목
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Text(
              '이 링크를 저장한 사람들',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Divider(height: 1),

          // 유저 목록
          Flexible(
            child: savedUsersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(Spacing.xl),
                    child: Text('아직 저장한 사람이 없어요'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isMe = user.uid == currentUid;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isMe
                            ? colorScheme.primary
                            : colorScheme.primaryContainer,
                        child: Text(
                          user.nickname.isNotEmpty
                              ? user.nickname[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: isMe
                                ? colorScheme.onPrimary
                                : colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(user.nickname),
                          if (isMe) ...[
                            const SizedBox(width: Spacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '나',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: isMe
                          ? null
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 응원하기 버튼
                                _PingButton(
                                  icon: Icons.favorite,
                                  label: '응원',
                                  color: Colors.pink,
                                  isLoading: _sendingPing.contains('${user.uid}_cheer'),
                                  onPressed: () => _showMessageDialog(user, PingType.cheer),
                                ),
                                const SizedBox(width: Spacing.xs),
                                // 약올리기 버튼
                                _PingButton(
                                  icon: Icons.local_fire_department,
                                  label: '약올리기',
                                  color: Colors.orange,
                                  isLoading: _sendingPing.contains('${user.uid}_tease'),
                                  onPressed: () => _showMessageDialog(user, PingType.tease),
                                ),
                              ],
                            ),
                    );
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => const Padding(
                padding: EdgeInsets.all(Spacing.xl),
                child: Text('불러오기 실패'),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + Spacing.md),
        ],
      ),
    );
  }
}

class _PingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback onPressed;

  const _PingButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xs,
          ),
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: color),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// 메시지 선택 다이얼로그
class _MessageSelectionDialog extends StatelessWidget {
  final PingType type;
  final List<String> messages;
  final String recipientName;

  const _MessageSelectionDialog({
    required this.type,
    required this.messages,
    required this.recipientName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final isCheer = type == PingType.cheer;
    final color = isCheer ? Colors.pink : Colors.orange;
    final icon = isCheer ? Icons.favorite : Icons.local_fire_department;
    final title = isCheer ? l10n.selectCheerMessage : l10n.selectTeaseMessage;

    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: messages.length,
          separatorBuilder: (_, __) => const SizedBox(height: Spacing.xs),
          itemBuilder: (context, index) {
            final message = messages[index];
            return Material(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => Navigator.pop(context, message),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(Spacing.md, Spacing.sm, Spacing.md, Spacing.md),
    );
  }
}
