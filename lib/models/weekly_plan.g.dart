// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyPlanAdapter extends TypeAdapter<WeeklyPlan> {
  @override
  final int typeId = 3;

  @override
  WeeklyPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyPlan(
      dayIndex: fields[0] as int,
      muscleGroupId: fields[1] as String,
      dayName: fields[2] as String,
      muscleGroups: (fields[3] as List).cast<String>(),
      description: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyPlan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dayIndex)
      ..writeByte(1)
      ..write(obj.muscleGroupId)
      ..writeByte(2)
      ..write(obj.dayName)
      ..writeByte(3)
      ..write(obj.muscleGroups)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
