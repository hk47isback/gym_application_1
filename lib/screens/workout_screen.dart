import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/exercise.dart';
import '../models/workout_log.dart';
import '../models/streak.dart';
import '../models/weekly_plan.dart';
import '../services/hive_service.dart';
import '../services/data_initialization_service.dart';
import '../services/workout_service.dart';
import '../widgets/workout_timer.dart';
import 'package:uuid/uuid.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with WidgetsBindingObserver {
  final _uuid = const Uuid();
  final GlobalKey<WorkoutTimerState> _timerKey = GlobalKey<WorkoutTimerState>();

  // State variables
  List<WorkoutEntry> entries = [];
  bool isWorkoutStarted = false;
  WeeklyPlan? todaysWorkout;
  List<Exercise> todaysExercises = [];
  DateTime? sessionStartTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeWorkout();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initializeWorkout() async {
    await DataInitializationService().initializeDefaultData();
    final today = DateTime.now().weekday;
    final todaysPlans = HiveService()
        .weeklyPlanBox
        .values
        .where((plan) => plan.dayIndex == today)
        .toList();

    if (todaysPlans.isNotEmpty) {
      setState(() {
        todaysWorkout = todaysPlans.first;
        _loadTodaysExercises();
      });
    }
  }

  void _loadTodaysExercises() {
    if (todaysWorkout == null) return;

    final exercises = <Exercise>[];
    for (final muscleGroupId in todaysWorkout!.muscleGroups) {
      final muscleGroupExercises = HiveService()
          .exercisesBox
          .values
          .where((exercise) => exercise.muscleGroup == muscleGroupId)
          .toList();
      exercises.addAll(muscleGroupExercises);
    }

    setState(() {
      todaysExercises = exercises;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _onBackPressed(),
        ),
        title: Text(todaysWorkout?.description ?? 'Workout'),
        actions: [
          if (isWorkoutStarted && entries.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.check, color: Colors.white),
              label:
                  const Text('Complete', style: TextStyle(color: Colors.white)),
              onPressed: _completeWorkout,
            ),
        ],
      ),
      body: Column(
        children: [
          _buildWorkoutHeader(),
          if (isWorkoutStarted) WorkoutTimer(key: _timerKey),
          if (isWorkoutStarted) _buildSessionStatus(),
          if (isWorkoutStarted) _buildWorkoutControls(),
          Expanded(
            child: !isWorkoutStarted
                ? _buildWorkoutPreview()
                : entries.isEmpty
                    ? _buildGuidedStart()
                    : _buildActiveWorkout(),
          ),
        ],
      ),
      floatingActionButton: isWorkoutStarted
          ? FloatingActionButton(
              onPressed: _addExercise,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _onBackPressed() async {
    if (isWorkoutStarted && entries.isNotEmpty) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit Workout?'),
          content: const Text(
            'You have an active workout session. Are you sure you want to exit?\n\nYour progress will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Exit'),
            ),
          ],
        ),
      );

      if (shouldExit == true) {
        context.go('/');
      }
    } else {
      context.go('/');
    }
  }

  Widget _buildWorkoutControls() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _timerKey.currentState?.pauseTimer(),
              icon: const Icon(Icons.pause),
              label: const Text('Pause'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _timerKey.currentState?.resumeTimer(),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Resume'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _timerKey.currentState?.resetTimer(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _completeWorkout,
              icon: const Icon(Icons.check),
              label: const Text('Complete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutHeader() {
    if (todaysWorkout == null || todaysWorkout!.muscleGroups.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.weekend, color: Colors.orange.shade600, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rest Day',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const Text('Take a break and recover!'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todaysWorkout!.description,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${todaysExercises.length} exercises available',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.group_work, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Muscle Groups: ${todaysWorkout!.muscleGroups.join(', ')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exercises: ${entries.length}',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Completed: ${entries.where((e) => e.completed).length}/${entries.length}',
                style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: entries.isEmpty
                  ? 0
                  : entries.where((e) => e.completed).length / entries.length,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPreview() {
    if (todaysWorkout == null || todaysExercises.isEmpty) {
      return const Center(
        child: Text('No workout available for today'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: todaysExercises.length,
            itemBuilder: (context, index) {
              final exercise = todaysExercises[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(exercise.name),
                  subtitle:
                      Text('${exercise.equipment} • ${exercise.difficulty}'),
                  trailing: const Icon(Icons.fitness_center),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _startWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Start Workout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuidedStart() {
    if (todaysExercises.isEmpty) {
      return const Center(
        child: Text('No exercises available'),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Quick Add Exercises',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: todaysExercises.take(6).length,
            itemBuilder: (context, index) {
              final exercise = todaysExercises[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  child: InkWell(
                    onTap: () => _quickAddExercise(exercise),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fitness_center, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            exercise.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Spacer(),
        _buildManualExerciseSelection(),
      ],
    );
  }

  Widget _buildManualExerciseSelection() {
    if (todaysExercises.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Or choose from all exercises:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: todaysExercises.map((exercise) {
              return ActionChip(
                label: Text(exercise.name),
                onPressed: () => _quickAddExercise(exercise),
                backgroundColor: Colors.blue.shade50,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveWorkout() {
    if (entries.isEmpty) {
      return const Center(
        child: Text('No exercises added yet'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final exercise = todaysExercises.firstWhere(
          (ex) => ex.id == entry.exerciseId,
          orElse: () => Exercise(
            id: entry.exerciseId,
            name: 'Unknown Exercise',
            muscleGroup: '',
            equipment: '',
            difficulty: '',
          ),
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Checkbox(
                      value: entry.completed,
                      onChanged: (value) {
                        setState(() {
                          entries[index] = WorkoutEntry(
                            exerciseId: entry.exerciseId,
                            sets: entry.sets,
                            reps: entry.reps,
                            weight: entry.weight,
                            completed: value ?? false,
                          );
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          entries.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  '${exercise.equipment} • ${exercise.difficulty}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Sets',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        controller:
                            TextEditingController(text: entry.sets.toString()),
                        onChanged: (value) {
                          final sets = int.tryParse(value) ?? entry.sets;
                          setState(() {
                            entries[index] = WorkoutEntry(
                              exerciseId: entry.exerciseId,
                              sets: sets,
                              reps: entry.reps,
                              weight: entry.weight,
                              completed: entry.completed,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Reps',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        controller:
                            TextEditingController(text: entry.reps.toString()),
                        onChanged: (value) {
                          final reps = int.tryParse(value) ?? entry.reps;
                          setState(() {
                            entries[index] = WorkoutEntry(
                              exerciseId: entry.exerciseId,
                              sets: entry.sets,
                              reps: reps,
                              weight: entry.weight,
                              completed: entry.completed,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                            text: entry.weight.toString()),
                        onChanged: (value) {
                          final weight = double.tryParse(value) ?? entry.weight;
                          setState(() {
                            entries[index] = WorkoutEntry(
                              exerciseId: entry.exerciseId,
                              sets: entry.sets,
                              reps: entry.reps,
                              weight: weight,
                              completed: entry.completed,
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startWorkout() {
    setState(() {
      isWorkoutStarted = true;
      sessionStartTime = DateTime.now();
    });
  }

  void _quickAddExercise(Exercise exercise) {
    final entry = WorkoutEntry(
      exerciseId: exercise.id,
      sets: 3,
      reps: 12,
      weight: 20.0,
    );
    setState(() {
      entries.add(entry);
      if (!isWorkoutStarted) isWorkoutStarted = true;
    });
  }

  void _addExercise() {
    if (todaysExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No exercises available')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Exercise'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: todaysExercises.length,
            itemBuilder: (context, index) {
              final exercise = todaysExercises[index];
              return ListTile(
                title: Text(exercise.name),
                subtitle:
                    Text('${exercise.equipment} • ${exercise.difficulty}'),
                onTap: () {
                  Navigator.of(context).pop();
                  _quickAddExercise(exercise);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _completeWorkout() async {
    if (entries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Add at least one exercise to complete workout!')),
      );
      return;
    }

    final completedCount = entries.where((e) => e.completed).length;
    final totalCount = entries.length;

    final shouldComplete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Workout?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exercises completed: $completedCount/$totalCount'),
            const SizedBox(height: 8),
            if (completedCount < totalCount)
              Text(
                'You haven\'t completed all exercises. Complete anyway?',
                style: TextStyle(color: Colors.orange[700]),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                    'Session time: ${_timerKey.currentState?.getFormattedTime() ?? "00:00"}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (shouldComplete != true) return;

    final workoutLog = WorkoutLog(
      id: _uuid.v4(),
      date: DateTime.now(),
      exercises: entries,
      mood: completedCount == totalCount ? 'Energetic' : 'Good',
    );

    await HiveService().saveWorkoutLog(workoutLog);

    // Update streak only if at least half exercises completed
    if (completedCount >= (totalCount / 2)) {
      final today = DateTime.now();
      final streak = Streak(
        date: DateTime(today.year, today.month, today.day),
        workedOut: true,
      );
      await HiveService().saveStreak(streak);
    }

    if (mounted) {
      final message = completedCount == totalCount
          ? '🎉 Perfect workout! All exercises completed!'
          : '💪 Good job! $completedCount/$totalCount exercises completed!';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate back to home
      context.go('/');
    }
  }

  // Legacy method for backward compatibility
  void _finishWorkout() => _completeWorkout();
}
