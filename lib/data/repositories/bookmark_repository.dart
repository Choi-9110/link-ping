import 'package:hive/hive.dart';
import '../models/bookmark.dart';

class BookmarkRepository {
  Box<Bookmark> get _box => Hive.box<Bookmark>('bookmarks');

  List<Bookmark> getAllBookmarks() {
    return _box.values.toList();
  }

  List<Bookmark> getBookmarksByFolder(String folderId) {
    return _box.values.where((b) => b.folderId == folderId).toList();
  }

  /// DEPRECATED: 폴더 모델 도입 이전 카테고리 기반 조회.
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

  /// 폴더 삭제 시 해당 폴더의 모든 북마크 삭제
  Future<void> deleteBookmarksInFolder(String folderId) async {
    final toDelete = _box.values
        .where((b) => b.folderId == folderId)
        .map((b) => b.id)
        .toList();
    await _box.deleteAll(toDelete);
  }
}
