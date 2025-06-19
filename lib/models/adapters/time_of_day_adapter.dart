import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Custom adapter for TimeOfDay since it's not natively supported by Hive
class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final typeId = 100; // High number to avoid conflicts with other types

  @override
  TimeOfDay read(BinaryReader reader) {
    final hour = reader.readInt();
    final minute = reader.readInt();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeInt(obj.hour);
    writer.writeInt(obj.minute);
  }
}
