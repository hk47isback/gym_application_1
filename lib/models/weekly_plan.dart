import 'package:hive/hive.dart';

part 'weekly_plan.g.dart';

@HiveType(typeId: 3)
class WeeklyPlan extends HiveObject {
  @HiveField(0)
  int dayIndex;

  @HiveField(1)
  String muscleGroupId;

  @HiveField(2)
  String dayName;

  @HiveField(3)
  List<String> muscleGroups;

  @HiveField(4)
  String description;

  WeeklyPlan({
    required this.dayIndex,
    required this.muscleGroupId,
    required this.dayName,
    required this.muscleGroups,
    required this.description,
  });
}
