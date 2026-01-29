/// 공유된 링크 데이터
class SharedLink {
  final String id;
  final String url;
  final String title;
  final int hour;
  final int minute;
  final List<int> repeatDays;
  final String sharedBy; // 공유한 사람 닉네임
  final DateTime createdAt;
  final int viewCount; // 조회수

  const SharedLink({
    required this.id,
    required this.url,
    required this.title,
    required this.hour,
    required this.minute,
    required this.repeatDays,
    required this.sharedBy,
    required this.createdAt,
    this.viewCount = 0,
  });

  /// 시간 문자열 (예: "오전 9:30")
  String get timeString {
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$period $displayHour:$displayMinute';
  }

  /// 반복 요일 문자열
  String get repeatString {
    if (repeatDays.isEmpty) return '알림 없음';
    if (repeatDays.length == 7) return '매일';

    const dayNames = ['월', '화', '수', '목', '금', '토', '일'];
    final days = repeatDays.map((d) => dayNames[d]).join(', ');
    return days;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'title': title,
    'hour': hour,
    'minute': minute,
    'repeatDays': repeatDays,
    'sharedBy': sharedBy,
    'createdAt': createdAt.toIso8601String(),
    'viewCount': viewCount,
  };

  factory SharedLink.fromJson(Map<String, dynamic> json) {
    return SharedLink(
      id: json['id'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      repeatDays: List<int>.from(json['repeatDays'] as List),
      sharedBy: json['sharedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      viewCount: json['viewCount'] as int? ?? 0,
    );
  }
}
