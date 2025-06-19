import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 6)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool darkMode;

  @HiveField(1)
  bool notificationsEnabled;

  @HiveField(2)
  bool useMetric;

  @HiveField(3)
  TimeOfDay? reminderTime;

  AppSettings({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.useMetric = true,
    this.reminderTime,
  });
}
