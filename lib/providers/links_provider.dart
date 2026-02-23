import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../data/models/link_reminder.dart';
import '../data/repositories/link_repository.dart';
import '../services/badge_service.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import 'user_provider.dart';

/// Repository Provider
final linkRepositoryProvider = Provider<LinkRepository>((ref) {
  return LinkRepository();
});

/// 링크 목록 Provider
final linksProvider = StateNotifierProvider<LinksNotifier, List<LinkReminder>>((ref) {
  return LinksNotifier(ref.read(linkRepositoryProvider));
});

class LinksNotifier extends StateNotifier<List<LinkReminder>> {
  final LinkRepository _repository;
  final _uuid = const Uuid();

  LinksNotifier(this._repository) : super([]) {
    _loadLinks();
  }

  void _loadLinks() {
    final links = _repository.getAllLinks();
    // 시간순 정렬 (00:00 → 23:59)
    links.sort((a, b) {
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });
    state = links;
    // 종료일이 지난 링크 자동 OFF
    _checkExpiredLinks();
  }

  /// 종료일이 지난 링크를 자동으로 OFF
  Future<void> _checkExpiredLinks() async {
    final expiredLinks = state.where((link) => link.isEnabled && link.isExpired).toList();

    for (final link in expiredLinks) {
      final updated = link.copyWith(isEnabled: false);
      await _repository.saveLink(updated);
      // 알림 취소
      await NotificationService.instance.cancelReminder(link.id);
    }

    if (expiredLinks.isNotEmpty) {
      state = _repository.getAllLinks();
    }
  }

  /// 링크 추가
  Future<bool> addLink({
    required String url,
    required String title,
    required int hour,
    required int minute,
    required List<int> repeatDays,
    List<ReminderTime>? additionalTimes,
    DateTime? endDate,
    bool isLocked = false,
    String? sharedBy,
    String? sharedLinkId, // 공유 링크 ID (공유받은 링크인 경우)
    String? creatorUid, // 원본 만든 사람 UID
    LinkCategory? category, // 카테고리
    String? soundId, // 알람 소리 ID
  }) async {
    final urlHash = _generateUrlHash(url);

    final link = LinkReminder(
      id: _uuid.v4(),
      url: url,
      urlHash: urlHash,
      title: title,
      hour: hour,
      minute: minute,
      repeatDays: repeatDays,
      additionalTimes: additionalTimes,
      endDate: endDate,
      isLocked: isLocked,
      sharedBy: sharedBy,
      sharedLinkId: sharedLinkId,
      creatorUid: creatorUid,
      category: category,
      soundId: soundId,
    );

    await _repository.saveLink(link);

    // 알림 스케줄
    await NotificationService.instance.scheduleReminder(link);

    // Firestore URL 저장 수 증가 (소셜 기능)
    try {
      await FirestoreService.instance.incrementUrlSaveCount(urlHash);
    } catch (_) {
      // Firestore 오류는 무시 (로컬 저장은 성공)
    }

    // 공유 링크 저장 기록 (수정/삭제 알림용)
    if (sharedLinkId != null) {
      try {
        await FirestoreService.instance.recordSharedLinkSave(sharedLinkId);
      } catch (_) {
        // 오류 무시
      }
    }

    // 뱃지 체크 (링크 추가) - 이미 저장된 후이므로 length가 정확함
    try {
      final totalLinks = _repository.getAllLinks().length;
      await BadgeService.instance.recordLinkAdded(totalLinks);
      // 도메인 다양성 체크 (Variety 배지)
      await BadgeService.instance.recordLinkDomain(url);
    } catch (_) {
      // 뱃지 오류는 무시
    }

    // 📊 통계 트래킹 (링크 생성)
    try {
      await FirestoreService.instance.trackLinkCreated(
        category: category?.name,
        soundId: soundId,
        hour: hour,
        weekdays: repeatDays,
      );
    } catch (_) {
      // 통계 오류는 무시
    }

    _loadLinks();
    return true;
  }

