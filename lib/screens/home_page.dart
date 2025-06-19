import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/workout.dart';
import '../services/database_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showCalendarView(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 400,
            height: 500,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Workout Calendar',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<Workout>>(
                    future: DatabaseService.instance.getWorkouts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final workouts = snapshot.data ?? [];
                      final workoutDays = <DateTime>{};

                      // Calculate workout days (assuming 5-day cycle)
                      final now = DateTime.now();
                      for (int i = -30; i <= 30; i++) {
                        final date = now.add(Duration(days: i));
                        if (date.weekday >= 1 && date.weekday <= 5) {
                          // Monday to Friday
                          workoutDays
                              .add(DateTime(date.year, date.month, date.day));
                        }
                      }

                      return TableCalendar<String>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: DateTime.now(),
                        calendarFormat: CalendarFormat.month,
                        eventLoader: (day) {
                          final normalizedDay =
                              DateTime(day.year, day.month, day.day);
                          if (workoutDays.contains(normalizedDay)) {
                            final dayOfWeek = _getDayOfWeekName(day.weekday);
                            final dayWorkout = workouts
                                .where((w) => w.dayOfWeek == dayOfWeek)
                                .firstOrNull;
                            return dayWorkout != null ? [dayWorkout.name] : [];
                          }
                          return [];
                        },
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          markerDecoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Blue dots indicate scheduled workout days (Monday-Friday)',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getDayOfWeekName(int weekday) {
    switch (weekday) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showCalendarView(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Workout>>(
        future: DatabaseService.instance.getWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final workouts = snapshot.data ?? [];

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return WorkoutCard(workout: workout);
            },
          );
        },
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  const WorkoutCard({super.key, required this.workout});

  void _navigateToWorkout(BuildContext context) {
    // Navigate to the workout screen
    context.go('/workout');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _navigateToWorkout(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workout.dayOfWeek,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    workout.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Focus: ${workout.primaryMuscles.join(", ")}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (workout.note != null && workout.note!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  workout.note!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${workout.exercises.length} exercises',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
