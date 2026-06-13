import 'package:hive/hive.dart';

/// 알림 탭으로 링크를 연 직후 "인증 영상 찍을래?" 프롬프트를 띄우기 위한
/// pending 상태 저장소. settings box를 사용.
class PendingVerificationService {
  static const _key = 'pending_verification_v1';
  // 링크별 "인증 가능" 윈도우 시작 시각 저장소 (프롬프트 소진과 무관하게 유지).
  static const _verifyWindowKey = 'verify_window_v1';
  // 인증은 알람 직후 짧은 시간 안에만 유효해야 의미가 있음 (실시간성).
  static const Duration _window = Duration(minutes: 10);

  /// 인증 가능 윈도우 길이 (UI 안내 문구에서 분 단위로 사용).
  static Duration get window => _window;

  static Box get _box => Hive.box('settings');

  /// 알림 탭 시점에 호출. URL 열기 직후.
  static Future<void> markPending({
    required String url,
    required String title,
    String? sharedLinkId,
  }) async {
    final now = DateTime.now();
    await _box.put(_key, {
      'url': url,
      'title': title,
      if (sharedLinkId != null) 'sharedLinkId': sharedLinkId,
      'openedAt': now.toIso8601String(),
    });

    // 갤러리의 "나도 인증하기" 게이팅용 — 이 링크는 지금부터 윈도우 동안 인증 가능.
    // 프롬프트를 "다음에"로 닫거나 인증을 마쳐도 윈도우는 유지된다(재인증 허용).
    if (sharedLinkId != null) {
      final raw = _box.get(_verifyWindowKey);
      final map =
          raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
      map[sharedLinkId] = now.toIso8601String();
      await _box.put(_verifyWindowKey, map);
    }
  }

  /// 해당 링크가 지금 인증 가능한 상태인지(알람 열고 윈도우 이내인지).
  static bool canVerifyNow(String sharedLinkId) {
    final raw = _box.get(_verifyWindowKey);
    if (raw is! Map) return false;
    final s = raw[sharedLinkId];
    final openedAt = s is String ? DateTime.tryParse(s) : null;
    if (openedAt == null) return false;
    return DateTime.now().difference(openedAt) <= _window;
  }

  /// 현재 pending 인증 정보를 가져옴. 윈도우 지났으면 null.
  static PendingVerification? read() {
    final raw = _box.get(_key);
    if (raw is! Map) return null;
    final openedAtStr = raw['openedAt'] as String?;
    if (openedAtStr == null) return null;
    final openedAt = DateTime.tryParse(openedAtStr);
    if (openedAt == null) return null;
    if (DateTime.now().difference(openedAt) > _window) {
      // 윈도우 초과 → 자동 만료
      clear();
      return null;
    }
    return PendingVerification(
      url: raw['url'] as String? ?? '',
      title: raw['title'] as String? ?? '',
      sharedLinkId: raw['sharedLinkId'] as String?,
      openedAt: openedAt,
    );
  }

  static Future<void> clear() async {
    await _box.delete(_key);
  }
}

class PendingVerification {
  final String url;
  final String title;
  final String? sharedLinkId;
  final DateTime openedAt;

  PendingVerification({
    required this.url,
    required this.title,
    this.sharedLinkId,
    required this.openedAt,
  });
}
