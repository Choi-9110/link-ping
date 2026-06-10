import 'package:hive/hive.dart';

/// 알림 탭으로 링크를 연 직후 "인증 영상 찍을래?" 프롬프트를 띄우기 위한
/// pending 상태 저장소. settings box를 사용.
class PendingVerificationService {
  static const _key = 'pending_verification_v1';
  static const Duration _window = Duration(minutes: 60);

  static Box get _box => Hive.box('settings');

  /// 알림 탭 시점에 호출. URL 열기 직후.
  static Future<void> markPending({
    required String url,
    required String title,
    String? sharedLinkId,
  }) async {
    await _box.put(_key, {
      'url': url,
      'title': title,
      if (sharedLinkId != null) 'sharedLinkId': sharedLinkId,
      'openedAt': DateTime.now().toIso8601String(),
    });
  }

  /// 현재 pending 인증 정보를 가져옴. 60분 윈도우 지났으면 null.
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
