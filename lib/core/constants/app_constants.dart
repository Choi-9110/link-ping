class AppConstants {
  static const int freeLinksLimit = 2; // v1.1: 3 → 2 변경, 공유 보상으로 +1 가능
  static const int maxBonusLinks = 1; // 공유 보상 최대 추가 링크 수
  static const String appName = 'LinkPing';
  static const String publicWebBaseUrl = String.fromEnvironment(
    'PUBLIC_WEB_BASE_URL',
    defaultValue: 'https://linkping.app',
  );

  static String buildShareUrl(String shareId) {
    final base = publicWebBaseUrl.endsWith('/')
        ? publicWebBaseUrl.substring(0, publicWebBaseUrl.length - 1)
        : publicWebBaseUrl;
    return '$base/s/$shareId';
  }
}
