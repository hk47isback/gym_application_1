import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/hive_service.dart';

class ExerciseSelectionDialog extends StatefulWidget {
  final Function(Exercise) onExerciseSelected;

  const ExerciseSelectionDialog({super.key, required this.onExerciseSelected});

  @override
  State<ExerciseSelectionDialog> createState() =>
      _ExerciseSelectionDialogState();
}

class _ExerciseSelectionDialogState extends State<ExerciseSelectionDialog> {
  String? selectedMuscleGroup;
  List<Exercise> filteredExercises = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredExercises = HiveService().getAllExercises();
  }

  void _filterExercises(String? muscleGroup, String search) {
    final exercises = HiveService().getAllExercises();
    setState(() {
      filteredExercises = exercises.where((exercise) {
        final matchesMuscleGroup =
            muscleGroup == null || exercise.muscleGroup == muscleGroup;
        final matchesSearch =
            search.isEmpty ||
            exercise.name.toLowerCase().contains(search.toLowerCase());
        return matchesMuscleGroup && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final muscleGroups = ['Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Core'];

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Exercise',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Search field
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  _filterExercises(selectedMuscleGroup, value),
            ),
            const SizedBox(height: 16),

            // Muscle group filter
            DropdownButtonFormField<String>(
              value: selectedMuscleGroup,
              decoration: const InputDecoration(
                labelText: 'Muscle Group',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...muscleGroups.map(
                  (group) => DropdownMenuItem(value: group, child: Text(group)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMuscleGroup = value;
                  _filterExercises(value, searchController.text);
                });
              },
            ),
            const SizedBox(height: 16),

            // Exercise list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = filteredExercises[index];
                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(exercise.muscleGroup),
                    trailing: Text(
                      exercise.difficulty,
                      style: TextStyle(
                        color: _getDifficultyColor(exercise.difficulty),
                      ),
                    ),
                    onTap: () {
                      widget.onExerciseSelected(exercise);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
