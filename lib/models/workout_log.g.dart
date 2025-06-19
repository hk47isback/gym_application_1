// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutLogAdapter extends TypeAdapter<WorkoutLog> {
  @override
  final int typeId = 4;

  @override
  WorkoutLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutLog(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      exercises: (fields[2] as List).cast<WorkoutEntry>(),
      mood: fields[3] as String?,
      notes: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.exercises)
      ..writeByte(3)
      ..write(obj.mood)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutEntryAdapter extends TypeAdapter<WorkoutEntry> {
  @override
  final int typeId = 5;

  @override
  WorkoutEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutEntry(
      exerciseId: fields[0] as String,
      sets: fields[1] as int,
      reps: fields[2] as int,
      weight: fields[3] as double,
      completed: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.sets)
      ..writeByte(2)
      ..write(obj.reps)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
