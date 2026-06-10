import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../data/models/bookmark.dart';
import '../data/models/bookmark_folder.dart';
import '../data/repositories/bookmark_folder_repository.dart';

/// 기존 카테고리 enum 기반 북마크 → 폴더 모델로 1회성 마이그레이션.
class BookmarkMigrationService {
  static const String _migrationFlagKey = 'bookmark_folder_migration_done_v1';

  static const _uuid = Uuid();

  /// 마이그레이션 실행. 이미 완료됐으면 no-op.
  /// - 기존 북마크 있음 → 사용된 카테고리만 기본 폴더로 생성하고 folderId 채움
  /// - 기존 북마크 없음 → 신규 사용자, 폴더 자동 생성 안 함 (튜토리얼이 첫 폴더 안내)
  static Future<void> runIfNeeded() async {
    final settings = Hive.box('settings');
    if (settings.get(_migrationFlagKey, defaultValue: false) == true) {
      return;
    }

    final bookmarkBox = Hive.box<Bookmark>('bookmarks');
    final folderBox = Hive.box<BookmarkFolder>(
      BookmarkFolderRepository.boxName,
    );

    if (bookmarkBox.isEmpty) {
      // 신규 사용자: 폴더 생성 없이 플래그만 세팅
      await settings.put(_migrationFlagKey, true);
      return;
    }

    // 기존 북마크에 등장한 카테고리 수집
    final usedCategories = <BookmarkCategory>{};
    for (final b in bookmarkBox.values) {
      if (b.folderId != null) continue; // 이미 마이그레이션된 항목 skip
      if (b.category != null) usedCategories.add(b.category!);
    }

    if (usedCategories.isEmpty) {
      await settings.put(_migrationFlagKey, true);
      return;
    }

    // 카테고리별 폴더 생성 (순서: enum 정의 순)
    final orderedCategories = BookmarkCategory.values
        .where(usedCategories.contains)
        .toList();

    final categoryToFolderId = <BookmarkCategory, String>{};

    for (var i = 0; i < orderedCategories.length; i++) {
      final cat = orderedCategories[i];
      final folder = BookmarkFolder(
        id: _uuid.v4(),
        name: cat.labelKo,
        emoji: cat.emoji,
        order: i,
        isDefault: true,
      );
      await folderBox.put(folder.id, folder);
      categoryToFolderId[cat] = folder.id;
    }

    // 각 북마크에 folderId 부여
    for (final b in bookmarkBox.values.toList()) {
      if (b.folderId != null) continue;
      if (b.category == null) continue;
      final folderId = categoryToFolderId[b.category!];
      if (folderId == null) continue;
      await bookmarkBox.put(b.id, b.copyWith(folderId: folderId));
    }

    await settings.put(_migrationFlagKey, true);
  }
}
