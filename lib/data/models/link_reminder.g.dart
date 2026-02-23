// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderTimeAdapter extends TypeAdapter<ReminderTime> {
  @override
  final int typeId = 1;

  @override
  ReminderTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderTime(
      hour: fields[0] as int,
      minute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderTime obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkReminderAdapter extends TypeAdapter<LinkReminder> {
  @override
  final int typeId = 0;

  @override
  LinkReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LinkReminder(
      id: fields[0] as String,
      url: fields[1] as String,
      urlHash: fields[2] as String,
      title: fields[3] as String,
      hour: fields[4] as int,
      minute: fields[5] as int,
      repeatDays: (fields[6] as List).cast<int>(),
      isEnabled: fields[7] as bool,
      createdAt: fields[8] as DateTime?,
      additionalTimes: (fields[9] as List?)?.cast<ReminderTime>(),
      endDate: fields[10] as DateTime?,
      isLocked: fields[11] as bool,
      sharedBy: fields[12] as String?,
      sharedLinkId: fields[13] as String?,
      creatorUid: fields[14] as String?,
      category: fields[15] as LinkCategory?,
      soundId: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LinkReminder obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.urlHash)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.hour)
      ..writeByte(5)
      ..write(obj.minute)
      ..writeByte(6)
      ..write(obj.repeatDays)
      ..writeByte(7)
      ..write(obj.isEnabled)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.additionalTimes)
      ..writeByte(10)
      ..write(obj.endDate)
      ..writeByte(11)
      ..write(obj.isLocked)
      ..writeByte(12)
      ..write(obj.sharedBy)
      ..writeByte(13)
      ..write(obj.sharedLinkId)
      ..writeByte(14)
      ..write(obj.creatorUid)
      ..writeByte(15)
      ..write(obj.category)
      ..writeByte(16)
      ..write(obj.soundId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LinkCategoryAdapter extends TypeAdapter<LinkCategory> {
  @override
  final int typeId = 2;

  @override
  LinkCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LinkCategory.exercise;
      case 1:
        return LinkCategory.study;
      case 2:
        return LinkCategory.contact;
      case 3:
        return LinkCategory.selfDev;
      case 4:
        return LinkCategory.other;
      default:
        return LinkCategory.exercise;
    }
  }

  @override
  void write(BinaryWriter writer, LinkCategory obj) {
    switch (obj) {
      case LinkCategory.exercise:
        writer.writeByte(0);
        break;
      case LinkCategory.study:
        writer.writeByte(1);
        break;
      case LinkCategory.contact:
        writer.writeByte(2);
        break;
      case LinkCategory.selfDev:
        writer.writeByte(3);
        break;
      case LinkCategory.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
