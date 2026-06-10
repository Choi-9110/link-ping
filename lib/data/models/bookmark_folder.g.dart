// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_folder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkFolderAdapter extends TypeAdapter<BookmarkFolder> {
  @override
  final int typeId = 5;

  @override
  BookmarkFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkFolder(
      id: fields[0] as String,
      name: fields[1] as String,
      emoji: fields[2] as String,
      createdAt: fields[3] as DateTime?,
      order: fields[4] as int? ?? 0,
      isDefault: fields[5] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkFolder obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.emoji)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.order)
      ..writeByte(5)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkFolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
