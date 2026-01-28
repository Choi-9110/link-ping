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
    );
  }

  @override
  void write(BinaryWriter writer, LinkReminder obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.additionalTimes);
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