  /// 링크 수정
  Future<void> updateLink(LinkReminder link) async {
    await _repository.saveLink(link);

    // 알림 재스케줄
    await NotificationService.instance.scheduleReminder(link);

    _loadLinks();
  }

  /// 링크 삭제
  Future<void> deleteLink(String id) async {
    final link = _repository.getLink(id);

    // 알림 취소
    await NotificationService.instance.cancelReminder(id);

    await _repository.deleteLink(id);

    // Firestore URL 저장 수 감소
    if (link != null) {
      try {
        await FirestoreService.instance.decrementUrlSaveCount(link.urlHash);
      } catch (_) {
        // Firestore 오류는 무시
      }

      // 고정 알람 + 공유한 링크 + 내가 만든 링크 → 공유받은 사람들에게 삭제 알림
      // sharedLinkId가 있으면 공유됨, creatorUid가 null이면 내가 원작자
      if (link.isLocked && link.sharedLinkId != null && link.creatorUid == null) {
        try {
          await FirestoreService.instance.sendLockedLinkDeletedNotification(
            sharedLinkId: link.sharedLinkId!,
            linkTitle: link.title,
          );
        } catch (_) {
          // 알림 전송 실패는 무시
        }
      }
    }

    _loadLinks();
  }

  /// 링크 토글 (활성/비활성) - UI 먼저 업데이트 후 백그라운드 처리
  Future<void> toggleLink(String id) async {
    final link = _repository.getLink(id);
    if (link == null) return;

    final updated = link.copyWith(isEnabled: !link.isEnabled);

    // 1. UI 먼저 즉시 업데이트 (낙관적 업데이트)
    state = state.map((l) => l.id == id ? updated : l).toList();

    // 2. 저장소에 저장
    await _repository.saveLink(updated);

    // 3. 알림 스케줄/취소 (백그라운드)
    if (updated.isEnabled) {
      // 켜기: 알림 스케줄
      NotificationService.instance.scheduleReminder(updated);
    } else {
      // 끄기: 알림 취소
      NotificationService.instance.cancelReminder(id);
    }
  }

  /// URL 해시 생성 (간단 버전)
  String _generateUrlHash(String url) {
    return url.hashCode.toRadixString(16);
  }
}

/// 프리미엄 상태 Provider (게스트: 로컬, 회원: Firestore)
final isPremiumProvider = Provider<bool>((ref) {
  // 회원인 경우 userProfile에서 가져옴
  final userProfile = ref.watch(userProfileProvider).value;
  if (userProfile != null) {
    return userProfile.isPremium;
  }

  // 게스트인 경우 로컬에서 가져옴
  return false; // 기본값 (Hive는 동기적으로 접근해야 해서 여기선 기본값)
});

/// 보너스 링크 수 Provider
final bonusLinksProvider = Provider<int>((ref) {
  final userProfile = ref.watch(userProfileProvider).value;
  return userProfile?.bonusLinks ?? 0;
});

/// 총 링크 한도 (기본 2 + 보너스)
final totalLinksLimitProvider = Provider<int>((ref) {
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return -1; // 무제한
  final bonusLinks = ref.watch(bonusLinksProvider);
  return AppConstants.freeLinksLimit + bonusLinks;
});

/// 링크 추가 가능 여부
final canAddMoreLinksProvider = Provider<bool>((ref) {
  final links = ref.watch(linksProvider);
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return true;
  final totalLimit = ref.watch(totalLinksLimitProvider);
  return links.length < totalLimit;
});

/// 남은 무료 슬롯 개수
final remainingFreeSlotsProvider = Provider<int>((ref) {
  final links = ref.watch(linksProvider);
  final isPremium = ref.watch(isPremiumProvider);
  if (isPremium) return -1; // 무제한
  final totalLimit = ref.watch(totalLinksLimitProvider);
  return totalLimit - links.length;
});
