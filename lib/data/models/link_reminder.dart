import 'package:hive/hive.dart';

part 'link_reminder.g.dart';

/// 링크 카테고리
@HiveType(typeId: 2)
enum LinkCategory {
  @HiveField(0)
  exercise, // 🏃 운동

  @HiveField(1)
  study, // 📚 공부/학습

  @HiveField(2)
  contact, // 📞 연락

  @HiveField(3)
  selfDev, // 💪 자기계발

  @HiveField(4)
  other, // ⭐ 기타
}

/// 카테고리 정보 확장
extension LinkCategoryExtension on LinkCategory {
  String get emoji {
    switch (this) {
      case LinkCategory.exercise:
        return '🏃';
      case LinkCategory.study:
        return '📚';
      case LinkCategory.contact:
        return '📞';
      case LinkCategory.selfDev:
        return '💪';
      case LinkCategory.other:
        return '⭐';
    }
  }

  String get labelKo {
    switch (this) {
      case LinkCategory.exercise:
        return '운동';
      case LinkCategory.study:
        return '공부';
      case LinkCategory.contact:
        return '연락';
      case LinkCategory.selfDev:
        return '자기계발';
      case LinkCategory.other:
        return '기타';
    }
  }

  String get labelEn {
    switch (this) {
      case LinkCategory.exercise:
        return 'Exercise';
      case LinkCategory.study:
        return 'Study';
      case LinkCategory.contact:
        return 'Contact';
      case LinkCategory.selfDev:
        return 'Self-dev';
      case LinkCategory.other:
        return 'Other';
    }
  }

  String label(bool isKorean) => isKorean ? labelKo : labelEn;

  String displayName(bool isKorean) => '$emoji ${label(isKorean)}';
}

/// 알림 시간 모델
@HiveType(typeId: 1)
class ReminderTime extends HiveObject {
  @HiveField(0)
  final int hour;

  @HiveField(1)
  final int minute;

  ReminderTime({
    required this.hour,
    required this.minute,
  });

  String get timeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  bool operator ==(Object other) {
    if (other is ReminderTime) {
      return hour == other.hour && minute == other.minute;
    }
    return false;
  }

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
}

