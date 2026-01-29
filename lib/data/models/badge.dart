/// 뱃지 타입
enum BadgeType {
  // 스트릭 관련
  streak3('streak_3', '🔥', '3일 연속', '3일 연속 달성'),
  streak7('streak_7', '🔥', '일주일 불꽃', '7일 연속 달성'),
  streak30('streak_30', '🔥', '한 달의 열정', '30일 연속 달성'),
  streak100('streak_100', '💎', '백일의 기적', '100일 연속 달성'),
  marathon('marathon', '🏃', 'Marathon', '365일 연속 달성!'),
  comeback('comeback', '💪', 'Comeback', '스트릭 끊긴 후 다시 7일 달성'),

  // 속도 관련
  quickDraw('quick_draw', '🤠', 'Quick Draw', '알림 5초 내 클릭'),
  speedDemon('speed_demon', '⚡', 'Speed Demon', '알림 후 30초 내 오픈 10회'),
  quickResponse('quick_response', '🚀', '빠른 응답', '알림 후 3분 내 오픈 50회'),

  // 시간대 관련
  morningGlory('morning_glory', '☀️', 'Morning Glory', '오전 5~7시 클릭 5회'),
  earlyBird('early_bird', '🌅', 'Early Bird', '오전 7시 전 링크 오픈 10회'),
  nightOwl('night_owl', '🦉', 'Night Owl', '밤 11시 이후 링크 오픈 10회'),
  nightShift('night_shift', '🌙', 'Night Shift', '자정~5시 사이 클릭 5회'),

  // 달성률 관련
  perfectWeek('perfect_week', '💯', 'Perfect Week', '일주일 100% 달성'),
  perfectMonth('perfect_month', '🏆', 'Perfect Month', '한 달 100% 달성'),
  perfectionist('perfectionist', '🎯', 'Perfectionist', '달성률 95% 이상 (50회 이상)'),

  // 소셜 관련
  firstCheer('first_cheer', '👏', '첫 응원', '첫 응원 보내기'),
  cheerLeader('cheer_leader', '📣', '응원단장', '응원 50회 보내기'),
  firstPoke('first_poke', '👊', '첫 찌르기', '첫 찌르기 보내기'),
  poker('poker', '🃏', '찌르기 마스터', '찌르기 50회 보내기'),
  socialButterfly('social_butterfly', '🦋', 'Social Butterfly', '응원/찌르기 10회 받기'),

  // 링크 관련
  firstLink('first_link', '🔗', '첫 링크', '첫 링크 등록'),
  linkCollector('link_collector', '📚', '링크 수집가', '링크 10개 등록'),
  linkMaster('link_master', '📖', '링크 마스터', '링크 50개 등록'),
  hotLink('hot_link', '🔥', 'Hot Link', '내 링크 10명 이상 저장'),
  variety('variety', '🎨', 'Variety', '5개 이상 다른 도메인 링크'),

  // 특별 뱃지
  founder('founder', '⭐', '파운더', '앱 초기 사용자'),
  premium('premium', '👑', '프리미엄', '프리미엄 구독'),
  badgeCollector('badge_collector', '🗃️', 'Badge Collector', '배지 10개 획득'),
  cloudSynced('cloud_synced', '☁️', 'Cloud Synced', '계정 연동으로 데이터 동기화');

  final String id;
  final String emoji;
  final String name;
  final String description;

  const BadgeType(this.id, this.emoji, this.name, this.description);
}

/// 획득한 뱃지
class UserBadge {
  final BadgeType type;
  final DateTime earnedAt;
  final int? progress; // 현재 진행도 (예: 3/7일)
  final int? target; // 목표 (예: 7일)

  const UserBadge({
    required this.type,
    required this.earnedAt,
    this.progress,
    this.target,
  });

  Map<String, dynamic> toJson() => {
        'typeId': type.id,
        'earnedAt': earnedAt.toIso8601String(),
        if (progress != null) 'progress': progress,
        if (target != null) 'target': target,
      };

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    final typeId = json['typeId'] as String;
    final type = BadgeType.values.firstWhere(
      (t) => t.id == typeId,
      orElse: () => BadgeType.firstLink,
    );

    return UserBadge(
      type: type,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
      progress: json['progress'] as int?,
      target: json['target'] as int?,
    );
  }
}

/// 사용자 통계 (스트릭, 달성률 등)
class UserStats {
  final int currentStreak; // 현재 연속 일수
  final int longestStreak; // 최장 연속 일수
  final int totalClicks; // 총 클릭 수
  final int totalNotifications; // 총 알림 수
  final int quickClicks; // 빠른 클릭 수 (3분 이내)
  final int superQuickClicks; // 초고속 클릭 수 (30초 이내)
  final int ultraQuickClicks; // 번개 클릭 수 (5초 이내)
  final int earlyBirdClicks; // 오전 7시 전 클릭
  final int morningGloryClicks; // 오전 5~7시 클릭
  final int nightOwlClicks; // 밤 11시 이후 클릭
  final int nightShiftClicks; // 자정~5시 클릭
  final int cheersSent; // 보낸 응원 수
  final int pokesSent; // 보낸 찌르기 수
  final int cheersReceived; // 받은 응원 수
  final int pokesReceived; // 받은 찌르기 수
  final int uniqueDomains; // 등록한 고유 도메인 수
  final bool hadStreakBroken; // 스트릭이 끊긴 적 있는지
  final DateTime? lastClickDate; // 마지막 클릭 날짜
  final List<UserBadge> badges; // 획득한 뱃지들

