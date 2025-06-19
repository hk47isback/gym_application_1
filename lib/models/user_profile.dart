import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double heightCm;

  @HiveField(2)
  double weightKg;

  @HiveField(3)
  String goal;

  @HiveField(4)
  DateTime createdAt;

  UserProfile({
    required this.name,
    required this.heightCm,
    required this.weightKg,
    required this.goal,
    required this.createdAt,
  });
}
