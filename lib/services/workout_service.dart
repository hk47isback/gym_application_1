import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import '../models/workout_log.dart';
import '../models/streak.dart';
import '../models/weekly_plan.dart';
import '../services/hive_service.dart';
import '../services/data_initialization_service.dart';

class WorkoutService extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  final DataInitializationService _dataService = DataInitializationService();

  WeeklyPlan? _todaysWorkout;
  List<Exercise> _todaysExercises = [];
  List<WorkoutEntry> _currentExercises = [];
  bool _isSessionActive = false;
  DateTime? _sessionStartTime;

  // Getters
  WeeklyPlan? get todaysWorkout => _todaysWorkout;
  List<Exercise> get todaysExercises => _todaysExercises;
  List<WorkoutEntry> get currentExercises =>
      List.unmodifiable(_currentExercises);
  bool get isSessionActive => _isSessionActive;
  DateTime? get sessionStartTime => _sessionStartTime;

  int get completedExerciseCount =>
      _currentExercises.where((e) => e.completed).length;
  int get totalExerciseCount => _currentExercises.length;

  double get completionPercentage {
    if (_currentExercises.isEmpty) return 0.0;
    return completedExerciseCount / totalExerciseCount;
  }

  bool get isRestDay =>
      _todaysWorkout == null || _todaysWorkout!.muscleGroups.isEmpty;

  String getWorkoutSummary() {
    if (!_isSessionActive) return 'Not started';
    final duration = _sessionStartTime != null
        ? DateTime.now().difference(_sessionStartTime!).inMinutes
        : 0;
    return 'Active • ${duration}min • $completedExerciseCount/$totalExerciseCount completed';
  }

  // Initialize workout data
  void initializeTodaysWorkout() {
    _todaysWorkout = _dataService.getTodaysWorkout();
    _todaysExercises = _dataService.getTodaysExercises();
    notifyListeners();
  }

  // Session management
  void startSession() {
    if (_isSessionActive) return;

    _isSessionActive = true;
    _sessionStartTime = DateTime.now();
    _currentExercises.clear();
    notifyListeners();
  }

  void endSession() {
    _isSessionActive = false;
    _sessionStartTime = null;
    _currentExercises.clear();
    notifyListeners();
  }

  // Exercise management
  void addExercise(Exercise exercise,
      {int sets = 3, int reps = 12, double weight = 20.0}) {
    final entry = WorkoutEntry(
      exerciseId: exercise.id,
      sets: sets,
      reps: reps,
      weight: weight,
      completed: false,
    );

    _currentExercises.add(entry);
    notifyListeners();
  }

  void removeExercise(int index) {
    if (index >= 0 && index < _currentExercises.length) {
      _currentExercises.removeAt(index);
      notifyListeners();
    }
  }

  void updateExercise(int index,
      {int? sets, int? reps, double? weight, bool? completed}) {
    if (index >= 0 && index < _currentExercises.length) {
      final current = _currentExercises[index];
      _currentExercises[index] = WorkoutEntry(
        exerciseId: current.exerciseId,
        sets: sets ?? current.sets,
        reps: reps ?? current.reps,
        weight: weight ?? current.weight,
        completed: completed ?? current.completed,
      );
      notifyListeners();
    }
  }

  void toggleExerciseCompletion(int index) {
    if (index >= 0 && index < _currentExercises.length) {
      updateExercise(index, completed: !_currentExercises[index].completed);
    }
  }

  // Quick workout functionality
  void startQuickWorkout() {
    startSession();

    // Add 3-4 recommended exercises automatically
    final recommendedExercises = _getRecommendedExercises();
    for (final exercise in recommendedExercises.take(4)) {
      addExercise(exercise);
    }
  }

  List<Exercise> _getRecommendedExercises() {
    if (_todaysExercises.isEmpty) return [];

    // Prioritize beginner-friendly exercises
    final beginnerExercises = _todaysExercises
        .where((ex) => ex.difficulty.toLowerCase() == 'beginner')
        .toList();

    if (beginnerExercises.length >= 3) {
      return beginnerExercises;
    } else {
      return _todaysExercises.take(6).toList();
    }
  }

  // Workout completion
  Future<bool> finishWorkout({String? mood}) async {
    if (!_isSessionActive || _currentExercises.isEmpty) {
      return false;
    }

    try {
      // Save workout log
      final workoutLog = WorkoutLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        exercises: List.from(_currentExercises),
        mood: mood ?? (completionPercentage == 1.0 ? 'Energetic' : 'Good'),
      );

      await _hiveService.saveWorkoutLog(workoutLog);

      // Update streak if at least 50% of exercises completed
      if (completionPercentage >= 0.5) {
        await _updateStreak();
      }

      // End session
      endSession();
      return true;
    } catch (e) {
      debugPrint('Error finishing workout: $e');
      return false;
    }
  }

  Future<void> _updateStreak() async {
    final today = DateTime.now();
    final streakDate = DateTime(today.year, today.month, today.day);

    final streak = Streak(
      date: streakDate,
      workedOut: true,
    );

    await _hiveService.saveStreak(streak);
  }

  // Statistics
  int getWeeklyWorkoutCount() {
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _hiveService
        .getAllWorkoutLogs()
        .where((log) => log.date.isAfter(oneWeekAgo))
        .length;
  }

  int getMonthlyWorkoutCount() {
    final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
    return _hiveService
        .getAllWorkoutLogs()
        .where((log) => log.date.isAfter(oneMonthAgo))
        .length;
  }
}
