import 'package:cloud_firestore/cloud_firestore.dart';

/// 사용자 통계 대시보드 모델
/// Firestore: users/{uid}/stats/dashboard
class UserStats {
  // === 카테고리 통계 ===
  final Map<String, int> categoryCount; // {'exercise': 5, 'study': 3, ...}

  // === 시간대별 알람 클릭 통계 (0-23시) ===
  final Map<String, int> hourlyClickCount; // {'4': 10, '7': 25, '22': 8, ...}

  // === 소리 사용 통계 ===
  final Map<String, int> soundUsageCount; // {'fxs_ding': 15, 'fxs_cat_meow': 8, ...}

  // === 요일별 통계 (0=일, 1=월, ..., 6=토) ===
  final Map<String, int> weekdayCount; // {'0': 5, '1': 12, ...}

  // === 총계 ===
  final int totalLinksCreated; // 총 링크 생성 수
  final int totalNotificationsClicked; // 총 알림 클릭 수
  final int totalNotificationsSent; // 총 알림 발송 수

  // === 시간 기록 ===
  final DateTime? lastActiveAt; // 마지막 활동 시간
  final DateTime? updatedAt; // 통계 업데이트 시간

  const UserStats({
    this.categoryCount = const {},
    this.hourlyClickCount = const {},
    this.soundUsageCount = const {},
    this.weekdayCount = const {},
    this.totalLinksCreated = 0,
    this.totalNotificationsClicked = 0,
    this.totalNotificationsSent = 0,
    this.lastActiveAt,
    this.updatedAt,
  });

