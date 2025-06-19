import '../models/workout.dart';
import '../models/exercise.dart';
import 'hive_service.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  final HiveService _hiveService = HiveService();

  DatabaseService._init();

  /// Get all workouts based on weekly plans and exercises
  Future<List<Workout>> getWorkouts() async {
    final weeklyPlans = _hiveService.weeklyPlanBox.values.toList();
    final allExercises = _hiveService.getAllExercises();

    final workouts = <Workout>[];

    for (final plan in weeklyPlans) {
      // Get exercises for this day's muscle groups
      final dayExercises = <Exercise>[];
      for (final muscleGroupId in plan.muscleGroups) {
        final muscleGroupExercises = allExercises
            .where((exercise) => exercise.muscleGroup == muscleGroupId)
            .toList();
        dayExercises.addAll(muscleGroupExercises);
      }

      final workout = Workout(
        id: plan.dayIndex.toString(),
        name: plan.description,
        dayOfWeek: _getDayOfWeekName(plan.dayIndex),
        primaryMuscles: plan.muscleGroups,
        note: plan.description,
        exercises: dayExercises,
      );

      workouts.add(workout);
    }

    // If no weekly plans exist, create default empty workouts for the 5-day schedule
    if (workouts.isEmpty) {
      workouts.addAll(_createDefaultWorkouts());
    }

    return workouts;
  }

  /// Get a specific workout by ID
  Future<Workout?> getWorkout(String id) async {
    final workouts = await getWorkouts();
    try {
      return workouts.firstWhere((workout) => workout.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get today's workout based on current day of week
  Future<Workout?> getTodaysWorkout() async {
    final today = DateTime.now().weekday; // 1 = Monday, 7 = Sunday
    if (today > 5) return null; // Weekend, no workout

    final weeklyPlan = _hiveService.getWeeklyPlan(today);
    if (weeklyPlan == null) return null;

    final exercises = <Exercise>[];
    for (final muscleGroupId in weeklyPlan.muscleGroups) {
      final muscleGroupExercises =
          _hiveService.getExercisesForMuscleGroup(muscleGroupId);
      exercises.addAll(muscleGroupExercises);
    }

    return Workout(
      id: today.toString(),
      name: weeklyPlan.description,
      dayOfWeek: _getDayOfWeekName(today),
      primaryMuscles: weeklyPlan.muscleGroups,
      note: weeklyPlan.description,
      exercises: exercises,
    );
  }

  /// Helper method to convert day index to day name
  String _getDayOfWeekName(int dayIndex) {
    switch (dayIndex) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  /// Create default workouts when no weekly plans exist
  List<Workout> _createDefaultWorkouts() {
    return [
      Workout(
        id: '1',
        name: 'Push Day',
        dayOfWeek: 'Monday',
        primaryMuscles: ['Chest', 'Shoulders', 'Triceps'],
        note: 'Chest, shoulders, and triceps focus',
        exercises: [],
      ),
      Workout(
        id: '2',
        name: 'Pull Day',
        dayOfWeek: 'Tuesday',
        primaryMuscles: ['Back', 'Biceps'],
        note: 'Back and biceps focus',
        exercises: [],
      ),
      Workout(
        id: '3',
        name: 'Legs Day',
        dayOfWeek: 'Wednesday',
        primaryMuscles: ['Legs', 'Glutes'],
        note: 'Leg and glute focus',
        exercises: [],
      ),
      Workout(
        id: '4',
        name: 'Upper Body',
        dayOfWeek: 'Thursday',
        primaryMuscles: ['Chest', 'Back', 'Arms'],
        note: 'Upper body focus',
        exercises: [],
      ),
      Workout(
        id: '5',
        name: 'Full Body',
        dayOfWeek: 'Friday',
        primaryMuscles: ['Full Body'],
        note: 'Full body workout',
        exercises: [],
      ),
    ];
  }
}
