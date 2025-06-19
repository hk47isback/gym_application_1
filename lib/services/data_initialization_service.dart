import '../models/muscle_group.dart';
import '../models/exercise.dart';
import '../models/weekly_plan.dart';
import '../services/hive_service.dart';

class DataInitializationService {
  static final DataInitializationService _instance =
      DataInitializationService._internal();
  factory DataInitializationService() => _instance;
  DataInitializationService._internal();

  final HiveService _hiveService = HiveService();

  Future<void> initializeDefaultData() async {
    await _initializeMuscleGroups();
    await _initializeExercises();
    await _initializeWeeklyPlans();
  }

  Future<void> _initializeMuscleGroups() async {
    final muscleGroupsBox = _hiveService.muscleGroupsBox;

    if (muscleGroupsBox.isEmpty) {
      final muscleGroups = [
        MuscleGroup(
          id: 'chest',
          name: 'Chest',
          exerciseIds: [],
          description: 'Chest muscles',
        ),
        MuscleGroup(
          id: 'back',
          name: 'Back',
          exerciseIds: [],
          description: 'Back muscles',
        ),
        MuscleGroup(
          id: 'legs',
          name: 'Legs',
          exerciseIds: [],
          description: 'Leg muscles',
        ),
        MuscleGroup(
          id: 'shoulders',
          name: 'Shoulders',
          exerciseIds: [],
          description: 'Shoulder muscles',
        ),
        MuscleGroup(
          id: 'arms',
          name: 'Arms',
          exerciseIds: [],
          description: 'Arm muscles',
        ),
        MuscleGroup(
          id: 'core',
          name: 'Core',
          exerciseIds: [],
          description: 'Core/Abs muscles',
        ),
      ];

      for (final muscleGroup in muscleGroups) {
        await _hiveService.saveMuscleGroup(muscleGroup);
      }
    }
  }

  Future<void> _initializeExercises() async {
    final exercisesBox = _hiveService.exercisesBox;

    if (exercisesBox.isEmpty) {
      final exercises = [
        // Chest exercises
        Exercise(
          id: 'chest_1',
          name: 'Barbell Bench Press',
          muscleGroup: 'chest',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        ),
        Exercise(
          id: 'chest_2',
          name: 'Dumbbell Chest Press',
          muscleGroup: 'chest',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'chest_3',
          name: 'Push-ups',
          muscleGroup: 'chest',
          equipment: 'Bodyweight',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'chest_4',
          name: 'Incline Dumbbell Press',
          muscleGroup: 'chest',
          equipment: 'Dumbbell',
          difficulty: 'Intermediate',
        ),
        Exercise(
          id: 'chest_5',
          name: 'Chest Fly Machine',
          muscleGroup: 'chest',
          equipment: 'Machine',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'chest_6',
          name: 'Cable Chest Fly',
          muscleGroup: 'chest',
          equipment: 'Cable',
          difficulty: 'Intermediate',
        ),

        // Back exercises
        Exercise(
          id: 'back_1',
          name: 'Pull-ups',
          muscleGroup: 'back',
          equipment: 'Bodyweight',
          difficulty: 'Advanced',
        ),
        Exercise(
          id: 'back_2',
          name: 'Lat Pulldown',
          muscleGroup: 'back',
          equipment: 'Cable',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'back_3',
          name: 'Seated Cable Row',
          muscleGroup: 'back',
          equipment: 'Cable',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'back_4',
          name: 'Bent-over Barbell Row',
          muscleGroup: 'back',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        ),
        Exercise(
          id: 'back_5',
          name: 'Single-arm Dumbbell Row',
          muscleGroup: 'back',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'back_6',
          name: 'Assisted Pull-ups',
          muscleGroup: 'back',
          equipment: 'Machine',
          difficulty: 'Beginner',
        ),

        // Leg exercises
        Exercise(
          id: 'legs_1',
          name: 'Barbell Back Squat',
          muscleGroup: 'legs',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        ),
        Exercise(
          id: 'legs_2',
          name: 'Leg Press',
          muscleGroup: 'legs',
          equipment: 'Machine',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'legs_3',
          name: 'Romanian Deadlift',
          muscleGroup: 'legs',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        ),
        Exercise(
          id: 'legs_4',
          name: 'Leg Extension',
          muscleGroup: 'legs',
          equipment: 'Machine',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'legs_5',
          name: 'Leg Curl',
          muscleGroup: 'legs',
          equipment: 'Machine',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'legs_6',
          name: 'Goblet Squat',
          muscleGroup: 'legs',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'legs_7',
          name: 'Calf Raises',
          muscleGroup: 'legs',
          equipment: 'Bodyweight',
          difficulty: 'Beginner',
        ),

        // Shoulder exercises
        Exercise(
          id: 'shoulders_1',
          name: 'Overhead Barbell Press',
          muscleGroup: 'shoulders',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        ),
        Exercise(
          id: 'shoulders_2',
          name: 'Dumbbell Shoulder Press',
          muscleGroup: 'shoulders',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'shoulders_3',
          name: 'Lateral Raise',
          muscleGroup: 'shoulders',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'shoulders_4',
          name: 'Front Raise',
          muscleGroup: 'shoulders',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'shoulders_5',
          name: 'Rear Delt Fly',
          muscleGroup: 'shoulders',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'shoulders_6',
          name: 'Shoulder Press Machine',
          muscleGroup: 'shoulders',
          equipment: 'Machine',
          difficulty: 'Beginner',
        ),

        // Arm exercises
        Exercise(
          id: 'arms_1',
          name: 'Barbell Bicep Curl',
          muscleGroup: 'arms',
          equipment: 'Barbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'arms_2',
          name: 'Triceps Pushdown',
          muscleGroup: 'arms',
          equipment: 'Cable',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'arms_3',
          name: 'Hammer Curls',
          muscleGroup: 'arms',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'arms_4',
          name: 'Overhead Triceps Extension',
          muscleGroup: 'arms',
          equipment: 'Dumbbell',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'arms_5',
          name: 'Preacher Curls',
          muscleGroup: 'arms',
          equipment: 'Barbell',
          difficulty: 'Intermediate',
        ),
        Exercise(
          id: 'arms_6',
          name: 'Triceps Dips',
          muscleGroup: 'arms',
          equipment: 'Bodyweight',
          difficulty: 'Intermediate',
        ),

        // Core exercises
        Exercise(
          id: 'core_1',
          name: 'Hanging Leg Raises',
          muscleGroup: 'core',
          equipment: 'Bodyweight',
          difficulty: 'Advanced',
        ),
        Exercise(
          id: 'core_2',
          name: 'Plank',
          muscleGroup: 'core',
          equipment: 'Bodyweight',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'core_3',
          name: 'Russian Twists',
          muscleGroup: 'core',
          equipment: 'Bodyweight',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'core_4',
          name: 'Cable Crunches',
          muscleGroup: 'core',
          equipment: 'Cable',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'core_5',
          name: 'Dead Bug',
          muscleGroup: 'core',
          equipment: 'Bodyweight',
          difficulty: 'Beginner',
        ),
        Exercise(
          id: 'core_6',
          name: 'Ab Wheel Rollout',
          muscleGroup: 'core',
          equipment: 'Equipment',
          difficulty: 'Advanced',
        ),
      ];

      for (final exercise in exercises) {
        await _hiveService.saveExercise(exercise);
      }
    }
  }

