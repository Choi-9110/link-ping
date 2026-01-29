import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/badge.dart';

/// 뱃지 및 통계 관리 서비스
class BadgeService {
  static final BadgeService instance = BadgeService._();
  BadgeService._();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// 새로 획득한 뱃지를 저장할 콜백
  Function(List<BadgeType>)? onNewBadges;

  /// 현재 사용자 ID
  String? get _userId => _auth.currentUser?.uid;

  /// 사용자 통계 문서 참조
  DocumentReference<Map<String, dynamic>>? get _statsDoc {
    final uid = _userId;
    if (uid == null) return null;
    return _firestore.collection('userStats').doc(uid);
  }

  /// 사용자 통계 가져오기
  Future<UserStats> getStats() async {
    final doc = _statsDoc;
    if (doc == null) return const UserStats();

    try {
      final snapshot = await doc.get();
      if (!snapshot.exists) return const UserStats();
      return UserStats.fromJson(snapshot.data()!);
    } catch (e) {
      print('통계 로드 실패: $e');
      return const UserStats();
    }
  }

  /// 알림 클릭 기록 (핵심 함수!)
  /// [scheduledTime]: 알림이 스케줄된 시간
  /// [clickTime]: 실제 클릭 시간
  Future<List<BadgeType>> recordClick({
    required DateTime scheduledTime,
    required DateTime clickTime,
  }) async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];

    // 클릭 시간 차이 계산 (초)
    final diffSeconds = clickTime.difference(scheduledTime).inSeconds;
    final isQuick = diffSeconds <= 180; // 3분 이내
    final isSuperQuick = diffSeconds <= 30; // 30초 이내
    final isUltraQuick = diffSeconds <= 5; // 5초 이내 (Quick Draw)

    // 시간대 체크
    final hour = clickTime.hour;
    final isEarlyBird = hour < 7; // 7시 전
    final isMorningGlory = hour >= 5 && hour < 7; // 5~7시
    final isNightOwl = hour >= 23; // 23시 이후
    final isNightShift = hour >= 0 && hour < 5; // 자정~5시

    // 스트릭 계산
    int newStreak = stats.currentStreak;
    bool streakBroken = false;
    final today = DateTime(clickTime.year, clickTime.month, clickTime.day);
    final lastDate = stats.lastClickDate;

    if (lastDate == null) {
      // 첫 클릭
      newStreak = 1;
    } else {
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final diff = today.difference(lastDay).inDays;

      if (diff == 0) {
        // 오늘 이미 클릭함 - 스트릭 유지
      } else if (diff == 1) {
        // 어제 클릭 → 스트릭 증가
        newStreak = stats.currentStreak + 1;
      } else {
        // 하루 이상 놓침 → 스트릭 리셋
        streakBroken = stats.currentStreak > 0;
        newStreak = 1;
      }
    }

    // 새 통계
    final newStats = stats.copyWith(
      currentStreak: newStreak,
      longestStreak:
          newStreak > stats.longestStreak ? newStreak : stats.longestStreak,
      totalClicks: stats.totalClicks + 1,
      quickClicks: isQuick ? stats.quickClicks + 1 : stats.quickClicks,
      superQuickClicks:
          isSuperQuick ? stats.superQuickClicks + 1 : stats.superQuickClicks,
      ultraQuickClicks:
          isUltraQuick ? stats.ultraQuickClicks + 1 : stats.ultraQuickClicks,
      earlyBirdClicks:
          isEarlyBird ? stats.earlyBirdClicks + 1 : stats.earlyBirdClicks,
      morningGloryClicks:
          isMorningGlory ? stats.morningGloryClicks + 1 : stats.morningGloryClicks,
      nightOwlClicks:
          isNightOwl ? stats.nightOwlClicks + 1 : stats.nightOwlClicks,
      nightShiftClicks:
          isNightShift ? stats.nightShiftClicks + 1 : stats.nightShiftClicks,
      hadStreakBroken: stats.hadStreakBroken || streakBroken,
      lastClickDate: clickTime,
    );

    // 뱃지 체크
    newBadges.addAll(_checkBadges(stats, newStats));

    // 새 뱃지 추가
    final updatedBadges = List<UserBadge>.from(newStats.badges);
    for (final badge in newBadges) {
      if (!updatedBadges.any((b) => b.type == badge)) {
        updatedBadges.add(UserBadge(type: badge, earnedAt: clickTime));
      }
    }

    final finalStats = newStats.copyWith(badges: updatedBadges);

    // Firestore 저장
    try {
      await doc.set(finalStats.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('통계 저장 실패: $e');
    }

    // 새 뱃지 콜백
    if (newBadges.isNotEmpty && onNewBadges != null) {
      onNewBadges!(newBadges);
    }

    return newBadges;
  }

  /// 알림 발송 기록 (통계용)
  Future<void> recordNotificationSent() async {
    final doc = _statsDoc;
    if (doc == null) return;

    try {
      await doc.set({
        'totalNotifications': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      print('알림 기록 실패: $e');
    }
  }

  /// 응원 보내기 기록
  Future<List<BadgeType>> recordCheer() async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];
    final newCheerCount = stats.cheersSent + 1;

    // 뱃지 체크
    if (stats.cheersSent == 0) {
      newBadges.add(BadgeType.firstCheer);
    }
    if (newCheerCount >= 50 &&
        !stats.badges.any((b) => b.type == BadgeType.cheerLeader)) {
      newBadges.add(BadgeType.cheerLeader);
    }

    // 업데이트
    final updatedBadges = List<UserBadge>.from(stats.badges);
    for (final badge in newBadges) {
      updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
    }

    try {
      await doc.set({
        'cheersSent': newCheerCount,
        'badges': updatedBadges.map((b) => b.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('응원 기록 실패: $e');
    }

    if (newBadges.isNotEmpty && onNewBadges != null) {
      onNewBadges!(newBadges);
    }

    return newBadges;
  }

  /// 찌르기 보내기 기록
  Future<List<BadgeType>> recordPoke() async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];
    final newPokeCount = stats.pokesSent + 1;

    // 뱃지 체크
    if (stats.pokesSent == 0) {
      newBadges.add(BadgeType.firstPoke);
    }
    if (newPokeCount >= 50 &&
        !stats.badges.any((b) => b.type == BadgeType.poker)) {
      newBadges.add(BadgeType.poker);
    }

    // 업데이트
    final updatedBadges = List<UserBadge>.from(stats.badges);
    for (final badge in newBadges) {
      updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
    }

    try {
      await doc.set({
        'pokesSent': newPokeCount,
        'badges': updatedBadges.map((b) => b.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('찌르기 기록 실패: $e');
    }

    if (newBadges.isNotEmpty && onNewBadges != null) {
      onNewBadges!(newBadges);
    }

    return newBadges;
  }

  /// 링크 등록 기록
  Future<List<BadgeType>> recordLinkAdded(int totalLinks) async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];

    // 뱃지 체크
    if (totalLinks == 1 &&
        !stats.badges.any((b) => b.type == BadgeType.firstLink)) {
      newBadges.add(BadgeType.firstLink);
    }
    if (totalLinks >= 10 &&
        !stats.badges.any((b) => b.type == BadgeType.linkCollector)) {
      newBadges.add(BadgeType.linkCollector);
    }
    if (totalLinks >= 50 &&
        !stats.badges.any((b) => b.type == BadgeType.linkMaster)) {
      newBadges.add(BadgeType.linkMaster);
    }

    if (newBadges.isEmpty) return [];

    // 업데이트
    final updatedBadges = List<UserBadge>.from(stats.badges);
    for (final badge in newBadges) {
      updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
    }

    try {
      await doc.set({
        'badges': updatedBadges.map((b) => b.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('링크 뱃지 기록 실패: $e');
    }

    if (newBadges.isNotEmpty && onNewBadges != null) {
      onNewBadges!(newBadges);
    }

    return newBadges;
  }

  /// 뱃지 조건 체크
  List<BadgeType> _checkBadges(UserStats oldStats, UserStats newStats) {
    final newBadges = <BadgeType>[];
    final existingBadgeTypes = oldStats.badges.map((b) => b.type).toSet();

    // 스트릭 뱃지
    if (newStats.currentStreak >= 3 &&
        !existingBadgeTypes.contains(BadgeType.streak3)) {
      newBadges.add(BadgeType.streak3);
    }
    if (newStats.currentStreak >= 7 &&
        !existingBadgeTypes.contains(BadgeType.streak7)) {
      newBadges.add(BadgeType.streak7);
    }
    if (newStats.currentStreak >= 30 &&
        !existingBadgeTypes.contains(BadgeType.streak30)) {
      newBadges.add(BadgeType.streak30);
    }
    if (newStats.currentStreak >= 100 &&
        !existingBadgeTypes.contains(BadgeType.streak100)) {
      newBadges.add(BadgeType.streak100);
    }
    // Marathon: 365일 연속
    if (newStats.currentStreak >= 365 &&
        !existingBadgeTypes.contains(BadgeType.marathon)) {
      newBadges.add(BadgeType.marathon);
    }
    // Comeback: 스트릭 끊긴 후 다시 7일 달성
    if (newStats.hadStreakBroken &&
        newStats.currentStreak >= 7 &&
        !existingBadgeTypes.contains(BadgeType.comeback)) {
      newBadges.add(BadgeType.comeback);
    }

    // 속도 뱃지
    // Quick Draw: 5초 내 클릭 1회
    if (newStats.ultraQuickClicks >= 1 &&
        !existingBadgeTypes.contains(BadgeType.quickDraw)) {
      newBadges.add(BadgeType.quickDraw);
    }
    if (newStats.superQuickClicks >= 10 &&
        !existingBadgeTypes.contains(BadgeType.speedDemon)) {
      newBadges.add(BadgeType.speedDemon);
    }
    if (newStats.quickClicks >= 50 &&
        !existingBadgeTypes.contains(BadgeType.quickResponse)) {
      newBadges.add(BadgeType.quickResponse);
    }

    // 시간대 뱃지
    // Morning Glory: 5~7시 클릭 5회
    if (newStats.morningGloryClicks >= 5 &&
        !existingBadgeTypes.contains(BadgeType.morningGlory)) {
      newBadges.add(BadgeType.morningGlory);
    }
    if (newStats.earlyBirdClicks >= 10 &&
        !existingBadgeTypes.contains(BadgeType.earlyBird)) {
      newBadges.add(BadgeType.earlyBird);
    }
    if (newStats.nightOwlClicks >= 10 &&
        !existingBadgeTypes.contains(BadgeType.nightOwl)) {
      newBadges.add(BadgeType.nightOwl);
    }
    // Night Shift: 자정~5시 클릭 5회
    if (newStats.nightShiftClicks >= 5 &&
        !existingBadgeTypes.contains(BadgeType.nightShift)) {
      newBadges.add(BadgeType.nightShift);
    }

    // 달성률 뱃지
    // Perfect Week: 7일 연속 + 빠른 응답률 100%
    if (newStats.currentStreak >= 7 &&
        newStats.quickClicks >= 7 &&
        !existingBadgeTypes.contains(BadgeType.perfectWeek)) {
      newBadges.add(BadgeType.perfectWeek);
    }
    // Perfect Month: 30일 연속 + 빠른 응답률 100%
    if (newStats.currentStreak >= 30 &&
        newStats.quickClicks >= 30 &&
        !existingBadgeTypes.contains(BadgeType.perfectMonth)) {
      newBadges.add(BadgeType.perfectMonth);
    }
    // Perfectionist: 달성률 95% 이상 (50회 이상)
    if (newStats.totalClicks >= 50 &&
        newStats.quickClicks >= (newStats.totalClicks * 0.95).ceil() &&
        !existingBadgeTypes.contains(BadgeType.perfectionist)) {
      newBadges.add(BadgeType.perfectionist);
    }

    // 소셜 뱃지
    // Social Butterfly: 응원/찌르기 10회 받기
    final totalReceived = newStats.cheersReceived + newStats.pokesReceived;
    if (totalReceived >= 10 &&
        !existingBadgeTypes.contains(BadgeType.socialButterfly)) {
      newBadges.add(BadgeType.socialButterfly);
    }

    // Badge Collector: 배지 10개 획득
    final currentBadgeCount = newStats.badges.length + newBadges.length;
    if (currentBadgeCount >= 10 &&
        !existingBadgeTypes.contains(BadgeType.badgeCollector)) {
      newBadges.add(BadgeType.badgeCollector);
    }

    return newBadges;
  }

  /// 계정 연동 배지 지급
  Future<List<BadgeType>> recordAccountLinked() async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];

    if (!stats.badges.any((b) => b.type == BadgeType.cloudSynced)) {
      newBadges.add(BadgeType.cloudSynced);
    }

    if (newBadges.isEmpty) return [];

    final updatedBadges = List<UserBadge>.from(stats.badges);
    for (final badge in newBadges) {
      updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
    }

    try {
      await doc.set({
        'badges': updatedBadges.map((b) => b.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('계정 연동 뱃지 기록 실패: $e');
    }

    if (newBadges.isNotEmpty && onNewBadges != null) {
      onNewBadges!(newBadges);
    }

    return newBadges;
  }

  /// 프리미엄 배지 지급
  Future<List<BadgeType>> recordPremiumPurchase() async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];

    if (!stats.badges.any((b) => b.type == BadgeType.premium)) {
      newBadges.add(BadgeType.premium);
    }

    if (newBadges.isEmpty) return [];

    final updatedBadges = List<UserBadge>.from(stats.badges);
    for (final badge in newBadges) {
      updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
    }

    try {
      await doc.set({
        'badges': updatedBadges.map((b) => b.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('프리미엄 뱃지 기록 실패: $e');
    }

    if (newBadges.isNotEmpty && onNewBadges != null) {
      onNewBadges!(newBadges);
    }

    return newBadges;
  }

  /// 파운더 배지 체크 (앱 최초 사용자)
  Future<List<BadgeType>> checkFounderBadge() async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];

    // 2025년 6월 1일 이전 가입자에게 파운더 배지
    final founderDeadline = DateTime(2025, 6, 1);
    final now = DateTime.now();

    if (now.isBefore(founderDeadline) &&
        !stats.badges.any((b) => b.type == BadgeType.founder)) {
      newBadges.add(BadgeType.founder);
    }

    if (newBadges.isEmpty) return [];

    final updatedBadges = List<UserBadge>.from(stats.badges);
    for (final badge in newBadges) {
      updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
    }

    try {
      await doc.set({
        'badges': updatedBadges.map((b) => b.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('파운더 뱃지 기록 실패: $e');
    }

    if (newBadges.isNotEmpty && onNewBadges != null) {
      onNewBadges!(newBadges);
    }

    return newBadges;
  }

  /// 응원/찌르기 받은 기록 (상대방이 보낼 때 호출)
  Future<List<BadgeType>> recordPingReceived({required bool isCheer}) async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];

    final newCheersReceived = isCheer ? stats.cheersReceived + 1 : stats.cheersReceived;
    final newPokesReceived = isCheer ? stats.pokesReceived : stats.pokesReceived + 1;
    final totalReceived = newCheersReceived + newPokesReceived;

    // Social Butterfly 배지 체크
    if (totalReceived >= 10 &&
        !stats.badges.any((b) => b.type == BadgeType.socialButterfly)) {
      newBadges.add(BadgeType.socialButterfly);
    }

    final updatedBadges = List<UserBadge>.from(stats.badges);
    for (final badge in newBadges) {
      updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
    }

    try {
      await doc.set({
        'cheersReceived': newCheersReceived,
        'pokesReceived': newPokesReceived,
        'badges': updatedBadges.map((b) => b.toJson()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('받은 핑 기록 실패: $e');
    }

    if (newBadges.isNotEmpty && onNewBadges != null) {
      onNewBadges!(newBadges);
    }

    return newBadges;
  }

  /// 링크 도메인 기록 (링크 추가 시 호출)
  Future<List<BadgeType>> recordLinkDomain(String url) async {
    final doc = _statsDoc;
    if (doc == null) return [];

    // URL에서 도메인 추출
    String domain;
    try {
      final uri = Uri.parse(url);
      domain = uri.host;
    } catch (_) {
      return [];
    }

    final stats = await getStats();
    final newBadges = <BadgeType>[];

    // 현재 도메인 목록 가져오기
    final snapshot = await doc.get();
    final domains = List<String>.from(snapshot.data()?['domains'] ?? []);

    if (!domains.contains(domain)) {
      domains.add(domain);
      final newUniqueDomains = domains.length;

      // Variety 배지 체크
      if (newUniqueDomains >= 5 &&
          !stats.badges.any((b) => b.type == BadgeType.variety)) {
        newBadges.add(BadgeType.variety);
      }

      final updatedBadges = List<UserBadge>.from(stats.badges);
      for (final badge in newBadges) {
        updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
      }

      try {
        await doc.set({
          'domains': domains,
          'uniqueDomains': newUniqueDomains,
          'badges': updatedBadges.map((b) => b.toJson()).toList(),
        }, SetOptions(merge: true));
      } catch (e) {
        print('도메인 기록 실패: $e');
      }

      if (newBadges.isNotEmpty && onNewBadges != null) {
        onNewBadges!(newBadges);
      }
    }

    return newBadges;
  }

  /// Hot Link 배지 체크 (링크 저장 수 확인)
  Future<List<BadgeType>> checkHotLinkBadge(int saveCount) async {
    final doc = _statsDoc;
    if (doc == null) return [];

    final stats = await getStats();
    final newBadges = <BadgeType>[];

    if (saveCount >= 10 &&
        !stats.badges.any((b) => b.type == BadgeType.hotLink)) {
      newBadges.add(BadgeType.hotLink);

      final updatedBadges = List<UserBadge>.from(stats.badges);
      for (final badge in newBadges) {
        updatedBadges.add(UserBadge(type: badge, earnedAt: DateTime.now()));
      }

      try {
        await doc.set({
          'badges': updatedBadges.map((b) => b.toJson()).toList(),
        }, SetOptions(merge: true));
      } catch (e) {
        print('Hot Link 배지 기록 실패: $e');
      }

      if (newBadges.isNotEmpty && onNewBadges != null) {
        onNewBadges!(newBadges);
      }
    }

    return newBadges;
  }

  /// 모든 뱃지 목록 (획득 여부 포함)
  Future<List<({BadgeType type, UserBadge? earned})>> getAllBadges() async {
    final stats = await getStats();
    final earnedMap = {for (var b in stats.badges) b.type: b};

    return BadgeType.values.map((type) {
      return (type: type, earned: earnedMap[type]);
    }).toList();
  }
}
