// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreakAdapter extends TypeAdapter<Streak> {
  @override
  final int typeId = 7;

  @override
  Streak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Streak(
      date: fields[0] as DateTime,
      workedOut: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Streak obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.workedOut);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
