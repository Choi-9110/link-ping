import 'package:hive/hive.dart';

part 'link_reminder.g.dart';

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
    );
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
  String get shortTimeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    final first = '$h:$m';

    if (timeCount == 1) return first;
    return '$first 외 ${timeCount - 1}개';
  }

  /// 반복 요일 문자열 (예: "매일", "평일", "월, 수, 금")
  String get repeatString {
    if (repeatDays.length == 7) return '매일';
    if (_listEquals(repeatDays.toList()..sort(), [1, 2, 3, 4, 5])) return '평일';
    if (_listEquals(repeatDays.toList()..sort(), [0, 6])) return '주말';

    const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
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
