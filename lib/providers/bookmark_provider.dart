import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/models/bookmark.dart';
import '../data/repositories/bookmark_repository.dart';

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository();
});

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<Bookmark>>((ref) {
  return BookmarksNotifier(ref.read(bookmarkRepositoryProvider));
});

class BookmarksNotifier extends StateNotifier<List<Bookmark>> {
  final BookmarkRepository _repository;
  final _uuid = const Uuid();

  BookmarksNotifier(this._repository) : super([]) {
    _loadBookmarks();
  }

  void _loadBookmarks() {
    final bookmarks = _repository.getAllBookmarks();
    bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = bookmarks;
  }

  void refresh() => _loadBookmarks();

  Future<Bookmark> addBookmark({
    required String url,
    required String title,
    required String folderId,
    String? memo,
  }) async {
    final bookmark = Bookmark(
      id: _uuid.v4(),
      url: url,
      title: title,
      folderId: folderId,
      memo: memo,
    );

    await _repository.saveBookmark(bookmark);
    _loadBookmarks();
    return bookmark;
  }

  Future<void> updateBookmark(Bookmark bookmark) async {
    await _repository.saveBookmark(bookmark);
    _loadBookmarks();
  }

  Future<void> deleteBookmark(String id) async {
    await _repository.deleteBookmark(id);
    _loadBookmarks();
  }
}
