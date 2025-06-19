import 'package:hive/hive.dart';

part 'workout_log.g.dart';

@HiveType(typeId: 4)
class WorkoutLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  List<WorkoutEntry> exercises;

  @HiveField(3)
  String? mood;

  @HiveField(4)
  String? notes;

  WorkoutLog({
    required this.id,
    required this.date,
    required this.exercises,
    this.mood,
    this.notes,
  });
}

@HiveType(typeId: 5)
class WorkoutEntry extends HiveObject {
  @HiveField(0)
  String exerciseId;

  @HiveField(1)
  int sets;

  @HiveField(2)
  int reps;

  @HiveField(3)
  double weight;

  @HiveField(4)
  bool completed;

  WorkoutEntry({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.weight,
    this.completed = false,
  });
}
