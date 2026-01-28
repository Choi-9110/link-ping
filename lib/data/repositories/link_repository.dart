import 'package:hive/hive.dart';

import '../models/link_reminder.dart';

class LinkRepository {
  static const String _boxName = 'links';

  Box<LinkReminder> get _box => Hive.box<LinkReminder>(_boxName);

  /// 모든 링크 가져오기 (최신순)
  List<LinkReminder> getAllLinks() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 특정 링크 가져오기
  LinkReminder? getLink(String id) {
    try {
      return _box.values.firstWhere((link) => link.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 링크 저장 (추가/수정)
  Future<void> saveLink(LinkReminder link) async {
    await _box.put(link.id, link);
  }

  /// 링크 삭제
  Future<void> deleteLink(String id) async {
    await _box.delete(id);
  }

  /// 링크 개수
  int get linkCount => _box.length;
}