  Future<void> _initializeWeeklyPlans() async {
    final weeklyPlanBox = _hiveService.weeklyPlanBox;

    if (weeklyPlanBox.isEmpty) {
      final weeklyPlans = [
        WeeklyPlan(
          dayIndex: 1,
          muscleGroupId: 'chest',
          dayName: 'Monday',
          muscleGroups: ['chest', 'arms'],
          description: 'Chest & Triceps',
        ),
        WeeklyPlan(
          dayIndex: 2,
          muscleGroupId: 'back',
          dayName: 'Tuesday',
          muscleGroups: ['back', 'arms'],
          description: 'Back & Biceps',
        ),
        WeeklyPlan(
          dayIndex: 3,
          muscleGroupId: 'legs',
          dayName: 'Wednesday',
          muscleGroups: ['legs'],
          description: 'Legs',
        ),
        WeeklyPlan(
          dayIndex: 4,
          muscleGroupId: 'shoulders',
          dayName: 'Thursday',
          muscleGroups: ['shoulders'],
          description: 'Shoulders',
        ),
        WeeklyPlan(
          dayIndex: 5,
          muscleGroupId: 'arms',
          dayName: 'Friday',
          muscleGroups: ['arms', 'core'],
          description: 'Arms & Core',
        ),
        WeeklyPlan(
          dayIndex: 6,
          muscleGroupId: '',
          dayName: 'Saturday',
          muscleGroups: [],
          description: 'Rest Day',
        ),
        WeeklyPlan(
          dayIndex: 0,
          muscleGroupId: '',
          dayName: 'Sunday',
          muscleGroups: [],
          description: 'Rest Day',
        ),
      ];

      for (final plan in weeklyPlans) {
        await _hiveService.saveWeeklyPlan(plan);
      }
    }
  }

  // Helper method to get today's workout
  WeeklyPlan? getTodaysWorkout() {
    final today =
        DateTime.now().weekday; // 1 = Monday, 7 = Sunday (but we use 0)
    final adjustedDay = today == 7 ? 0 : today; // Convert Sunday from 7 to 0

    return _hiveService.getWeeklyPlan(adjustedDay);
  }

  // Helper method to get exercises for today's workout
  List<Exercise> getTodaysExercises() {
    final todaysWorkout = getTodaysWorkout();
    if (todaysWorkout == null || todaysWorkout.muscleGroups.isEmpty) {
      return [];
    }

    final exercises = <Exercise>[];
    for (final muscleGroup in todaysWorkout.muscleGroups) {
      final muscleGroupExercises = _hiveService.getExercisesForMuscleGroup(
        muscleGroup,
      );
      exercises.addAll(muscleGroupExercises);
    }

    return exercises;
  }
}
