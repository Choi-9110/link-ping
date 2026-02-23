/// 국가별 전화 코드 유틸리티
class PhoneUtils {
  /// 국가 코드 → 전화 국가 코드 매핑
  static const Map<String, String> countryPhoneCodes = {
    'KR': '+82',
    'US': '+1',
    'CA': '+1',
    'JP': '+81',
    'CN': '+86',
    'TW': '+886',
    'HK': '+852',
    'GB': '+44',
    'DE': '+49',
    'FR': '+33',
    'ES': '+34',
    'IT': '+39',
    'BR': '+55',
    'MX': '+52',
    'AU': '+61',
    'NZ': '+64',
    'IN': '+91',
    'TH': '+66',
    'VN': '+84',
    'PH': '+63',
    'ID': '+62',
    'MY': '+60',
    'SG': '+65',
    'RU': '+7',
    'NL': '+31',
    'BE': '+32',
    'SE': '+46',
    'NO': '+47',
    'DK': '+45',
    'FI': '+358',
    'PL': '+48',
    'AT': '+43',
    'CH': '+41',
    'PT': '+351',
    'GR': '+30',
    'TR': '+90',
    'AE': '+971',
    'SA': '+966',
    'IL': '+972',
    'EG': '+20',
    'ZA': '+27',
    'NG': '+234',
    'KE': '+254',
    'AR': '+54',
    'CL': '+56',
    'CO': '+57',
    'PE': '+51',
  };

  /// 국가 코드로 전화 국가 코드 가져오기
  static String getPhoneCode(String? countryCode) {
    if (countryCode == null) return '+1'; // 기본값: 미국
    return countryPhoneCodes[countryCode.toUpperCase()] ?? '+1';
  }

  /// 국가 코드로 힌트 전화번호 가져오기
  static String getPhoneHint(String? countryCode) {
    final code = countryCode?.toUpperCase();
    switch (code) {
      case 'KR':
        return '01012345678';
      case 'US':
      case 'CA':
        return '2025551234';
      case 'JP':
        return '09012345678';
      case 'CN':
        return '13812345678';
      case 'GB':
        return '07911123456';
      case 'DE':
        return '15112345678';
      case 'FR':
        return '0612345678';
      case 'AU':
        return '0412345678';
      default:
        return '1234567890';
    }
  }

  /// 전화번호 정규화 (비교용) - 국가 코드 제거하고 숫자만
  static String normalizePhoneNumber(String phone, {String? countryCode}) {
    var normalized = phone.replaceAll(RegExp(r'[\s\-().]'), '');

    // 국가 코드 제거
    for (final code in countryPhoneCodes.values) {
      if (normalized.startsWith(code)) {
        normalized = normalized.substring(code.length);
        // 한국의 경우 0 붙이기
        if (code == '+82' && !normalized.startsWith('0')) {
          normalized = '0$normalized';
        }
        break;
      }
    }

    // +만 제거된 경우 (예: +8210... → 8210...)
    if (normalized.startsWith('+')) {
      normalized = normalized.substring(1);
    }

    // 숫자만 남기기
    return normalized.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// 두 전화번호가 같은지 비교
  static bool isSamePhoneNumber(String phone1, String phone2) {
    return normalizePhoneNumber(phone1) == normalizePhoneNumber(phone2);
  }

  /// 전화번호 포맷팅 (표시용)
  static String formatPhoneNumber(String phone, {String? countryCode}) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    // 이미 국가 코드가 있으면 그대로
    if (cleaned.startsWith('+')) {
      return cleaned;
    }

    // 국가 코드 붙이기
    final phoneCode = getPhoneCode(countryCode);

    // 한국: 앞의 0 제거
    if (countryCode?.toUpperCase() == 'KR' && cleaned.startsWith('0')) {
      return '$phoneCode${cleaned.substring(1)}';
    }

    return '$phoneCode$cleaned';
  }

  /// tel: URL 생성
  static String createTelUrl(String phone, {String? countryCode}) {
    final formatted = formatPhoneNumber(phone, countryCode: countryCode);
    return 'tel:$formatted';
  }
}
