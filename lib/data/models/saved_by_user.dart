/// URL을 저장한 유저 정보
class SavedByUser {
  final String uid;
  final String nickname;
  final String profileEmoji;
  final String? country; // 국가 코드 (예: "KR", "US", "JP")

  SavedByUser({
    required this.uid,
    required this.nickname,
    this.profileEmoji = 'face_grinning',
    this.country,
  });

  factory SavedByUser.fromMap(Map<String, dynamic> map) {
    return SavedByUser(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      profileEmoji: map['profileEmoji'] ?? 'face_grinning',
      country: map['country'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'profileEmoji': profileEmoji,
      if (country != null) 'country': country,
    };
  }

  /// 국가 코드를 국기 이모지로 변환
  /// 예: "US" -> "🇺🇸", "KR" -> "🇰🇷", "JP" -> "🇯🇵"
  String? get countryFlag {
    if (country == null || country!.length != 2) return null;

    final code = country!.toUpperCase();
    final flagOffset = 0x1F1E6 - 0x41; // 'A' = 0x41, Regional Indicator A = 0x1F1E6

    final first = String.fromCharCode(code.codeUnitAt(0) + flagOffset);
    final second = String.fromCharCode(code.codeUnitAt(1) + flagOffset);

    return '$first$second';
  }

  /// 국가 코드를 국가명으로 변환 (주요 국가만)
  String? get countryName {
    if (country == null) return null;

    const countryNames = {
      'KR': '한국',
      'US': 'USA',
      'JP': '日本',
      'CN': '中国',
      'TW': '台灣',
      'GB': 'UK',
      'DE': 'Germany',
      'FR': 'France',
      'ES': 'España',
      'IT': 'Italia',
      'BR': 'Brasil',
      'MX': 'México',
      'CA': 'Canada',
      'AU': 'Australia',
      'IN': 'India',
      'TH': 'ไทย',
      'VN': 'Việt Nam',
      'PH': 'Philippines',
      'ID': 'Indonesia',
      'MY': 'Malaysia',
      'SG': 'Singapore',
    };

    return countryNames[country?.toUpperCase()];
  }
}
