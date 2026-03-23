import 'package:hive/hive.dart';

part 'bookmark.g.dart';

/// 북마크 카테고리
@HiveType(typeId: 4)
enum BookmarkCategory {
  @HiveField(0)
  exercise, // 🏃 운동

  @HiveField(1)
  study, // 📚 공부/학습

  @HiveField(2)
  cooking, // 🍳 요리

  @HiveField(3)
  entertainment, // 🎬 엔터/영상

  @HiveField(4)
  shopping, // 🛍️ 쇼핑

  @HiveField(5)
  news, // 📰 뉴스/아티클

  @HiveField(6)
  selfDev, // 💪 자기계발

  @HiveField(7)
  other, // ⭐ 기타
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

  @HiveField(3)
  final BookmarkCategory category;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? memo;

  Bookmark({
    required this.id,
    required this.url,
    required this.title,
    required this.category,
    DateTime? createdAt,
    this.memo,
  }) : createdAt = createdAt ?? DateTime.now();

  Bookmark copyWith({
    String? id,
    String? url,
    String? title,
    BookmarkCategory? category,
    DateTime? createdAt,
    String? memo,
    bool clearMemo = false,
  }) {
    return Bookmark(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      memo: clearMemo ? null : (memo ?? this.memo),
    );
  }
}
