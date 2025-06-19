import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Models (Hive adapters are automatically included via part files)
import '../models/user_profile.dart';
import '../models/muscle_group.dart';
import '../models/exercise.dart';
import '../models/weekly_plan.dart';
import '../models/workout_log.dart';
import '../models/app_settings.dart';
import '../models/streak.dart';

// Custom adapters
import '../models/adapters/time_of_day_adapter.dart';

// Constants
import '../utils/constants.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() {
    return _instance;
  }

  HiveService._internal();

  Future<void> init() async {
    try {
      // Initialize Hive for web/mobile
      if (kIsWeb) {
        await Hive.initFlutter();
      } else {
        await Hive.initFlutter();
      }

      // Register custom adapters first
      if (!Hive.isAdapterRegistered(100)) {
        Hive.registerAdapter(TimeOfDayAdapter());
      }

      // Register generated adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserProfileAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(MuscleGroupAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(ExerciseAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(WeeklyPlanAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(WorkoutLogAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(WorkoutEntryAdapter());
      }
      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(AppSettingsAdapter());
      }
      if (!Hive.isAdapterRegistered(7)) {
        Hive.registerAdapter(StreakAdapter());
      }

      // Open Boxes
      await Future.wait([
        Hive.openBox<UserProfile>(kUserProfileBox),
        Hive.openBox<MuscleGroup>(kMuscleGroupsBox),
        Hive.openBox<Exercise>(kExercisesBox),
        Hive.openBox<WeeklyPlan>(kWeeklyPlanBox),
        Hive.openBox<WorkoutLog>(kWorkoutLogsBox),
        Hive.openBox<AppSettings>(kAppSettingsBox),
        Hive.openBox<Streak>(kStreaksBox),
      ]);

      print('✅ Hive initialization completed successfully');
    } catch (e) {
      print('❌ Hive initialization error: $e');
      rethrow;
    }
  }

  // Helper methods for UserProfile
  Box<UserProfile> get userProfileBox => Hive.box<UserProfile>(kUserProfileBox);

  UserProfile? getUserProfile() {
    return userProfileBox.get('profile');
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await userProfileBox.put('profile', profile);
  }

  // Helper methods for MuscleGroups
  Box<MuscleGroup> get muscleGroupsBox =>
      Hive.box<MuscleGroup>(kMuscleGroupsBox);

  List<MuscleGroup> getAllMuscleGroups() {
    return muscleGroupsBox.values.toList();
  }

  Future<void> saveMuscleGroup(MuscleGroup muscleGroup) async {
    await muscleGroupsBox.put(muscleGroup.id, muscleGroup);
  }

  // Helper methods for Exercises
  Box<Exercise> get exercisesBox => Hive.box<Exercise>(kExercisesBox);

  List<Exercise> getAllExercises() {
    return exercisesBox.values.toList();
  }

  List<Exercise> getExercisesForMuscleGroup(String muscleGroupId) {
    final exercises = exercisesBox.values.toList();
    return exercises
        .where((exercise) => exercise.muscleGroup == muscleGroupId)
        .toList();
  }

  Future<void> saveExercise(Exercise exercise) async {
    await exercisesBox.put(exercise.id, exercise);
  }

  // Helper methods for WeeklyPlan
  Box<WeeklyPlan> get weeklyPlanBox => Hive.box<WeeklyPlan>(kWeeklyPlanBox);

  WeeklyPlan? getWeeklyPlan(int dayIndex) {
    return weeklyPlanBox.get(dayIndex);
  }

  Future<void> saveWeeklyPlan(WeeklyPlan plan) async {
    await weeklyPlanBox.put(plan.dayIndex, plan);
  }

  // Helper methods for WorkoutLogs
  Box<WorkoutLog> get workoutLogsBox => Hive.box<WorkoutLog>(kWorkoutLogsBox);

  List<WorkoutLog> getAllWorkoutLogs() {
    return workoutLogsBox.values.toList();
  }

  Future<void> saveWorkoutLog(WorkoutLog log) async {
    await workoutLogsBox.put(log.id, log);
  }

  // Helper methods for AppSettings
  Box<AppSettings> get appSettingsBox => Hive.box<AppSettings>(kAppSettingsBox);
  AppSettings getAppSettings() {
    return appSettingsBox.get('settings') ??
        AppSettings(
          darkMode: false,
          notificationsEnabled: true,
          useMetric: true,
        );
  }

  Future<void> saveAppSettings(AppSettings settings) async {
    await appSettingsBox.put('settings', settings);
  }

  // Helper methods for Streaks
  Box<Streak> get streaksBox => Hive.box<Streak>(kStreaksBox);

  List<Streak> getAllStreaks() {
    return streaksBox.values.toList();
  }

  Future<void> saveStreak(Streak streak) async {
    final key = streak.date.toIso8601String();
    await streaksBox.put(key, streak);
  }

  int getCurrentStreak() {
    final streaks = getAllStreaks()..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime? lastDate;

    for (var s in streaks) {
      if (!s.workedOut) break;
      if (lastDate != null) {
        final difference = lastDate.difference(s.date).inDays;
        if (difference != 1) break;
      }
      streak++;
      lastDate = s.date;
    }

    return streak;
  }

  // ValueListenable getters
  ValueListenable<Box<Exercise>> get exercisesListenable =>
      Hive.box<Exercise>(kExercisesBox).listenable();

  ValueListenable<Box<WorkoutLog>> get workoutLogsListenable =>
      Hive.box<WorkoutLog>(kWorkoutLogsBox).listenable();

  ValueListenable<Box<UserProfile>> get userProfileListenable =>
      Hive.box<UserProfile>(kUserProfileBox).listenable();

  ValueListenable<Box<AppSettings>> get appSettingsListenable =>
      Hive.box<AppSettings>(kAppSettingsBox).listenable();
}
