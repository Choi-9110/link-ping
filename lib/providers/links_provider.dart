import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  return LinksNotifier(ref.read(linkRepositoryProvider), ref);
});

class LinksNotifier extends StateNotifier<List<LinkReminder>> {
  final LinkRepository _repository;
  final Ref _ref;
  final _uuid = const Uuid();

  LinksNotifier(this._repository, this._ref) : super([]) {
    _loadLinks();
  }

  /// 클라우드 백업 가능 여부 — 프리미엄 + 로그인 회원만 (게스트/무료 제외)
  bool get _canSyncToCloud =>
      _ref.read(isPremiumProvider) &&
      FirebaseAuth.instance.currentUser != null;

  /// 링크 1건 클라우드 백업 (fire-and-forget, 실패 무시)
  void _backupToCloud(LinkReminder link) {
    if (!_canSyncToCloud) return;
    FirestoreService.instance.backupLink(link).catchError((_) {});
  }

  /// 클라우드 백업에서 링크 1건 제거
  void _removeFromCloud(String id) {
    if (!_canSyncToCloud) return;
    FirestoreService.instance.deleteBackupLink(id).catchError((_) {});
  }

  /// 프리미엄 로그인 시 클라우드 ↔ 로컬 양방향 동기화.
  /// - 클라우드에만 있는 링크 → 로컬로 복원(새 기기/재설치)
  /// - 로컬에만 있는 링크 → 클라우드로 백업(첫 구독 시 기존 데이터 보존)
  /// main_shell에서 프리미엄 확인 후 1회 호출.
  Future<void> syncWithCloud() async {
    if (!_canSyncToCloud) return;
    try {
      final cloudLinks = await FirestoreService.instance.fetchBackupLinks();
      final localLinks = _repository.getAllLinks();
      final localIds = localLinks.map((l) => l.id).toSet();

      // 1) 클라우드에만 있는 링크 → 로컬 복원
      for (final link in cloudLinks) {
        if (!localIds.contains(link.id)) {
          await _repository.saveLink(link);
          if (link.isEnabled) {
            await NotificationService.instance.scheduleReminder(link);
          }
        }
      }

      // 2) 로컬 전체를 클라우드에 백업(로컬에만 있던 것 포함, 같은 id는 병합)
      await FirestoreService.instance.backupAllLinks(localLinks);

      _loadLinks();
    } catch (_) {
      // 동기화 실패는 무시 (기존 로컬 데이터 유지)
    }
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
      // 프리미엄: 클라우드 백업 (비활성 상태 반영)
      _backupToCloud(updated);
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
    String? rootShareId, // 공유 체인 뿌리 ID (중복 등록 방지 기준)
    String? shareVisibility, // 'all'=다같이 링 / 'chain'=릴레이 링
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
      rootShareId: rootShareId,
      shareVisibility: shareVisibility,
    );

    await _repository.saveLink(link);

    // 프리미엄: 클라우드 백업
    _backupToCloud(link);

    // 알림 스케줄
    await NotificationService.instance.scheduleReminder(link);

