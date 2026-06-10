import 'package:hive/hive.dart';

import '../models/bookmark_folder.dart';

class BookmarkFolderRepository {
  static const String boxName = 'bookmark_folders';

  Box<BookmarkFolder> get _box => Hive.box<BookmarkFolder>(boxName);

  List<BookmarkFolder> getAllFolders() {
    final folders = _box.values.toList();
    folders.sort((a, b) {
      final orderCompare = a.order.compareTo(b.order);
      if (orderCompare != 0) return orderCompare;
      return a.createdAt.compareTo(b.createdAt);
    });
    return folders;
  }

  BookmarkFolder? getFolder(String id) => _box.get(id);

  Future<void> saveFolder(BookmarkFolder folder) async {
    await _box.put(folder.id, folder);
  }

  Future<void> deleteFolder(String id) async {
    await _box.delete(id);
  }

  bool get isEmpty => _box.isEmpty;
  int get length => _box.length;
}
