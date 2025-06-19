import 'package:go_router/go_router.dart';
import '../models/exercise.dart';
import '../screens/home_screen.dart';
import '../screens/workout_screen.dart';
import '../screens/exercise_library_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/exercise_details_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/workout',
      builder: (context, state) => const WorkoutScreen(),
    ),
    GoRoute(
      path: '/exercises',
      builder: (context, state) => const ExerciseLibraryScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/exercises/:id',
      builder: (context, state) {
        final exercise = state.extra as Exercise;
        return ExerciseDetailsScreen(exercise: exercise);
      },
    ),
  ],
);
