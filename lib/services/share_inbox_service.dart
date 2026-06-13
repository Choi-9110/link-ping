import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// 공유받은 링크 대기함 항목.
/// 딥링크로 도착했지만 아직 수락/거절하지 않은 공유 알람.
class PendingShare {
  final String shareId;
  final String rootShareId; // 체인 중복 방지 기준
  final String title;
  final String sharedBy;
  final String timeText; // 표시용 (예: "오전 7:00 · 매일")
  final DateTime receivedAt;

  const PendingShare({
    required this.shareId,
    required this.rootShareId,
    required this.title,
    required this.sharedBy,
    required this.timeText,
    required this.receivedAt,
  });

  Map<String, dynamic> toJson() => {
        'shareId': shareId,
        'rootShareId': rootShareId,
        'title': title,
        'sharedBy': sharedBy,
        'timeText': timeText,
        'receivedAt': receivedAt.toIso8601String(),
      };

  factory PendingShare.fromJson(Map<String, dynamic> m) => PendingShare(
        shareId: m['shareId'] as String,
        rootShareId: m['rootShareId'] as String? ?? m['shareId'] as String,
        title: m['title'] as String? ?? '',
        sharedBy: m['sharedBy'] as String? ?? '',
        timeText: m['timeText'] as String? ?? '',
        receivedAt: DateTime.tryParse(m['receivedAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

/// 공유받은 링크 대기함 저장소 (settings box 사용 — 로컬 전용).
class ShareInboxService {
  ShareInboxService._();

  static const _key = 'pendingSharedLinks';
  static Box get _box => Hive.box('settings');

  static List<PendingShare> getAll() {
    final raw = _box.get(_key) as String?;
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => PendingShare.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    } catch (_) {
      return [];
    }
  }

  static Future<void> _save(List<PendingShare> items) async {
    await _box.put(_key, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  /// 추가 (같은 체인이면 중복 저장 안 함)
  static Future<void> add(PendingShare share) async {
    final items = getAll();
    if (items.any((e) => e.rootShareId == share.rootShareId)) return;
    items.insert(0, share);
    await _save(items);
  }

  static Future<void> remove(String shareId) async {
    final items = getAll()..removeWhere((e) => e.shareId == shareId);
    await _save(items);
  }
}