  const UserStats({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalClicks = 0,
    this.totalNotifications = 0,
    this.quickClicks = 0,
    this.superQuickClicks = 0,
    this.ultraQuickClicks = 0,
    this.earlyBirdClicks = 0,
    this.morningGloryClicks = 0,
    this.nightOwlClicks = 0,
    this.nightShiftClicks = 0,
    this.cheersSent = 0,
    this.pokesSent = 0,
    this.cheersReceived = 0,
    this.pokesReceived = 0,
    this.uniqueDomains = 0,
    this.hadStreakBroken = false,
    this.lastClickDate,
    this.badges = const [],
  });

  /// 달성률 (%)
  double get achievementRate {
    if (totalNotifications == 0) return 0;
    return (quickClicks / totalNotifications * 100).clamp(0, 100);
  }

  /// 오늘 완료 여부
  bool get completedToday {
    if (lastClickDate == null) return false;
    final now = DateTime.now();
    return lastClickDate!.year == now.year &&
        lastClickDate!.month == now.month &&
        lastClickDate!.day == now.day;
  }

  UserStats copyWith({
    int? currentStreak,
    int? longestStreak,
    int? totalClicks,
    int? totalNotifications,
    int? quickClicks,
    int? superQuickClicks,
    int? ultraQuickClicks,
    int? earlyBirdClicks,
    int? morningGloryClicks,
    int? nightOwlClicks,
    int? nightShiftClicks,
    int? cheersSent,
    int? pokesSent,
    int? cheersReceived,
    int? pokesReceived,
    int? uniqueDomains,
    bool? hadStreakBroken,
    DateTime? lastClickDate,
    List<UserBadge>? badges,
  }) {
    return UserStats(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalClicks: totalClicks ?? this.totalClicks,
      totalNotifications: totalNotifications ?? this.totalNotifications,
      quickClicks: quickClicks ?? this.quickClicks,
      superQuickClicks: superQuickClicks ?? this.superQuickClicks,
      ultraQuickClicks: ultraQuickClicks ?? this.ultraQuickClicks,
      earlyBirdClicks: earlyBirdClicks ?? this.earlyBirdClicks,
      morningGloryClicks: morningGloryClicks ?? this.morningGloryClicks,
      nightOwlClicks: nightOwlClicks ?? this.nightOwlClicks,
      nightShiftClicks: nightShiftClicks ?? this.nightShiftClicks,
      cheersSent: cheersSent ?? this.cheersSent,
      pokesSent: pokesSent ?? this.pokesSent,
      cheersReceived: cheersReceived ?? this.cheersReceived,
      pokesReceived: pokesReceived ?? this.pokesReceived,
      uniqueDomains: uniqueDomains ?? this.uniqueDomains,
      hadStreakBroken: hadStreakBroken ?? this.hadStreakBroken,
      lastClickDate: lastClickDate ?? this.lastClickDate,
      badges: badges ?? this.badges,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'totalClicks': totalClicks,
        'totalNotifications': totalNotifications,
        'quickClicks': quickClicks,
        'superQuickClicks': superQuickClicks,
        'ultraQuickClicks': ultraQuickClicks,
        'earlyBirdClicks': earlyBirdClicks,
        'morningGloryClicks': morningGloryClicks,
        'nightOwlClicks': nightOwlClicks,
        'nightShiftClicks': nightShiftClicks,
        'cheersSent': cheersSent,
        'pokesSent': pokesSent,
        'cheersReceived': cheersReceived,
        'pokesReceived': pokesReceived,
        'uniqueDomains': uniqueDomains,
        'hadStreakBroken': hadStreakBroken,
        if (lastClickDate != null)
          'lastClickDate': lastClickDate!.toIso8601String(),
        'badges': badges.map((b) => b.toJson()).toList(),
      };

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      totalClicks: json['totalClicks'] as int? ?? 0,
      totalNotifications: json['totalNotifications'] as int? ?? 0,
      quickClicks: json['quickClicks'] as int? ?? 0,
      superQuickClicks: json['superQuickClicks'] as int? ?? 0,
      ultraQuickClicks: json['ultraQuickClicks'] as int? ?? 0,
      earlyBirdClicks: json['earlyBirdClicks'] as int? ?? 0,
      morningGloryClicks: json['morningGloryClicks'] as int? ?? 0,
      nightOwlClicks: json['nightOwlClicks'] as int? ?? 0,
      nightShiftClicks: json['nightShiftClicks'] as int? ?? 0,
      cheersSent: json['cheersSent'] as int? ?? 0,
      pokesSent: json['pokesSent'] as int? ?? 0,
      cheersReceived: json['cheersReceived'] as int? ?? 0,
      pokesReceived: json['pokesReceived'] as int? ?? 0,
      uniqueDomains: json['uniqueDomains'] as int? ?? 0,
      hadStreakBroken: json['hadStreakBroken'] as bool? ?? false,
      lastClickDate: json['lastClickDate'] != null
          ? DateTime.parse(json['lastClickDate'] as String)
          : null,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((b) => UserBadge.fromJson(b as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