    // 공유 링크 저장 수 증가 + 기록 (sharedLinkId 기반)
    if (sharedLinkId != null) {
      try {
        await FirestoreService.instance.incrementSharedLinkSaveCount(sharedLinkId);
      } catch (_) {
        // Firestore 오류는 무시 (로컬 저장은 성공)
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
        soundId: null, // 커스텀 사운드 제거 (V2에서 재도입 가능)
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

    // 프리미엄: 클라우드 백업
    _backupToCloud(link);

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

    // 프리미엄: 클라우드 백업에서도 제거
    _removeFromCloud(id);

    // 공유 링크 저장 수 감소 (sharedLinkId 기반)
    if (link != null) {
      if (link.sharedLinkId != null) {
        try {
          await FirestoreService.instance.decrementSharedLinkSaveCount(link.sharedLinkId!);
        } catch (_) {
          // Firestore 오류는 무시
        }
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

    // 프리미엄: 클라우드 백업
    _backupToCloud(updated);

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

  /// 더미 데이터 시드 (스크린샷용)
  Future<void> seedDummyData() async {
    final dummyLinks = [
      (title: 'Morning Yoga Routine', url: 'https://youtube.com/yoga-morning', hour: 6, minute: 30, days: [1,2,3,4,5], cat: LinkCategory.exercise),
      (title: 'Daily English Practice', url: 'https://duolingo.com', hour: 8, minute: 0, days: [0,1,2,3,4,5,6], cat: LinkCategory.study),
      (title: 'Read 10 Pages', url: 'https://kindle.amazon.com', hour: 21, minute: 30, days: [0,1,2,3,4,5,6], cat: LinkCategory.study),
      (title: 'Meditation 15min', url: 'https://headspace.com', hour: 22, minute: 0, days: [0,1,2,3,4,5,6], cat: LinkCategory.selfDev),
      (title: 'Check Portfolio', url: 'https://robinhood.com', hour: 9, minute: 0, days: [1,3,5], cat: LinkCategory.other),
      (title: 'Call Mom', url: 'tel:+11234567890', hour: 18, minute: 0, days: [0], cat: LinkCategory.contact),
      (title: 'Weekly Meal Prep', url: 'https://pinterest.com/meal-prep', hour: 10, minute: 0, days: [0], cat: LinkCategory.other),
      (title: 'Side Project Todo', url: 'https://notion.so/my-project', hour: 19, minute: 0, days: [1,3,5], cat: LinkCategory.study),
      (title: 'Stretch & Walk', url: 'https://youtube.com/stretch-walk', hour: 15, minute: 0, days: [1,2,3,4,5], cat: LinkCategory.exercise),
      (title: 'Journal Writing', url: 'https://docs.google.com/journal', hour: 23, minute: 0, days: [0,1,2,3,4,5,6], cat: LinkCategory.selfDev),
    ];

    final saveCounts = [175, 89, 13, 42, 8, 6, 11, 7, 9, 5];

    final dummyUsers = [
      {'uid': 'dummy_01', 'nickname': 'Wandering April Tiger', 'profileEmoji': 'animal_tiger', 'country': 'US'},
      {'uid': 'dummy_02', 'nickname': 'Dreamy June Owl', 'profileEmoji': 'face_love', 'country': 'GB'},
      {'uid': 'dummy_03', 'nickname': 'Silent March Fox', 'profileEmoji': 'animal_fox', 'country': 'JP'},
      {'uid': 'dummy_04', 'nickname': 'Golden Autumn Deer', 'profileEmoji': 'face_starstruck', 'country': 'KR'},
      {'uid': 'dummy_05', 'nickname': 'Crystal Winter Cat', 'profileEmoji': 'animal_cat', 'country': 'DE'},
      {'uid': 'dummy_06', 'nickname': 'Velvet Spring Lily', 'profileEmoji': 'nature_tulip', 'country': 'FR'},
      {'uid': 'dummy_07', 'nickname': 'Sparkling May Firefly', 'profileEmoji': 'face_party', 'country': 'AU'},
      {'uid': 'dummy_08', 'nickname': 'Midnight July Wolf', 'profileEmoji': 'face_cool', 'country': 'CA'},
      {'uid': 'dummy_09', 'nickname': 'Gentle Dawn Rabbit', 'profileEmoji': 'animal_rabbit', 'country': 'BR'},
      {'uid': 'dummy_10', 'nickname': 'Misty October Cloud', 'profileEmoji': 'nature_cherry_blossom', 'country': 'ES'},
      {'uid': 'dummy_11', 'nickname': 'Curious Summer Breeze', 'profileEmoji': 'face_monocle', 'country': 'IT'},
      {'uid': 'dummy_12', 'nickname': 'Floating Snow Cherry', 'profileEmoji': 'animal_penguin', 'country': 'NL'},
    ];

    for (var i = 0; i < dummyLinks.length; i++) {
      final link = dummyLinks[i];
      final id = _uuid.v4();
      final urlHash = _generateUrlHash(link.url);

      // 1. Firestore에 공유 링크 생성
      String? sharedLinkId;
      try {
        sharedLinkId = await FirestoreService.instance.createSharedLink(
          url: link.url,
          title: link.title,
          hour: link.hour,
          minute: link.minute,
          repeatDays: link.days,
          isLocked: false,
          languageCode: 'en',
        );

        // 2. Firestore에 더미 savedBy 데이터 주입
        await FirestoreService.instance.incrementSharedLinkSaveCount(sharedLinkId);

        // 추가 더미 유저들 직접 넣기
        final usersToAdd = dummyUsers.take(saveCounts[i].clamp(0, 12)).toList();
        await FirebaseFirestore.instance
            .collection('sharedLinks')
            .doc(sharedLinkId)
            .update({
          'saveCount': saveCounts[i],
          'savedBy': usersToAdd,
          'savedByUids': usersToAdd.map((u) => u['uid']!).toList(),
        });
      } catch (_) {}

      // 3. 로컬 Hive에 저장
      final reminder = LinkReminder(
        id: id,
        url: link.url,
        urlHash: urlHash,
        title: link.title,
        hour: link.hour,
        minute: link.minute,
        repeatDays: link.days,
        isEnabled: true,
        category: link.cat,
        sharedLinkId: sharedLinkId,
      );

      await _repository.saveLink(reminder);
    }

    _loadLinks();
  }

  /// D+ 날짜를 랜덤하게 변경 (스크린샷용)
  Future<void> randomizeDDays() async {
    final links = _repository.getAllLinks();
    final daysAgoList = [3, 7, 14, 21, 30, 45, 60, 90, 120, 150];

    for (var i = 0; i < links.length; i++) {
      final daysAgo = daysAgoList[i % daysAgoList.length];
      final newCreatedAt = DateTime.now().subtract(Duration(days: daysAgo));
      final updated = links[i].copyWith(createdAt: newCreatedAt);
      await _repository.saveLink(updated);
    }

    _loadLinks();
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
