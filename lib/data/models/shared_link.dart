/// 공유된 링크 데이터
class SharedLink {
  final String id;
  final String url;
  final String title;
  final int hour;
  final int minute;
  final List<int> repeatDays;
  final String sharedBy; // 공유한 사람 닉네임
  final String creatorUid; // 공유한 사람 UID
  final DateTime createdAt;
  final int viewCount; // 조회수
  final bool isLocked; // true = 시간 수정 불가, false = 수정 가능
  final List<String> savedByUids; // 저장한 사람들 UID 목록
  final String? soundId; // 알람 소리 ID
  final String languageCode; // 공유한 사람의 언어 코드 (en, ko, ja, zh, es)

  const SharedLink({
    required this.id,
    required this.url,
    required this.title,
    required this.hour,
    required this.minute,
    required this.repeatDays,
    required this.sharedBy,
    required this.creatorUid,
    required this.createdAt,
    this.viewCount = 0,
    this.isLocked = false,
    this.savedByUids = const [],
    this.soundId,
    this.languageCode = 'en', // 기본값 영어
  });

  /// 공유자의 언어가 한국어인지 확인
  bool get isKorean => languageCode == 'ko';

  /// 시간 문자열 (예: "오전 9:30")
  String get timeString => getTimeString(true);

  String getTimeString(bool isKorean) {
    final period = hour < 12
        ? (isKorean ? '오전' : 'AM')
        : (isKorean ? '오후' : 'PM');
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$period $displayHour:$displayMinute';
  }

  /// 반복 요일 문자열
  String get repeatString => getRepeatString(true);

  String getRepeatString(bool isKorean) {
    if (repeatDays.isEmpty) return isKorean ? '알림 없음' : 'No alarm';
    if (repeatDays.length == 7) return isKorean ? '매일' : 'Daily';

    final dayNames = isKorean
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] // 0-indexed: 월~일
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // Note: This uses 0=Mon, 1=Tue... convention
    final korDayNames = ['월', '화', '수', '목', '금', '토', '일'];
    final names = isKorean ? korDayNames : dayNames;
    final days = repeatDays.map((d) => names[d]).join(', ');
    return days;
  }

  /// 잠금 상태 문자열
  String get lockStatusString => getLockStatusString(true);

  String getLockStatusString(bool isKorean) {
    if (isLocked) {
      return isKorean ? '🔒 시간 고정' : '🔒 Time locked';
    }
    return isKorean ? '🔓 시간 수정 가능' : '🔓 Time editable';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'title': title,
    'hour': hour,
    'minute': minute,
    'repeatDays': repeatDays,
    'sharedBy': sharedBy,
    'creatorUid': creatorUid,
    'createdAt': createdAt.toIso8601String(),
    'viewCount': viewCount,
    'isLocked': isLocked,
    'savedByUids': savedByUids,
    if (soundId != null) 'soundId': soundId,
    'languageCode': languageCode,
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
      creatorUid: json['creatorUid'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      viewCount: json['viewCount'] as int? ?? 0,
      isLocked: json['isLocked'] as bool? ?? false,
      savedByUids: List<String>.from(json['savedByUids'] as List? ?? []),
      soundId: json['soundId'] as String?,
      languageCode: json['languageCode'] as String? ?? 'en',
    );
  }

  SharedLink copyWith({
    int? hour,
    int? minute,
    List<int>? repeatDays,
    List<String>? savedByUids,
    String? soundId,
    String? languageCode,
  }) {
    return SharedLink(
      id: id,
      url: url,
      title: title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeatDays: repeatDays ?? this.repeatDays,
      sharedBy: sharedBy,
      creatorUid: creatorUid,
      createdAt: createdAt,
      viewCount: viewCount,
      isLocked: isLocked,
      savedByUids: savedByUids ?? this.savedByUids,
      soundId: soundId ?? this.soundId,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
