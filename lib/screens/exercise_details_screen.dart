import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailsScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          exercise.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      'Muscle Group',
                      exercise.muscleGroup,
                      Icons.accessibility_new,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      'Equipment',
                      exercise.equipment,
                      Icons.sports_gymnastics,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      'Difficulty',
                      exercise.difficulty,
                      Icons.trending_up,
                      valueColor: _getDifficultyColor(exercise.difficulty),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recommended section
            Text('Recommended', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRecommendationRow('Sets', '3-4'),
                    const Divider(height: 24),
                    _buildRecommendationRow('Reps', '8-12'),
                    const Divider(height: 24),
                    _buildRecommendationRow('Rest', '60-90 sec'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Instructions section
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getExerciseInstructions(exercise.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text('$label:', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildRecommendationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInstructionStep(int step, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            child: Text(step.toString(), style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getExerciseInstructions(String exerciseName) {
    // Create basic instructions based on exercise name
    final instructions = _getInstructionsForExercise(exerciseName);

    return instructions.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final instruction = entry.value;
      return _buildInstructionStep(
        index,
        instruction['title']!,
        instruction['description']!,
      );
    }).toList();
  }

  List<Map<String, String>> _getInstructionsForExercise(String exerciseName) {
    final name = exerciseName.toLowerCase();

    if (name.contains('push-up') || name.contains('pushup')) {
      return [
        {
          'title': 'Starting Position',
          'description':
              'Place hands shoulder-width apart on the floor, body in straight line from head to heels.'
        },
        {
          'title': 'Descent',
          'description':
              'Lower your body by bending elbows until chest nearly touches the floor.'
        },
        {
          'title': 'Push Up',
          'description':
              'Push through palms to extend arms and return to starting position.'
        },
      ];
    } else if (name.contains('squat')) {
      return [
        {
          'title': 'Setup',
          'description':
              'Stand with feet shoulder-width apart, toes slightly pointed out.'
        },
        {
          'title': 'Descent',
          'description':
              'Lower body by bending at hips and knees, keeping chest up and weight on heels.'
        },
        {
          'title': 'Rise',
          'description':
              'Drive through heels to return to standing position, squeezing glutes at top.'
        },
      ];
    } else if (name.contains('deadlift')) {
      return [
        {
          'title': 'Setup',
          'description':
              'Stand with feet hip-width apart, barbell over mid-foot.'
        },
        {
          'title': 'Lift',
          'description':
              'Grip bar, keep chest up, and lift by extending hips and knees simultaneously.'
        },
        {
          'title': 'Lower',
          'description':
              'Reverse the movement by pushing hips back and bending knees to lower the bar.'
        },
      ];
    } else if (name.contains('bench press') || name.contains('press')) {
      return [
        {
          'title': 'Setup',
          'description':
              'Lie on bench with eyes under the bar, feet flat on floor.'
        },
        {
          'title': 'Unrack',
          'description':
              'Grip bar slightly wider than shoulders, unrack and position over chest.'
        },
        {
          'title': 'Press',
          'description':
              'Lower bar to chest with control, then press up powerfully to arm extension.'
        },
      ];
    } else if (name.contains('pull-up') || name.contains('pullup')) {
      return [
        {
          'title': 'Hang',
          'description':
              'Hang from bar with hands shoulder-width apart, arms fully extended.'
        },
        {
          'title': 'Pull',
          'description':
              'Pull yourself up by engaging lats and biceps until chin clears bar.'
        },
        {
          'title': 'Lower',
          'description':
              'Lower yourself with control back to full arm extension.'
        },
      ];
    } else if (name.contains('plank')) {
      return [
        {
          'title': 'Position',
          'description':
              'Start in push-up position but rest on forearms instead of hands.'
        },
        {
          'title': 'Hold',
          'description':
              'Keep body in straight line from head to heels, engage core muscles.'
        },
        {
          'title': 'Breathe',
          'description':
              'Maintain position while breathing normally, avoid sagging or lifting hips.'
        },
      ];
    } else {
      // Generic instructions for unknown exercises
      return [
        {
          'title': 'Preparation',
          'description':
              'Set up equipment and position yourself with proper form and posture.'
        },
        {
          'title': 'Execution',
          'description':
              'Perform the movement with controlled tempo, focusing on target muscles.'
        },
        {
          'title': 'Recovery',
          'description':
              'Return to starting position with control, maintain good form throughout.'
        },
      ];
    }
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
