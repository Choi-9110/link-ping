import 'package:hive_flutter/hive_flutter.dart';

/// 사운드 카테고리
enum SoundCategory {
  alarm, // 알람 스타일 (긴 멜로디)
  effect, // 효과음 스타일 (짧은 소리)
}

/// 알람 사운드 정보
class AlarmSound {
  final String id;
  final String nameEn;
  final String nameKo;
  final String fileName; // 확장자 제외
  final bool isPremium;
  final SoundCategory category;
  final bool isAvailable; // 사운드 파일이 실제로 존재하는지
  final String? addedDateStr; // 추가된 날짜 문자열 (NEW 태그용, 형식: 'YYYY-MM-DD')
  final bool isHot; // 인기 소리 (HOT 태그용, 상위 3개)

  const AlarmSound({
    required this.id,
    required this.nameEn,
    required this.nameKo,
    required this.fileName,
    this.isPremium = false,
    this.category = SoundCategory.alarm,
    this.isAvailable = true,
    this.addedDateStr,
    this.isHot = false,
  });

  String getName(String langCode) {
    return langCode == 'ko' ? nameKo : nameEn;
  }

  /// 추가된 날짜 파싱
  DateTime? get addedDate {
    if (addedDateStr == null) return null;
    try {
      return DateTime.parse(addedDateStr!);
    } catch (_) {
      return null;
    }
  }

  /// NEW 태그 표시 여부 (추가된 지 7일 이내)
  bool get isNew {
    final date = addedDate;
    if (date == null) return false;
    final now = DateTime.now();
    final diff = now.difference(date);
    return diff.inDays <= 7;
  }
}

/// 알람 사운드 관리 서비스
class AlarmSoundService {
  static final AlarmSoundService instance = AlarmSoundService._();
  AlarmSoundService._();

  static const _boxName = 'settings';
  static const _selectedSoundKey = 'selectedAlarmSound';

  Box get _box => Hive.box(_boxName);

