import 'package:hive/hive.dart';

part 'muscle_group.g.dart';

@HiveType(typeId: 1)
class MuscleGroup extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> exerciseIds;

  @HiveField(3)
  String description;

  MuscleGroup({
    required this.id,
    required this.name,
    required this.exerciseIds,
    required this.description,
  });
}
