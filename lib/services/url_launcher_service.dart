import 'package:url_launcher/url_launcher.dart';

import '../core/utils/phone_utils.dart';

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
  /// 전화번호 형식이면 tel: 스킴 자동 추가
  static String ensureScheme(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;

    // tel: 스킴 (전화번호)
    if (trimmed.startsWith('tel:')) {
      return trimmed;
    }

    // 이미 http:// 또는 https://가 있으면 그대로
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    // 전화번호 패턴인지 확인 (숫자, +, - 만 있으면 전화번호로 간주)
    if (_looksLikePhoneNumber(trimmed)) {
      return 'tel:$trimmed';
    }

    // 없으면 https:// 붙여주기
    return 'https://$trimmed';
  }

  /// 전화번호처럼 보이는지 확인 (tel: 없이 입력된 경우)
  static bool _looksLikePhoneNumber(String input) {
    // 숫자, +, -, (), 공백만 허용
    final cleaned = input.replaceAll(RegExp(r'[\s\-()]+'), '');
    if (cleaned.isEmpty) return false;

    // + 시작 가능, 나머지는 숫자만
    final pattern = RegExp(r'^\+?[0-9]{8,15}$');
    return pattern.hasMatch(cleaned);
  }

  /// URL 유효성 검사 (스킴 없어도 OK, tel: 지원, 전화번호 자동 감지)
  static bool isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;

    final trimmed = url.trim();

    // tel: 스킴 검사 (전화번호)
    if (trimmed.startsWith('tel:')) {
      final phoneNumber = trimmed.substring(4); // 'tel:' 제거
      return isValidPhoneNumber(phoneNumber);
    }

    // 전화번호처럼 보이면 유효
    if (_looksLikePhoneNumber(trimmed)) {
      return true;
    }

    try {
      // 스킴 붙여서 파싱 테스트
      final normalized = ensureScheme(trimmed);
      final uri = Uri.parse(normalized);
      // 호스트가 있고, 점(.)이 포함되어야 함 (예: google.com)
      return uri.host.isNotEmpty && uri.host.contains('.');
    } catch (_) {
      return false;
    }
  }

  /// 전화번호 유효성 검사
  static bool isValidPhoneNumber(String phoneNumber) {
    // 숫자, +, - 만 허용, 최소 8자리
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');
    if (cleaned.isEmpty) return false;

    // + 시작 허용, 나머지는 숫자만
    final pattern = RegExp(r'^\+?[0-9]{8,15}$');
    return pattern.hasMatch(cleaned);
  }

  /// tel: URL인지 확인
  static bool isPhoneUrl(String url) {
    return url.trim().startsWith('tel:');
  }

  /// 전화번호에서 표시용 번호 추출
  static String getDisplayPhoneNumber(String url) {
    if (!isPhoneUrl(url)) return url;
    return url.substring(4); // 'tel:' 제거
  }

  /// 전화번호 정규화 (비교용)
  /// 국가 코드 제거하고 숫자만 추출
  static String normalizePhoneNumber(String phone) {
    return PhoneUtils.normalizePhoneNumber(phone);
  }

  /// 두 전화번호가 같은지 비교
  static bool isSamePhoneNumber(String phone1, String phone2) {
    return PhoneUtils.isSamePhoneNumber(phone1, phone2);
  }

  /// tel: URL에서 전화번호 추출 후 내 번호인지 확인
  static bool isMyPhoneNumber(String telUrl, String? myPhoneNumber) {
    if (myPhoneNumber == null || myPhoneNumber.isEmpty) return false;
    if (!isPhoneUrl(telUrl)) return false;

    final urlPhone = getDisplayPhoneNumber(telUrl);
    return isSamePhoneNumber(urlPhone, myPhoneNumber);
  }
}