  /// 사용 가능한 알람 사운드 목록
  static const List<AlarmSound> availableSounds = [
    // ============================================
    // 🔔 알람 스타일 (긴 멜로디, alm_* 파일)
    // ============================================

    // 무료 알람 (5개)
    AlarmSound(
      id: 'alm_relaxing_guitar',
      nameEn: 'Relaxing Guitar',
      nameKo: '편안한 기타',
      fileName: 'alm_relaxing_guitar_loop',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_pangparrr_1',
      nameEn: 'Pangparrr 1',
      nameKo: '팡파르 1',
      fileName: 'alm_pangparrr_1',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_pangparrr_2',
      nameEn: 'Pangparrr 2',
      nameKo: '팡파르 2',
      fileName: 'alm_pangparrr_2',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_faulty_fan',
      nameEn: 'Faulty Fan',
      nameKo: '선풍기',
      fileName: 'alm_faulty_fan',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_k_army',
      nameEn: 'K-Army',
      nameKo: 'K-아미',
      fileName: 'alm_k_army',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),

    // 프리미엄 알람 (6개)
    AlarmSound(
      id: 'alm_pangparrr_3',
      nameEn: 'Pangparrr 3',
      nameKo: '팡파르 3',
      fileName: 'alm_pangparrr_3',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_pangparrr_4',
      nameEn: 'Pangparrr 4',
      nameKo: '팡파르 4',
      fileName: 'alm_pangparrr_4',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_pangparrr_5',
      nameEn: 'Pangparrr 5',
      nameKo: '팡파르 5',
      fileName: 'alm_pangparrr_5',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_hitting_wall',
      nameEn: 'Hitting Wall',
      nameKo: '벽 두드리기',
      fileName: 'alm_hitting_the_wall_with_a_stick',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_breakcore',
      nameEn: 'Breakcore',
      nameKo: '브레이크코어',
      fileName: 'alm_random_breakcore_thingy_i_made',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'alm_looping',
      nameEn: 'Alarm Loop',
      nameKo: '알람 루프',
      fileName: 'alarm_looping_232884',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
    ),

    // 🆕 NEW 알람 (2026-02-03 추가)
    AlarmSound(
      id: 'alm_baroque_bell',
      nameEn: 'Baroque Bell',
      nameKo: '바로크 벨',
      fileName: 'alm_baroque_bell',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'alm_baroque_bell_l',
      nameEn: 'Baroque Bell (Long)',
      nameKo: '바로크 벨 (롱)',
      fileName: 'alm_baroque_bell_l',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'alm_forest_sunrise',
      nameEn: 'Forest Sunrise',
      nameKo: '숲속 일출',
      fileName: 'alm_forest_sunrise',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'alm_fresh_morning',
      nameEn: 'Fresh Morning',
      nameKo: '상쾌한 아침',
      fileName: 'alm_fresh_morning',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'alm_startup',
      nameEn: 'Startup',
      nameKo: '스타트업',
      fileName: 'alm_startup',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'alm_temple_bell',
      nameEn: 'Temple Bell',
      nameKo: '사찰 종소리',
      fileName: 'alm_temple_bell',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'alm_warm_little',
      nameEn: 'Warm Little',
      nameKo: '따뜻한 작은 소리',
      fileName: 'alm_warm_little',
      isPremium: false,
      category: SoundCategory.alarm,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'alm_warm_little_l',
      nameEn: 'Warm Little (Long)',
      nameKo: '따뜻한 작은 소리 (롱)',
      fileName: 'alm_warm_little_l',
      isPremium: true,
      category: SoundCategory.alarm,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),

    // ============================================
    // 🔕 효과음 스타일 (짧은 소리, fxs_* 파일)
    // ============================================

    // 무료 효과음 (10개)
    AlarmSound(
      id: 'fxs_ding',
      nameEn: 'Ding',
      nameKo: '딩',
      fileName: 'fxs_ding',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
      isHot: true, // 🔥 HOT
    ),
    AlarmSound(
      id: 'fxs_bell',
      nameEn: 'Bell',
      nameKo: '벨',
      fileName: 'fxs_bell',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_pop',
      nameEn: 'Pop',
      nameKo: '팝',
      fileName: 'fxs_pop',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_correct',
      nameEn: 'Correct',
      nameKo: '정답',
      fileName: 'fxs_correct',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_chimes',
      nameEn: 'Chimes',
      nameKo: '차임',
      fileName: 'fxs_electric_chimes',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_bubbles',
      nameEn: 'Bubbles',
      nameKo: '버블',
      fileName: 'fxs_bubbles',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_cat_meow',
      nameEn: 'Cat Meow',
      nameKo: '고양이 야옹',
      fileName: 'fxs_cat_meow',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
      isHot: true, // 🔥 HOT
    ),
    AlarmSound(
      id: 'fxs_wow',
      nameEn: 'Wow',
      nameKo: '와우',
      fileName: 'fxs_wow',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_talkak',
      nameEn: 'Talkak',
      nameKo: '딸깍',
      fileName: 'fxs_talkak',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_pop_high',
      nameEn: 'Pop High',
      nameKo: '팝 하이',
      fileName: 'fxs_pop_high',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
    ),

    // 프리미엄 효과음 (21개)
    AlarmSound(
      id: 'fxs_airhorn',
      nameEn: 'Airhorn',
      nameKo: '에어혼',
      fileName: 'fsx_airhorn',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
      isHot: true, // 🔥 HOT
    ),
    AlarmSound(
      id: 'fxs_cinematic',
      nameEn: 'Cinematic Impact',
      nameKo: '시네마틱 임팩트',
      fileName: 'fxs_cinematic_impact',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_fail',
      nameEn: 'Fail',
      nameKo: '실패',
      fileName: 'fxs_fail',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_whistle',
      nameEn: 'Whistle',
      nameKo: '휘파람',
      fileName: 'fxs_loudwhistle',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_boat_horn',
      nameEn: 'Boat Horn',
      nameKo: '배 경적',
      fileName: 'fxs_loud_boat_horn',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_laser',
      nameEn: 'Laser',
      nameKo: '레이저',
      fileName: 'fxs_laser_dubstep_sound',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_magic',
      nameEn: 'Magic Spell',
      nameKo: '마법 주문',
      fileName: 'fxs_elemental_magic_spell_impact_outgoing',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
      addedDateStr: '2026-01-28', // 🆕 NEW (테스트용, 실제 출시일로 변경)
    ),
    AlarmSound(
      id: 'fxs_metal_thud',
      nameEn: 'Metal Thud',
      nameKo: '금속 쿵',
      fileName: 'fxs_metallic_thud',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_hard_impact',
      nameEn: 'Hard Impact',
      nameKo: '강한 충격',
      fileName: 'fxs_hard_metal_impact',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_shotgun',
      nameEn: 'Shotgun',
      nameKo: '샷건',
      fileName: 'fxs_shotgun',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_balloon',
      nameEn: 'Balloon Pop',
      nameKo: '풍선 터짐',
      fileName: 'fxs_bursting_balloon',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_crow',
      nameEn: 'Crow',
      nameKo: '까마귀',
      fileName: 'fxs_crow_sound',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_vinyl',
      nameEn: 'Vinyl Stop',
      nameKo: '바이닐 스탑',
      fileName: 'fxs_vinyl_stop_sound_effect',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_stones',
      nameEn: 'Stones Falling',
      nameKo: '돌 떨어짐',
      fileName: 'fxs_stones_falling',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_stab',
      nameEn: 'Stab',
      nameKo: '스탭',
      fileName: 'fxs_stab_brvhrtz',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_mega_horn',
      nameEn: 'Mega Horn',
      nameKo: '메가 혼',
      fileName: 'fxs_traimory_mega_horn_angry_siren_f_cinematic_trailer_sound_effects',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_ice_break',
      nameEn: 'Ice Break',
      nameKo: '얼음 깨짐',
      fileName: 'fxs_gelo_quebrando',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_bicycle_horn',
      nameEn: 'Bicycle Horn',
      nameKo: '자전거 경적',
      fileName: 'fxs_buzina_de_bicicleta',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_cartoon_fall',
      nameEn: 'Cartoon Fall',
      nameKo: '만화 추락',
      fileName: 'fxs_queda_de_desenho_animado',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_ding_sol',
      nameEn: 'Ding Sol',
      nameKo: '딩 솔',
      fileName: 'fxs_ding_sol',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),
    AlarmSound(
      id: 'fxs_bubbles_pop',
      nameEn: 'Bubbles Pop',
      nameKo: '버블 팝',
      fileName: 'fxs_bolhas_estourando',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
    ),

    // 🆕 NEW 효과음 (2026-02-03 추가)
    AlarmSound(
      id: 'fxs_dreamglass',
      nameEn: 'Dreamglass',
      nameKo: '드림글라스',
      fileName: 'fxs_dreamglass',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'fxs_startup',
      nameEn: 'Startup',
      nameKo: '스타트업',
      fileName: 'fxs_startup',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'fxs_startup_s',
      nameEn: 'Startup (Short)',
      nameKo: '스타트업 (숏)',
      fileName: 'fxs_startup_s',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'fxs_warm_little_ping',
      nameEn: 'Warm Little Ping',
      nameKo: '따뜻한 작은 핑',
      fileName: 'fxs_warm_little_ping',
      isPremium: false,
      category: SoundCategory.effect,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
    AlarmSound(
      id: 'fxs_zen_chime',
      nameEn: 'Zen Chime',
      nameKo: '젠 차임',
      fileName: 'fxs_zen_chime',
      isPremium: true,
      category: SoundCategory.effect,
      isAvailable: true,
      addedDateStr: '2026-02-03',
    ),
  ];

  /// 선택된 사운드 ID 가져오기
  String getSelectedSoundId() {
    return _box.get(_selectedSoundKey, defaultValue: 'fxs_ding') as String;
  }

  /// 사운드 선택 저장
  Future<void> setSelectedSoundId(String soundId) async {
    await _box.put(_selectedSoundKey, soundId);
  }

  /// ID로 사운드 정보 가져오기
  AlarmSound? getSoundById(String id) {
    try {
      return availableSounds.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 모든 알람 스타일 사운드 (긴 멜로디)
  List<AlarmSound> getAlarmSounds() {
    return availableSounds
        .where((s) => s.category == SoundCategory.alarm)
        .toList();
  }

  /// 모든 효과음 스타일 사운드 (짧은 소리)
  List<AlarmSound> getEffectSounds() {
    return availableSounds
        .where((s) => s.category == SoundCategory.effect)
        .toList();
  }

  /// 무료 사운드만
  List<AlarmSound> getFreeSounds() {
    return availableSounds.where((s) => !s.isPremium).toList();
  }

  /// 프리미엄 사운드만
  List<AlarmSound> getPremiumSounds() {
    return availableSounds.where((s) => s.isPremium).toList();
  }

  /// 카테고리별 무료 사운드
  List<AlarmSound> getFreeSoundsByCategory(SoundCategory category) {
    return availableSounds
        .where((s) => s.category == category && !s.isPremium)
        .toList();
  }

  /// 카테고리별 프리미엄 사운드
  List<AlarmSound> getPremiumSoundsByCategory(SoundCategory category) {
    return availableSounds
        .where((s) => s.category == category && s.isPremium)
        .toList();
  }

  /// 사용자가 해당 사운드를 사용할 수 있는지 확인
  bool canUseSound(String soundId, {required bool isPremiumUser}) {
    final sound = getSoundById(soundId);
    if (sound == null) return false;
    if (!sound.isPremium) return true; // 무료 사운드는 누구나
    return isPremiumUser; // 프리미엄 사운드는 프리미엄 유저만
  }

  /// 공유받은 사운드 ID가 사용 가능한지 확인, 불가능하면 기본값 반환
  String getUsableSoundId(String sharedSoundId, {required bool isPremiumUser}) {
    if (canUseSound(sharedSoundId, isPremiumUser: isPremiumUser)) {
      return sharedSoundId;
    }
    return 'fxs_ding'; // 사용 불가능하면 기본 사운드
  }

  /// iOS용 사운드 파일명 (확장자 포함)
  String getIOSSoundFileName(String soundId) {
    final sound = getSoundById(soundId);
    if (sound == null) return 'fxs_ding.caf';
    return '${sound.fileName}.caf';
  }

  /// Android용 사운드 리소스명 (확장자 제외)
  String getAndroidSoundName(String soundId) {
    final sound = getSoundById(soundId);
    if (sound == null) return 'fxs_ding';
    return sound.fileName;
  }
}
