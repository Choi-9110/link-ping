import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// URL 열기 (스킴 없으면 https:// 붙여서 열기)
  static Future<bool> openUrl(String url) async {
    final normalizedUrl = ensureScheme(url);
    final uri = Uri.parse(normalizedUrl);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// URL에 스킴이 없으면 https:// 붙여주기
  static String ensureScheme(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;

    // 이미 http:// 또는 https://가 있으면 그대로
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    // 없으면 https:// 붙여주기
    return 'https://$trimmed';
  }

  /// URL 유효성 검사 (스킴 없어도 OK)
  static bool isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    try {
      // 스킴 붙여서 파싱 테스트
      final normalized = ensureScheme(url);
      final uri = Uri.parse(normalized);
      // 호스트가 있고, 점(.)이 포함되어야 함 (예: google.com)
      return uri.host.isNotEmpty && uri.host.contains('.');
    } catch (_) {
      return false;
    }
  }
}
