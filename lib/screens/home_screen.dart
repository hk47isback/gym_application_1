import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/workout_log.dart';
import '../models/weekly_plan.dart';
import '../models/exercise.dart';
import '../services/hive_service.dart';
import '../services/data_initialization_service.dart';
import '../services/workout_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.fitness_center),
            onPressed: () => context.go('/exercises'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: FutureBuilder<List<WorkoutLog>>(
        future: _safeGetWorkoutLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading data: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Just rebuild the widget
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Streak Counter
              _buildStreakCounter(),

              // Today's Workout Card
              _buildTodayWorkoutCard(context),

              // Recent Activity
              Expanded(child: _buildRecentActivity(snapshot.data ?? [])),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/workout'),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Workout'),
      ),
    );
  }

  Future<List<WorkoutLog>> _safeGetWorkoutLogs() async {
    try {
      return HiveService().workoutLogsBox.values.toList();
    } catch (e) {
      print('Error getting workout logs: $e');
      return [];
    }
  }

  Widget _buildStreakCounter() {
    int currentStreak = 0;
    try {
      currentStreak = HiveService().getCurrentStreak();
    } catch (e) {
      print('Error getting streak: $e');
      currentStreak = 0;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department,
              color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                '$currentStreak',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Day Streak',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayWorkoutCard(BuildContext context) {
    WeeklyPlan? todaysWorkout;
    List<Exercise> todaysExercises = [];

    try {
      final dataService = DataInitializationService();
      todaysWorkout = dataService.getTodaysWorkout();
      todaysExercises = dataService.getTodaysExercises();
    } catch (e) {
      print('Error getting today\'s workout: $e');
      // Continue with null workout
    }

    // Get current day of the week
    final now = DateTime.now();
    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final todayName = dayNames[now.weekday - 1];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Today\'s Workout',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    todayName,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (todaysWorkout != null)
              Text(
                todaysWorkout.description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              )
            else
              const Text('Rest Day - Recovery Time!'),
            const SizedBox(height: 8),
            if (todaysExercises.isNotEmpty)
              Text(
                '${todaysExercises.length} exercises planned',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer_outlined),
                const SizedBox(width: 8),
                const Text('~45-60 mins'),
                const Spacer(),
                if (todaysExercises.isNotEmpty) ...[
                  OutlinedButton(
                    onPressed: () => _startQuickWorkout(context),
                    child: const Text('Quick Start'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => context.go('/workout'),
                    child: const Text('Start'),
                  ),
                ] else
                  ElevatedButton(
                    onPressed: null,
                    child: const Text('Rest Day'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(List<WorkoutLog> logs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Recent Activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text('Workout on ${log.date.toString().split(' ')[0]}'),
                subtitle: Text('${log.exercises.length} exercises completed'),
                trailing: log.mood != null
                    ? Icon(
                        log.mood == 'Energetic'
                            ? Icons.sentiment_very_satisfied
                            : Icons.sentiment_satisfied,
                        color: log.mood == 'Energetic'
                            ? Colors.green
                            : Colors.orange,
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  void _startQuickWorkout(BuildContext context) {
    final workoutService = WorkoutService();
    workoutService.initializeTodaysWorkout();
    workoutService.startQuickWorkout();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('🚀 Quick workout started with recommended exercises!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () => context.go('/workout'),
        ),
      ),
    );

    context.go('/workout');
  }
}