  /// Firestore에서 생성
  factory UserStats.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) return const UserStats();

    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserStats(
      categoryCount: _toStringIntMap(data['categoryCount']),
      hourlyClickCount: _toStringIntMap(data['hourlyClickCount']),
      soundUsageCount: _toStringIntMap(data['soundUsageCount']),
      weekdayCount: _toStringIntMap(data['weekdayCount']),
      totalLinksCreated: data['totalLinksCreated'] ?? 0,
      totalNotificationsClicked: data['totalNotificationsClicked'] ?? 0,
      totalNotificationsSent: data['totalNotificationsSent'] ?? 0,
      lastActiveAt: (data['lastActiveAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Firestore에 저장할 Map
  Map<String, dynamic> toFirestore() {
    return {
      'categoryCount': categoryCount,
      'hourlyClickCount': hourlyClickCount,
      'soundUsageCount': soundUsageCount,
      'weekdayCount': weekdayCount,
      'totalLinksCreated': totalLinksCreated,
      'totalNotificationsClicked': totalNotificationsClicked,
      'totalNotificationsSent': totalNotificationsSent,
      'lastActiveAt':
          lastActiveAt != null ? Timestamp.fromDate(lastActiveAt!) : null,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Map 타입 안전하게 변환
  static Map<String, int> _toStringIntMap(dynamic data) {
    if (data == null) return {};
    if (data is! Map) return {};
    return Map<String, int>.from(
      data.map((k, v) => MapEntry(k.toString(), (v as num?)?.toInt() ?? 0)),
    );
  }

  // =============================================
  // 📊 통계 분석 메서드들
  // =============================================

  /// 가장 많이 쓰는 카테고리
  String? get topCategory {
    if (categoryCount.isEmpty) return null;
    return categoryCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// 가장 활발한 시간대 (0-23)
  int? get topHour {
    if (hourlyClickCount.isEmpty) return null;
    final entry = hourlyClickCount.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    return int.tryParse(entry.key);
  }

  /// 가장 많이 쓰는 소리
  String? get topSound {
    if (soundUsageCount.isEmpty) return null;
    return soundUsageCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// 가장 활발한 요일 (0=일, 1=월, ..., 6=토)
  int? get topWeekday {
    if (weekdayCount.isEmpty) return null;
    final entry = weekdayCount.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    return int.tryParse(entry.key);
  }

  /// 시간대 유형 (새벽형, 아침형, 낮형, 저녁형, 밤형)
  String getTimeTypeLabel(String langCode) {
    final hour = topHour;
    if (hour == null) return langCode == 'ko' ? '신비로운' : 'Mysterious';

    if (hour >= 4 && hour < 7) {
      return langCode == 'ko' ? '새벽형' : 'Early Bird';
    } else if (hour >= 7 && hour < 12) {
      return langCode == 'ko' ? '아침형' : 'Morning Person';
    } else if (hour >= 12 && hour < 18) {
      return langCode == 'ko' ? '낮형' : 'Daytime Active';
    } else if (hour >= 18 && hour < 22) {
      return langCode == 'ko' ? '저녁형' : 'Evening Person';
    } else {
      return langCode == 'ko' ? '밤형' : 'Night Owl';
    }
  }

  /// 카테고리 레이블
  String getCategoryLabel(String langCode) {
    final cat = topCategory;
    if (cat == null) return langCode == 'ko' ? '다양한 활동' : 'Various Activities';

    final labels = {
      'exercise': langCode == 'ko' ? '운동' : 'Exercise',
      'study': langCode == 'ko' ? '공부' : 'Study',
      'contact': langCode == 'ko' ? '연락' : 'Contact',
      'selfDev': langCode == 'ko' ? '자기계발' : 'Self-dev',
      'other': langCode == 'ko' ? '다양한 활동' : 'Various',
    };
    return labels[cat] ?? (langCode == 'ko' ? '다양한 활동' : 'Various');
  }

  /// 소리 레이블 (AlarmSoundService 참조 필요)
  String getSoundLabel(String langCode) {
    final sound = topSound;
    if (sound == null) return langCode == 'ko' ? '기본 알림' : 'Default';

    // 간단한 매핑 (전체는 AlarmSoundService에서 가져오기)
    if (sound.contains('cat')) return langCode == 'ko' ? '고양이 소리' : 'Cat Sound';
    if (sound.contains('bell')) return langCode == 'ko' ? '벨 소리' : 'Bell Sound';
    if (sound.contains('ding')) return langCode == 'ko' ? '딩 소리' : 'Ding Sound';
    if (sound.contains('nature') || sound.contains('relaxing')) {
      return langCode == 'ko' ? '자연의 소리' : 'Nature Sound';
    }
    return langCode == 'ko' ? '특별한 소리' : 'Special Sound';
  }

  /// 🎯 재미있는 프로필 문구 생성
  /// 예: "새벽 4시에 자연의소리를 들으며 운동을 좋아하는"
  String generateProfileDescription(String langCode) {
    final timeType = getTimeTypeLabel(langCode);
    final category = getCategoryLabel(langCode);
    final sound = getSoundLabel(langCode);
    final hour = topHour;

    if (langCode == 'ko') {
      if (hour != null && totalNotificationsClicked > 10) {
        return '$hour시에 $sound를 들으며 $category을 즐기는 $timeType 인간';
      } else if (totalLinksCreated > 0) {
        return '$category을 즐기는 $timeType 인간';
      }
      return '링꾸를 시작한';
    } else {
      if (hour != null && totalNotificationsClicked > 10) {
        return '$timeType who enjoys $category with $sound at $hour:00';
      } else if (totalLinksCreated > 0) {
        return '$timeType who loves $category';
      }
      return 'New to Linkku';
    }
  }

  /// 복사본 생성
  UserStats copyWith({
    Map<String, int>? categoryCount,
    Map<String, int>? hourlyClickCount,
    Map<String, int>? soundUsageCount,
    Map<String, int>? weekdayCount,
    int? totalLinksCreated,
    int? totalNotificationsClicked,
    int? totalNotificationsSent,
    DateTime? lastActiveAt,
    DateTime? updatedAt,
  }) {
    return UserStats(
      categoryCount: categoryCount ?? this.categoryCount,
      hourlyClickCount: hourlyClickCount ?? this.hourlyClickCount,
      soundUsageCount: soundUsageCount ?? this.soundUsageCount,
      weekdayCount: weekdayCount ?? this.weekdayCount,
      totalLinksCreated: totalLinksCreated ?? this.totalLinksCreated,
      totalNotificationsClicked:
          totalNotificationsClicked ?? this.totalNotificationsClicked,
      totalNotificationsSent:
          totalNotificationsSent ?? this.totalNotificationsSent,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
