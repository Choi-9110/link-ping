import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/models/bookmark.dart';
import '../data/models/bookmark_folder.dart';
import '../data/repositories/bookmark_folder_repository.dart';
import '../data/repositories/bookmark_repository.dart';
import 'bookmark_provider.dart';

final bookmarkFolderRepositoryProvider =
    Provider<BookmarkFolderRepository>((ref) {
  return BookmarkFolderRepository();
});

final bookmarkFoldersProvider =
    StateNotifierProvider<BookmarkFoldersNotifier, List<BookmarkFolder>>((ref) {
  return BookmarkFoldersNotifier(
    ref.read(bookmarkFolderRepositoryProvider),
    ref.read(bookmarkRepositoryProvider),
    ref,
  );
});

class BookmarkFoldersNotifier extends StateNotifier<List<BookmarkFolder>> {
  final BookmarkFolderRepository _folderRepo;
  final BookmarkRepository _bookmarkRepo;
  final Ref _ref;
  final _uuid = const Uuid();

  BookmarkFoldersNotifier(this._folderRepo, this._bookmarkRepo, this._ref)
      : super([]) {
    _load();
  }

  void _load() {
    state = _folderRepo.getAllFolders();
  }

  Future<BookmarkFolder> createFolder({
    required String name,
    required String emoji,
  }) async {
    final folder = BookmarkFolder(
      id: _uuid.v4(),
      name: name,
      emoji: emoji,
      order: state.length,
      isDefault: false,
    );
    await _folderRepo.saveFolder(folder);
    _load();
    return folder;
  }

  Future<void> updateFolder(BookmarkFolder folder) async {
    await _folderRepo.saveFolder(folder);
    _load();
  }

  Future<void> deleteFolder(String id) async {
    await _bookmarkRepo.deleteBookmarksInFolder(id);
    await _folderRepo.deleteFolder(id);
    _load();
    // 폴더 내부 북마크가 사라지므로 북마크 상태도 새로고침
    _ref.read(bookmarksProvider.notifier).refresh();
  }
}

/// 폴더별 북마크 수
final bookmarkCountByFolderProvider =
    Provider.family<int, String>((ref, folderId) {
  final bookmarks = ref.watch(bookmarksProvider);
  return bookmarks.where((b) => b.folderId == folderId).length;
});

/// 폴더별 북마크 목록
final bookmarksByFolderProvider =
    Provider.family<List<Bookmark>, String>((ref, folderId) {
  final bookmarks = ref.watch(bookmarksProvider);
  return bookmarks.where((b) => b.folderId == folderId).toList();
});

/// 단일 폴더 가져오기
final folderByIdProvider =
    Provider.family<BookmarkFolder?, String>((ref, folderId) {
  final folders = ref.watch(bookmarkFoldersProvider);
  try {
    return folders.firstWhere((f) => f.id == folderId);
  } catch (_) {
    return null;
  }
});
