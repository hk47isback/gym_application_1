// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muscle_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MuscleGroupAdapter extends TypeAdapter<MuscleGroup> {
  @override
  final int typeId = 1;

  @override
  MuscleGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MuscleGroup(
      id: fields[0] as String,
      name: fields[1] as String,
      exerciseIds: (fields[2] as List).cast<String>(),
      description: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MuscleGroup obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.exerciseIds)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuscleGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
