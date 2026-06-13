import 'dart:async';
import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/spacing.dart';
import '../../data/models/ping_notification.dart';
import '../../data/models/saved_by_user.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/poring_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/ad_service.dart';
import '../../services/badge_service.dart';
import '../../services/firestore_service.dart';
import '../../services/ping_window_service.dart';
import '../../services/pixel_emoji_service.dart';

class SavedUsersBottomSheet extends ConsumerStatefulWidget {
  final String sharedLinkId;
  final String urlTitle;

  /// 릴레이 링: 내가 뿌린 고리 문서 ID — 받은 고리와 합쳐서
  /// "나와 직접 주고받은 사람" 전체를 보여준다.
  final String? outgoingShareId;

  const SavedUsersBottomSheet({
    super.key,
    required this.sharedLinkId,
    required this.urlTitle,
    this.outgoingShareId,
  });

  @override
  ConsumerState<SavedUsersBottomSheet> createState() =>
      _SavedUsersBottomSheetState();
}

class _SavedUsersBottomSheetState extends ConsumerState<SavedUsersBottomSheet> {
  final Set<String> _sendingPing = {};
  Timer? _windowTimer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _startWindowTimer();
  }

  @override
  void dispose() {
    _windowTimer?.cancel();
    super.dispose();
  }

  void _startWindowTimer() {
    _windowTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final remaining = PingWindowService.instance.getRemainingSeconds();
    if (mounted && remaining != _remainingSeconds) {
      setState(() {
        _remainingSeconds = remaining;
      });
    }
  }

  /// 현재 유저의 국가 가져오기
  String? _getMyCountry() {
    final userProfile = ref.read(userProfileProvider).value;
    return userProfile?.country;
  }

  /// 윈도우 내에서 전송 가능한지 체크
  bool _isWithinWindow() {
    return PingWindowService.instance.isWithinWindow();
  }

  /// 무료 유저가 추가 전송 가능한지 (광고 필요 여부)
  bool _needsAdForMore() {
    final isPremium = ref.read(userProfileProvider).value?.isPremium ?? false;
    if (isPremium) return false;
    return !PingWindowService.instance.canSendFree();
  }

  /// 포링으로 추가 전송 또는 광고 시청 후 전송
  Future<bool> _spendPoringForSend() async {
    final poringNotifier = ref.read(poringProvider.notifier);
    final poringState = ref.read(poringProvider);

    if (poringState.balance > 0) {
      // 포링 있으면 차감
      return await poringNotifier.spendPoring();
    } else {
      // 포링 없으면 광고 시청 → 획득+차감
      final adService = AdService.instance;
      final completer = Completer<bool>();

      if (!adService.isRewardedAdReady) {
        await adService.loadRewardedAd(useTestAd: adService.useTestAds);

        for (int i = 0; i < 50; i++) {
          if (adService.isRewardedAdReady) break;
          await Future.delayed(const Duration(milliseconds: 100));
        }

        if (!adService.isRewardedAdReady) {
          return false;
        }
      }

      await adService.showRewardedAd(
        useTestAd: adService.useTestAds,
        onRewarded: () async {
          dev.log('Rewarded ad: user earned reward');
          await poringNotifier.earnPoring();
          await poringNotifier.spendPoring();
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        },
        onAdDismissed: () {
          dev.log('Rewarded ad: dismissed');
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
        onAdFailed: (error) {
          dev.log('Rewarded ad failed: $error');
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      );

      return completer.future;
    }
  }

  /// 윈도우 상태 UI 빌드
  Widget _buildWindowStatus(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final isWithin = _isWithinWindow();
    final isPremium = ref.watch(userProfileProvider).value?.isPremium ?? false;

    if (!isWithin) {
      // 윈도우 밖 - 비활성 상태
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.timer_off, size: 18, color: colorScheme.error),
            const SizedBox(width: Spacing.xs),
            Expanded(
              child: Text(
                l10n.pingWindowClosed,
                style: TextStyle(fontSize: 12, color: colorScheme.error),
              ),
            ),
          ],
        ),
      );
    }

    // 윈도우 내 - 남은 시간 표시
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final timeText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final sentCount = PingWindowService.instance.getPingSentCount();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, size: 18, color: colorScheme.primary),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.pingWindowActive(timeText),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
                if (!isPremium)
                  Text(
                    sentCount == 0
                        ? l10n.pingFreeRemaining
                        : l10n.pingWatchAdForMore,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
          if (isPremium)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.premiumUnlimited,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 메시지 선택 팝업 표시 후 전송
  Future<void> _showMessageDialog(SavedByUser user, PingType type) async {
    // 자기 자신에게는 보내지 않음
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.uid == user.uid) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.cannotSendToSelf)));
      }
      return;
    }

    // 윈도우 내인지 체크
    if (!_isWithinWindow()) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pingWindowClosed)));
      }
      return;
    }

    // 사용자 언어에 맞는 메시지 목록 가져오기 (포링 확인 전에 메시지 선택)
    if (!mounted) return;
    final locale = Localizations.localeOf(context);
    final langCode = locale.languageCode;
    final messages = type == PingType.cheer
        ? PingMessages.getCheerMessages(langCode)
        : PingMessages.getTeaseMessages(langCode);

    if (!mounted) return;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => _MessageSelectionDialog(
        type: type,
        messages: messages,
        recipientName: user.nickname,
        recipientCountry: user.country,
      ),
    );

    if (result == null || !mounted) return;

    // 메시지 선택 후 포링 확인 (무료 유저 추가 전송 시)
    if (_needsAdForMore()) {
      final l10n = AppLocalizations.of(context)!;
      final poringState = ref.read(poringProvider);
      final hasPoringBalance = poringState.balance > 0;

      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.poringCostConfirm),
          content: Text(
            hasPoringBalance
                ? l10n.poringRequiredToSend
                : l10n.poringWatchAdToEarnAndUse,
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(hasPoringBalance ? l10n.ok : l10n.watchAd),
            ),
          ],
        ),
      );

      if (shouldProceed != true) return;

      final success = await _spendPoringForSend();
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.adLoadFailed)));
        }
        return;
      }
    }

    if (mounted) {
      final messageIndex = result['index'] as int;
      final messageText = result['text'] as String;
      await _sendPing(user, type, messageText, messageIndex);
    }
  }

  Future<void> _sendPing(
    SavedByUser user,
    PingType type,
    String message,
    int messageIndex,
  ) async {
    setState(() => _sendingPing.add('${user.uid}_${type.name}'));

    try {
      await FirestoreService.instance.sendPing(
        toUid: user.uid,
        type: type,
        urlTitle: widget.urlTitle,
        customMessage: message,
        messageIndex: messageIndex,
      );

      // 배지 기록 (응원/찌르기)
      if (type == PingType.cheer) {
        await BadgeService.instance.recordCheer();
      } else {
        await BadgeService.instance.recordPoke();
      }

      // 발송 카운트 기록 (무료 사용자 윈도우 내 제한용)
      await PingWindowService.instance.recordPingSent();

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.sendFailed)));
      }
    } finally {
      if (mounted) {
        setState(() => _sendingPing.remove('${user.uid}_${type.name}'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // 받은 고리 + (릴레이면) 내가 뿌린 고리의 참여자 합집합
    final primaryAsync =
        ref.watch(sharedLinkSavedByUsersProvider(widget.sharedLinkId));
    final secondaryId = (widget.outgoingShareId != null &&
            widget.outgoingShareId != widget.sharedLinkId)
        ? widget.outgoingShareId
        : null;
    final secondaryUsers = secondaryId == null
        ? const <SavedByUser>[]
        : (ref.watch(sharedLinkSavedByUsersProvider(secondaryId)).valueOrNull ??
            const <SavedByUser>[]);
    final savedUsersAsync = primaryAsync.whenData((users) {
      final merged = <String, SavedByUser>{for (final u in users) u.uid: u};
      for (final u in secondaryUsers) {
        merged.putIfAbsent(u.uid, () => u);
      }
      return merged.values.toList();
    });
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final myCountry = _getMyCountry();

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
              l10n.savedByTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 윈도우 상태 표시
          _buildWindowStatus(context, l10n, colorScheme),

          const Divider(height: 1),

          // 유저 목록
          Flexible(
            child: savedUsersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(Spacing.xl),
                    child: Text(l10n.noSavedUsers),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isMe = user.uid == currentUid;
                    // 같은 나라가 아닌 경우에만 국기 표시
                    final showCountryFlag =
                        !isMe &&
                        user.country != null &&
                        myCountry != null &&
                        user.country != myCountry;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        child: PixelEmojiService.buildPixelEmoji(
                          user.profileEmoji,
                          size: 24,
                        ),
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.nickname,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // 다른 나라 유저 국기 표시
                          if (showCountryFlag && user.countryFlag != null) ...[
                            const SizedBox(width: Spacing.xs),
                            Text(
                              user.countryFlag!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
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
                                l10n.me,
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
                                  label: l10n.cheer,
                                  color: Colors.pink,
                                  isLoading: _sendingPing.contains(
                                    '${user.uid}_cheer',
                                  ),
                                  onPressed: () =>
                                      _showMessageDialog(user, PingType.cheer),
                                ),
                                const SizedBox(width: Spacing.xs),
                                // 약올리기 버튼
                                _PingButton(
                                  icon: Icons.local_fire_department,
                                  label: l10n.tease,
                                  color: Colors.orange,
                                  isLoading: _sendingPing.contains(
                                    '${user.uid}_tease',
                                  ),
                                  onPressed: () =>
                                      _showMessageDialog(user, PingType.tease),
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
              error: (_, __) => Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Text(l10n.loadFailed),
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
  final String? recipientCountry;

  const _MessageSelectionDialog({
    required this.type,
    required this.messages,
    required this.recipientName,
    this.recipientCountry,
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
          Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
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
                onTap: () =>
                    Navigator.pop(context, {'index': index, 'text': message}),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Text(message, style: theme.textTheme.bodyMedium),
                ),
              ),
            );
          },
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.sm,
        Spacing.md,
        Spacing.md,
      ),
    );
  }
}
