import 'package:hive/hive.dart';

import '../data/models/verification_video.dart';

/// 인증 폴더의 "안 읽음" 상태 저장소 (기기 로컬).
///
/// 폴더(공유 링크)별로 "내가 마지막으로 확인한 시점"을 기록해서,
/// 그 이후에 올라온 (남의) 인증이 있으면 안 읽음 뱃지를 띄운다.
/// 폴더를 열면 [markSeen] 으로 시점을 갱신 → 뱃지 사라짐.
class VerificationSeenService {
  VerificationSeenService._();

  static const _key = 'verification_seen_v1';
  static Box get _box => Hive.box('settings');

  /// 해당 폴더(sharedLinkId)를 마지막으로 확인한 시점. 없으면 null.
  static DateTime? lastSeen(String sharedLinkId) {
    final raw = _box.get(_key);
    if (raw is! Map) return null;
    final s = raw[sharedLinkId];
    return s is String ? DateTime.tryParse(s) : null;
  }

  /// 폴더를 [upTo] 시점까지 확인한 것으로 기록.
  /// (이미 더 최근 시점이 저장돼 있으면 유지)
  static Future<void> markSeen(String sharedLinkId, DateTime upTo) async {
    final raw = _box.get(_key);
    final map =
        raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    final existing = map[sharedLinkId];
    final existingDt = existing is String ? DateTime.tryParse(existing) : null;
    if (existingDt == null || upTo.isAfter(existingDt)) {
      map[sharedLinkId] = upTo.toIso8601String();
      await _box.put(_key, map);
    }
  }

  /// 안 읽은 (남의) 인증이 하나라도 있는지. 내 인증은 제외.
  static bool hasUnseen({
    required String sharedLinkId,
    required List<VerificationVideo> videos,
    required String? myUid,
  }) {
    final seen = lastSeen(sharedLinkId);
    return videos.any((v) =>
        v.uploaderUid != myUid &&
        (seen == null || v.createdAt.isAfter(seen)));
  }

  /// 현재 목록에서 가장 최근 인증 시각 (markSeen 워터마크용). 없으면 null.
  static DateTime? latestCreatedAt(List<VerificationVideo> videos) {
    if (videos.isEmpty) return null;
    return videos
        .map((v) => v.createdAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }
}
