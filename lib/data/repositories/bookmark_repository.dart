import 'package:hive/hive.dart';
import '../models/bookmark.dart';

class BookmarkRepository {
  Box<Bookmark> get _box => Hive.box<Bookmark>('bookmarks');

  List<Bookmark> getAllBookmarks() {
    return _box.values.toList();
  }

  List<Bookmark> getBookmarksByCategory(BookmarkCategory category) {
    return _box.values.where((b) => b.category == category).toList();
  }

  Bookmark? getBookmark(String id) {
    try {
      return _box.values.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveBookmark(Bookmark bookmark) async {
    await _box.put(bookmark.id, bookmark);
  }

  Future<void> deleteBookmark(String id) async {
    await _box.delete(id);
  }
}