/// 링크 리마인더 모델
@HiveType(typeId: 0)
class LinkReminder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String urlHash;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final int hour; // 기본 시간 (하위 호환성)

  @HiveField(5)
  final int minute; // 기본 분 (하위 호환성)

  @HiveField(6)
  final List<int> repeatDays; // 0=일, 1=월, ..., 6=토

  @HiveField(7)
  final bool isEnabled;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final List<ReminderTime>? additionalTimes; // 프리미엄: 추가 알림 시간들

  @HiveField(10)
  final DateTime? endDate; // 종료일 (null이면 무한 반복)

  @HiveField(11)
  final bool isLocked; // 공유받은 링크의 시간 잠금 여부 (true = 시간 수정 불가)

  @HiveField(12)
  final String? sharedBy; // 공유한 사람 닉네임 (공유받은 링크인 경우)

  @HiveField(13)
  final String? sharedLinkId; // 공유 링크 ID (Firestore의 sharedLinks 문서 ID)

  @HiveField(14)
  final String? creatorUid; // 원본 만든 사람 UID (수정/삭제 알림용)

  @HiveField(15)
  final LinkCategory? category; // 카테고리

  @HiveField(16)
  final String? soundId; // 알람 소리 ID (null이면 기본 소리)

  LinkReminder({
    required this.id,
    required this.url,
    required this.urlHash,
    required this.title,
    required this.hour,
    required this.minute,
    required this.repeatDays,
    this.isEnabled = true,
    DateTime? createdAt,
    this.additionalTimes,
    this.endDate,
    this.isLocked = false,
    this.sharedBy,
    this.sharedLinkId,
    this.creatorUid,
    this.category,
    this.soundId,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 모든 알림 시간 목록 (기본 시간 + 추가 시간)
  List<ReminderTime> get allTimes {
    final times = [ReminderTime(hour: hour, minute: minute)];
    if (additionalTimes != null) {
      times.addAll(additionalTimes!);
    }
    // 시간순 정렬
    times.sort((a, b) {
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return times;
  }

  /// 알림 시간 개수
  int get timeCount => 1 + (additionalTimes?.length ?? 0);

  LinkReminder copyWith({
    String? id,
    String? url,
    String? urlHash,
    String? title,
    int? hour,
    int? minute,
    List<int>? repeatDays,
    bool? isEnabled,
    DateTime? createdAt,
    List<ReminderTime>? additionalTimes,
    DateTime? endDate,
    bool clearEndDate = false, // endDate를 null로 설정하려면 true
    bool? isLocked,
    String? sharedBy,
    String? sharedLinkId,
    String? creatorUid,
    LinkCategory? category,
    bool clearCategory = false, // category를 null로 설정하려면 true
    String? soundId,
    bool clearSoundId = false, // soundId를 null로 설정하려면 true
  }) {
    return LinkReminder(
      id: id ?? this.id,
      url: url ?? this.url,
      urlHash: urlHash ?? this.urlHash,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeatDays: repeatDays ?? this.repeatDays,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      additionalTimes: additionalTimes ?? this.additionalTimes,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      isLocked: isLocked ?? this.isLocked,
      sharedBy: sharedBy ?? this.sharedBy,
      sharedLinkId: sharedLinkId ?? this.sharedLinkId,
      creatorUid: creatorUid ?? this.creatorUid,
      category: clearCategory ? null : (category ?? this.category),
      soundId: clearSoundId ? null : (soundId ?? this.soundId),
    );
  }

  /// Firestore 클라우드 백업용 직렬화 (프리미엄 동기화)
  Map<String, dynamic> toMap() => {
        'id': id,
        'url': url,
        'urlHash': urlHash,
        'title': title,
        'hour': hour,
        'minute': minute,
        'repeatDays': repeatDays,
        'isEnabled': isEnabled,
        'createdAt': createdAt.toIso8601String(),
        'additionalTimes': additionalTimes
            ?.map((t) => {'hour': t.hour, 'minute': t.minute})
            .toList(),
        'endDate': endDate?.toIso8601String(),
        'isLocked': isLocked,
        'sharedBy': sharedBy,
        'sharedLinkId': sharedLinkId,
        'creatorUid': creatorUid,
        'category': category?.name,
        'soundId': soundId,
      };

  /// Firestore 백업 데이터 → 모델 복원
  factory LinkReminder.fromMap(Map<String, dynamic> m) {
    return LinkReminder(
      id: m['id'] as String,
      url: m['url'] as String? ?? '',
      urlHash: m['urlHash'] as String? ?? '',
      title: m['title'] as String? ?? '',
      hour: (m['hour'] as num?)?.toInt() ?? 0,
      minute: (m['minute'] as num?)?.toInt() ?? 0,
      repeatDays:
          (m['repeatDays'] as List?)?.map((e) => (e as num).toInt()).toList() ??
              const [],
      isEnabled: m['isEnabled'] as bool? ?? true,
      createdAt: m['createdAt'] != null
          ? DateTime.tryParse(m['createdAt'] as String)
          : null,
      additionalTimes: (m['additionalTimes'] as List?)
          ?.map((e) => ReminderTime(
                hour: (e['hour'] as num).toInt(),
                minute: (e['minute'] as num).toInt(),
              ))
          .toList(),
      endDate:
          m['endDate'] != null ? DateTime.tryParse(m['endDate'] as String) : null,
      isLocked: m['isLocked'] as bool? ?? false,
      sharedBy: m['sharedBy'] as String?,
      sharedLinkId: m['sharedLinkId'] as String?,
      creatorUid: m['creatorUid'] as String?,
      category: _categoryFromName(m['category'] as String?),
      soundId: m['soundId'] as String?,
    );
  }

  static LinkCategory? _categoryFromName(String? name) {
    if (name == null) return null;
    for (final c in LinkCategory.values) {
      if (c.name == name) return c;
    }
    return null;
  }

  /// 종료일이 지났는지 확인
  bool get isExpired {
    if (endDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
    return today.isAfter(end);
  }

  /// D-day 계산 (종료일 기준 D-, 없으면 생성일 기준 D+)
  String get dDayString {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (endDate != null) {
      // 종료일이 있으면 D- 표시
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
      final diff = end.difference(today).inDays;
      if (diff > 0) return 'D-$diff';
      if (diff == 0) return 'D-Day';
      return 'D+${-diff}'; // 종료일 지남
    } else {
      // 종료일이 없으면 D+ 표시
      final created = DateTime(createdAt.year, createdAt.month, createdAt.day);
      final diff = today.difference(created).inDays;
      return 'D+$diff';
    }
  }

  /// D-day 숫자만 (부호 없이)
  int get dDayCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (endDate != null) {
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day);
      return end.difference(today).inDays;
    } else {
      final created = DateTime(createdAt.year, createdAt.month, createdAt.day);
      return today.difference(created).inDays;
    }
  }

  /// 종료일 여부
  bool get hasEndDate => endDate != null;

  /// 시간 문자열 (예: "07:00" 또는 "07:00, 13:00, 21:00")
  String get timeString {
    if (timeCount == 1) {
      final h = hour.toString().padLeft(2, '0');
      final m = minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return allTimes.map((t) => t.timeString).join(', ');
  }

  /// 짧은 시간 문자열 (카드에 표시용: "07:00 외 2개")
  String get shortTimeString => getShortTimeString(true);

  String getShortTimeString(bool isKorean) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    final first = '$h:$m';

    if (timeCount == 1) return first;
    final moreText = isKorean ? '외 ${timeCount - 1}개' : '+${timeCount - 1} more';
    return '$first $moreText';
  }

  /// 반복 요일 문자열 (예: "매일", "평일", "월, 수, 금")
  String get repeatString => getRepeatString(true);

  String getRepeatString(bool isKorean) {
    if (repeatDays.length == 7) return isKorean ? '매일' : 'Daily';
    if (_listEquals(repeatDays.toList()..sort(), [1, 2, 3, 4, 5])) {
      return isKorean ? '평일' : 'Weekdays';
    }
    if (_listEquals(repeatDays.toList()..sort(), [0, 6])) {
      return isKorean ? '주말' : 'Weekends';
    }

    final dayNames = isKorean
        ? ['일', '월', '화', '수', '목', '금', '토']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final sortedDays = repeatDays.toList()..sort();
    return sortedDays.map((d) => dayNames[d]).join(', ');
  }

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
