import 'package:hive/hive.dart';
import 'exercise.dart';

part 'workout.g.dart';

@HiveType(typeId: 8)
class Workout extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String dayOfWeek;

  @HiveField(3)
  final List<String> primaryMuscles;

  @HiveField(4)
  final String? note;

  @HiveField(5)
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.name,
    required this.dayOfWeek,
    required this.primaryMuscles,
    this.note,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dayOfWeek': dayOfWeek,
      'primaryMuscles': primaryMuscles.join(','),
      'note': note,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map, List<Exercise> exercises) {
    return Workout(
      id: map['id'],
      name: map['name'],
      dayOfWeek: map['dayOfWeek'],
      primaryMuscles: (map['primaryMuscles'] as String).split(','),
      note: map['note'],
      exercises: exercises,
    );
  }
}


