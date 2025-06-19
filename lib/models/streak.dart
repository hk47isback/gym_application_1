import 'package:hive/hive.dart';

part 'streak.g.dart';

@HiveType(typeId: 7)
class Streak extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  bool workedOut;

  Streak({required this.date, required this.workedOut});
}
