import 'package:hive/hive.dart';

part 'bookmark_folder.g.dart';

/// 북마크 폴더 (사용자 정의)
@HiveType(typeId: 5)
class BookmarkFolder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String emoji;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final int order;

  /// 기본 폴더 여부 (마이그레이션으로 자동 생성된 폴더)
  @HiveField(5)
  final bool isDefault;

  BookmarkFolder({
    required this.id,
    required this.name,
    required this.emoji,
    DateTime? createdAt,
    this.order = 0,
    this.isDefault = false,
  }) : createdAt = createdAt ?? DateTime.now();

  BookmarkFolder copyWith({
    String? id,
    String? name,
    String? emoji,
    DateTime? createdAt,
    int? order,
    bool? isDefault,
  }) {
    return BookmarkFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      order: order ?? this.order,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String displayName() => '$emoji $name';
}
