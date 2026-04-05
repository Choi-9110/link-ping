/// 국가 정보 (드롭다운용)
class CountryInfo {
  final String code; // 'KR', 'US'
  final String phoneCode; // '+82', '+1'
  final String nameEn;
  final String nameKo;

  const CountryInfo({
    required this.code,
    required this.phoneCode,
    required this.nameEn,
    required this.nameKo,
  });

  String name(bool isKorean) => isKorean ? nameKo : nameEn;
  String display(bool isKorean) => '$phoneCode (${name(isKorean)})';
}

/// 국가별 전화 코드 유틸리티
class PhoneUtils {
  /// 전체 국가 리스트 (드롭다운용)
  static const List<CountryInfo> countries = [
    CountryInfo(code: 'US', phoneCode: '+1', nameEn: 'United States', nameKo: '미국'),
    CountryInfo(code: 'KR', phoneCode: '+82', nameEn: '대한민국', nameKo: '대한민국'),
    CountryInfo(code: 'JP', phoneCode: '+81', nameEn: '日本', nameKo: '일본'),
    CountryInfo(code: 'CN', phoneCode: '+86', nameEn: '中国', nameKo: '중국'),
    CountryInfo(code: 'TW', phoneCode: '+886', nameEn: '臺灣', nameKo: '대만'),
    CountryInfo(code: 'HK', phoneCode: '+852', nameEn: '香港', nameKo: '홍콩'),
    CountryInfo(code: 'GB', phoneCode: '+44', nameEn: 'United Kingdom', nameKo: '영국'),
    CountryInfo(code: 'DE', phoneCode: '+49', nameEn: 'Deutschland', nameKo: '독일'),
    CountryInfo(code: 'FR', phoneCode: '+33', nameEn: 'France', nameKo: '프랑스'),
    CountryInfo(code: 'ES', phoneCode: '+34', nameEn: 'España', nameKo: '스페인'),
    CountryInfo(code: 'IT', phoneCode: '+39', nameEn: 'Italia', nameKo: '이탈리아'),
    CountryInfo(code: 'PT', phoneCode: '+351', nameEn: 'Portugal', nameKo: '포르투갈'),
    CountryInfo(code: 'NL', phoneCode: '+31', nameEn: 'Nederland', nameKo: '네덜란드'),
    CountryInfo(code: 'BE', phoneCode: '+32', nameEn: 'België', nameKo: '벨기에'),
    CountryInfo(code: 'AT', phoneCode: '+43', nameEn: 'Österreich', nameKo: '오스트리아'),
    CountryInfo(code: 'CH', phoneCode: '+41', nameEn: 'Schweiz', nameKo: '스위스'),
    CountryInfo(code: 'SE', phoneCode: '+46', nameEn: 'Sverige', nameKo: '스웨덴'),
    CountryInfo(code: 'NO', phoneCode: '+47', nameEn: 'Norge', nameKo: '노르웨이'),
    CountryInfo(code: 'DK', phoneCode: '+45', nameEn: 'Danmark', nameKo: '덴마크'),
    CountryInfo(code: 'FI', phoneCode: '+358', nameEn: 'Suomi', nameKo: '핀란드'),
    CountryInfo(code: 'PL', phoneCode: '+48', nameEn: 'Polska', nameKo: '폴란드'),
    CountryInfo(code: 'GR', phoneCode: '+30', nameEn: 'Ελλάδα', nameKo: '그리스'),
    CountryInfo(code: 'TR', phoneCode: '+90', nameEn: 'Türkiye', nameKo: '터키'),
    CountryInfo(code: 'RU', phoneCode: '+7', nameEn: 'Россия', nameKo: '러시아'),
    CountryInfo(code: 'CA', phoneCode: '+1', nameEn: 'Canada', nameKo: '캐나다'),
    CountryInfo(code: 'MX', phoneCode: '+52', nameEn: 'México', nameKo: '멕시코'),
    CountryInfo(code: 'BR', phoneCode: '+55', nameEn: 'Brasil', nameKo: '브라질'),
    CountryInfo(code: 'AR', phoneCode: '+54', nameEn: 'Argentina', nameKo: '아르헨티나'),
    CountryInfo(code: 'CL', phoneCode: '+56', nameEn: 'Chile', nameKo: '칠레'),
    CountryInfo(code: 'CO', phoneCode: '+57', nameEn: 'Colombia', nameKo: '콜롬비아'),
    CountryInfo(code: 'PE', phoneCode: '+51', nameEn: 'Perú', nameKo: '페루'),
    CountryInfo(code: 'AU', phoneCode: '+61', nameEn: 'Australia', nameKo: '호주'),
    CountryInfo(code: 'NZ', phoneCode: '+64', nameEn: 'New Zealand', nameKo: '뉴질랜드'),
    CountryInfo(code: 'IN', phoneCode: '+91', nameEn: 'भारत', nameKo: '인도'),
    CountryInfo(code: 'TH', phoneCode: '+66', nameEn: 'ประเทศไทย', nameKo: '태국'),
    CountryInfo(code: 'VN', phoneCode: '+84', nameEn: 'Việt Nam', nameKo: '베트남'),
    CountryInfo(code: 'PH', phoneCode: '+63', nameEn: 'Pilipinas', nameKo: '필리핀'),
    CountryInfo(code: 'ID', phoneCode: '+62', nameEn: 'Indonesia', nameKo: '인도네시아'),
    CountryInfo(code: 'MY', phoneCode: '+60', nameEn: 'Malaysia', nameKo: '말레이시아'),
    CountryInfo(code: 'SG', phoneCode: '+65', nameEn: 'Singapore', nameKo: '싱가포르'),
    CountryInfo(code: 'AE', phoneCode: '+971', nameEn: 'الإمارات', nameKo: 'UAE'),
    CountryInfo(code: 'SA', phoneCode: '+966', nameEn: 'السعودية', nameKo: '사우디아라비아'),
    CountryInfo(code: 'IL', phoneCode: '+972', nameEn: 'ישראל', nameKo: '이스라엘'),
    CountryInfo(code: 'EG', phoneCode: '+20', nameEn: 'مصر', nameKo: '이집트'),
    CountryInfo(code: 'ZA', phoneCode: '+27', nameEn: 'South Africa', nameKo: '남아공'),
    CountryInfo(code: 'NG', phoneCode: '+234', nameEn: 'Nigeria', nameKo: '나이지리아'),
    CountryInfo(code: 'KE', phoneCode: '+254', nameEn: 'Kenya', nameKo: '케냐'),
  ];

  /// 국가 코드로 CountryInfo 가져오기
  static CountryInfo getCountryInfo(String? countryCode) {
    if (countryCode == null) return countries.first; // 기본: US
    return countries.firstWhere(
      (c) => c.code == countryCode.toUpperCase(),
      orElse: () => countries.first,
    );
  }

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
