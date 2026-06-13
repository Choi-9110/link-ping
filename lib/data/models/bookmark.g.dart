// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkAdapter extends TypeAdapter<Bookmark> {
  @override
  final int typeId = 3;

  @override
  Bookmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bookmark(
      id: fields[0] as String,
      url: fields[1] as String,
      title: fields[2] as String,
      category: fields[3] as BookmarkCategory?,
      createdAt: fields[4] as DateTime?,
      memo: fields[5] as String?,
      folderId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Bookmark obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.memo)
      ..writeByte(6)
      ..write(obj.folderId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookmarkCategoryAdapter extends TypeAdapter<BookmarkCategory> {
  @override
  final int typeId = 4;

  @override
  BookmarkCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookmarkCategory.exercise;
      case 1:
        return BookmarkCategory.study;
      case 2:
        return BookmarkCategory.cooking;
      case 3:
        return BookmarkCategory.entertainment;
      case 4:
        return BookmarkCategory.shopping;
      case 5:
        return BookmarkCategory.news;
      case 6:
        return BookmarkCategory.selfDev;
      case 7:
        return BookmarkCategory.other;
      default:
        return BookmarkCategory.exercise;
    }
  }

  @override
  void write(BinaryWriter writer, BookmarkCategory obj) {
    switch (obj) {
      case BookmarkCategory.exercise:
        writer.writeByte(0);
        break;
      case BookmarkCategory.study:
        writer.writeByte(1);
        break;
      case BookmarkCategory.cooking:
        writer.writeByte(2);
        break;
      case BookmarkCategory.entertainment:
        writer.writeByte(3);
        break;
      case BookmarkCategory.shopping:
        writer.writeByte(4);
        break;
      case BookmarkCategory.news:
        writer.writeByte(5);
        break;
      case BookmarkCategory.selfDev:
        writer.writeByte(6);
        break;
      case BookmarkCategory.other:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
