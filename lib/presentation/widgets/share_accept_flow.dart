import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/links_provider.dart';
import '../../providers/share_inbox_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/ad_service.dart';
import '../../services/firestore_service.dart';
import '../../services/share_inbox_service.dart';
import 'dialog_actions.dart';
import 'toast_overlay.dart';

/// 공유 알람 수락 흐름 (딥링크 도착 + 대기함 양쪽에서 사용).
///
/// 도착 다이얼로그 → [추가] 시 한도 확인 → 가득이면 "광고 보고 추가" 제안 →
/// 등록 성공 시 대기함에서 제거 / 보류·거절 시 대기함에 보관.
Future<void> promptSaveSharedLink(
  BuildContext context,
  WidgetRef ref,
  String shareId, {
  bool fromInbox = false,
}) async {
  final l10n = AppLocalizations.of(context)!;
  // 시간 포맷(오전/오후 vs AM/PM)만 ko/en 분기 — 모델 헬퍼 제약
  final isKorean = Localizations.localeOf(context).languageCode == 'ko';
  final inbox = ref.read(shareInboxProvider.notifier);

  // 이미 저장한 알람이면 안내만 (+ 대기함 정리)
  final existing = ref.read(linksProvider);
  if (existing
      .any((l) => l.sharedLinkId == shareId || l.outgoingShareId == shareId)) {
    await inbox.remove(shareId);
    if (context.mounted) {
      ToastOverlay.showInfo(context, l10n.shareAlreadySaved);
    }
    return;
  }

  final shared = await FirestoreService.instance.getSharedLink(shareId);
  if (!context.mounted) return;
  if (shared == null) {
    await inbox.remove(shareId);
    if (context.mounted) {
      ToastOverlay.showError(context, l10n.shareNotFound);
    }
    return;
  }

  // 같은 체인(뿌리)에서 파생된 알람이 이미 있으면 중복 등록 방지
  if (existing.any((l) =>
      l.rootShareId == shared.rootShareId ||
      l.sharedLinkId == shared.rootShareId)) {
    await inbox.remove(shareId);
    if (context.mounted) {
      ToastOverlay.showInfo(context, l10n.shareDuplicateAlarm);
    }
    return;
  }

  // 같은 내용(URL+시간)의 알람 중복 방지 (레거시 공유 URL 대비)
  if (existing.any((l) =>
      l.url == shared.url &&
      l.hour == shared.hour &&
      l.minute == shared.minute)) {
    await inbox.remove(shareId);
    if (context.mounted) {
      ToastOverlay.showInfo(context, l10n.shareDuplicateAlarm);
    }
    return;
  }

  final repeatLabel = shared.repeatDays.length == 7
      ? l10n.shareRepeatDaily
      : l10n.shareRepeatWeekly(shared.repeatDays.length);
  final timeText = '${shared.getTimeString(isKorean)} · $repeatLabel';

  // 도착 즉시 대기함에 기록 — "나중에"를 눌러도 잃어버리지 않게
  await inbox.add(PendingShare(
    shareId: shareId,
    rootShareId: shared.rootShareId,
    title: shared.title,
    sharedBy: shared.sharedBy,
    timeText: timeText,
    receivedAt: DateTime.now(),
  ));
  if (!context.mounted) return;

  final accept = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.shareArrivedTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shared.title,
            style: Theme.of(dialogContext)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('⏰ $timeText',
              style: Theme.of(dialogContext).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            l10n.shareArrivedWith(shared.sharedBy),
            style: Theme.of(dialogContext).textTheme.bodySmall?.copyWith(
                  color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      actions: [
        DialogActions(buttons: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.shareLater),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.shareAddToMyAlarms),
          ),
        ]),
      ],
    ),
  );
  if (!context.mounted) return;
  if (accept != true) {
    // 보류 — 대기함에 남아있음을 안내 (대기함에서 다시 연 경우는 생략)
    if (!fromInbox) {
      ToastOverlay.showInfo(context, l10n.shareKeptInInbox);
    }
    return;
  }

  // 한도 확인 — 가득 찼으면 바로 막지 않고 "광고 보고 추가" 제안
  final profile = ref.read(userProfileProvider).value;
  final limit = profile?.totalLinksLimit ?? 2;
  if (limit != -1 && ref.read(linksProvider).length >= limit) {
    final unlocked = await _offerAdToAcceptShare(context, l10n);
    if (!unlocked || !context.mounted) return; // 거절/실패 → 대기함에 유지
  }

  final ok = await ref.read(linksProvider.notifier).addLink(
        url: shared.url,
        title: shared.title,
        hour: shared.hour,
        minute: shared.minute,
        repeatDays: shared.repeatDays,
        isLocked: shared.isLocked,
        sharedBy: shared.sharedBy,
        sharedLinkId: shareId,
        creatorUid: shared.creatorUid,
        rootShareId: shared.rootShareId,
        shareVisibility: shared.visibility,
      );
  if (!context.mounted) return;
  if (ok) {
    await inbox.remove(shareId);
    if (context.mounted) {
      ToastOverlay.showSuccess(context, l10n.shareAddedTogether);
    }
  } else {
    ToastOverlay.showError(context, l10n.shareAddFailed);
  }
}

/// 한도 초과 상태에서 공유 알람 수락 시: 안내 → 보상형 광고 → 추가 허용.
Future<bool> _offerAdToAcceptShare(
    BuildContext context, AppLocalizations l10n) async {
  final watch = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.slotFullTitle),
      content: Text(l10n.slotFullAdBody),
      actions: [
        DialogActions(buttons: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.slotFullLater),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.slotFullWatchAd),
          ),
        ]),
      ],
    ),
  );
  if (watch != true || !context.mounted) return false;

  // 광고 준비 (edit_link 의 시간추가 흐름과 동일 패턴)
  if (!AdService.instance.isRewardedAdReady) {
    await AdService.instance
        .loadRewardedAd(useTestAd: AdService.instance.useTestAds);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!AdService.instance.isRewardedAdReady) {
      if (context.mounted) {
        ToastOverlay.showError(context, l10n.adLoadFailed);
      }
      return false;
    }
  }

  var rewarded = false;
  await AdService.instance.showRewardedAd(
    useTestAd: AdService.instance.useTestAds,
    onRewarded: () => rewarded = true,
    onAdFailed: (_) {},
  );
  if (!rewarded && context.mounted) {
    ToastOverlay.showError(context, l10n.adNotCompleted);
  }
  return rewarded;
}
