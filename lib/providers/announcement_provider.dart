import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/announcement.dart';
import '../services/firestore_service.dart';

/// 공지사항 목록 Provider
final announcementsProvider =
    FutureProvider<List<Announcement>>((ref) async {
  return FirestoreService.instance.getAnnouncements();
});

/// 읽은 공지 ID 관리 (로컬 Hive 기반)
class ReadAnnouncementsNotifier extends StateNotifier<Set<String>> {
  static const _boxName = 'settings';
  static const _key = 'readAnnouncementIds';

  ReadAnnouncementsNotifier() : super({}) {
    _load();
  }

  void _load() {
    final box = Hive.box(_boxName);
    final List<dynamic> ids = box.get(_key, defaultValue: []);
    state = ids.cast<String>().toSet();
  }

  Future<void> markAsRead(String id) async {
    final box = Hive.box(_boxName);
    final updated = {...state, id};
    await box.put(_key, updated.toList());
    state = updated;
  }

  bool isRead(String id) => state.contains(id);
}

final readAnnouncementsProvider =
    StateNotifierProvider<ReadAnnouncementsNotifier, Set<String>>((ref) {
  return ReadAnnouncementsNotifier();
});

/// 읽지 않은 공지 개수
final unreadAnnouncementCountProvider = Provider<int>((ref) {
  final announcementsAsync = ref.watch(announcementsProvider);
  final readIds = ref.watch(readAnnouncementsProvider);

  return announcementsAsync.whenOrNull<int>(
        data: (announcements) =>
            announcements.where((a) => !readIds.contains(a.id)).length,
      ) ??
      0;
});
