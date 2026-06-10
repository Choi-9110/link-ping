import 'package:hive/hive.dart';

part 'bookmark.g.dart';

/// 북마크 카테고리 (DEPRECATED - 폴더 모델로 마이그레이션 후 사용 안 함)
/// 기존 사용자 데이터 호환성을 위해 enum과 adapter는 유지.
@HiveType(typeId: 4)
enum BookmarkCategory {
  @HiveField(0)
  exercise,

  @HiveField(1)
  study,

  @HiveField(2)
  cooking,

  @HiveField(3)
  entertainment,

  @HiveField(4)
  shopping,

  @HiveField(5)
  news,

  @HiveField(6)
  selfDev,

  @HiveField(7)
  other,
}

extension BookmarkCategoryExtension on BookmarkCategory {
  String get emoji {
    switch (this) {
      case BookmarkCategory.exercise:
        return '🏃';
      case BookmarkCategory.study:
        return '📚';
      case BookmarkCategory.cooking:
        return '🍳';
      case BookmarkCategory.entertainment:
        return '🎬';
      case BookmarkCategory.shopping:
        return '🛍️';
      case BookmarkCategory.news:
        return '📰';
      case BookmarkCategory.selfDev:
        return '💪';
      case BookmarkCategory.other:
        return '⭐';
    }
  }

  String get labelKo {
    switch (this) {
      case BookmarkCategory.exercise:
        return '운동';
      case BookmarkCategory.study:
        return '공부';
      case BookmarkCategory.cooking:
        return '요리';
      case BookmarkCategory.entertainment:
        return '엔터/영상';
      case BookmarkCategory.shopping:
        return '쇼핑';
      case BookmarkCategory.news:
        return '뉴스/아티클';
      case BookmarkCategory.selfDev:
        return '자기계발';
      case BookmarkCategory.other:
        return '기타';
    }
  }

  String get labelEn {
    switch (this) {
      case BookmarkCategory.exercise:
        return 'Exercise';
      case BookmarkCategory.study:
        return 'Study';
      case BookmarkCategory.cooking:
        return 'Cooking';
      case BookmarkCategory.entertainment:
        return 'Entertainment';
      case BookmarkCategory.shopping:
        return 'Shopping';
      case BookmarkCategory.news:
        return 'News/Articles';
      case BookmarkCategory.selfDev:
        return 'Self-dev';
      case BookmarkCategory.other:
        return 'Other';
    }
  }

  String label(bool isKorean) => isKorean ? labelKo : labelEn;
  String displayName(bool isKorean) => '$emoji ${label(isKorean)}';
}

/// 북마크 모델
@HiveType(typeId: 3)
class Bookmark extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String title;

  /// DEPRECATED: 폴더 모델 도입 이전 카테고리. 새 코드는 folderId를 사용.
  @HiveField(3)
  final BookmarkCategory? category;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? memo;

  /// 소속 폴더 ID (BookmarkFolder.id 참조)
  @HiveField(6)
  final String? folderId;

  Bookmark({
    required this.id,
    required this.url,
    required this.title,
    this.category,
    DateTime? createdAt,
    this.memo,
    this.folderId,
  }) : createdAt = createdAt ?? DateTime.now();

  Bookmark copyWith({
    String? id,
    String? url,
    String? title,
    BookmarkCategory? category,
    DateTime? createdAt,
    String? memo,
    String? folderId,
    bool clearMemo = false,
  }) {
    return Bookmark(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      memo: clearMemo ? null : (memo ?? this.memo),
      folderId: folderId ?? this.folderId,
    );
  }
}
