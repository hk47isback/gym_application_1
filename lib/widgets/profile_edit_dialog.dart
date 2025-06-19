import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileEditDialog extends StatefulWidget {
  final UserProfile? currentProfile;
  final Function(UserProfile) onSave;

  const ProfileEditDialog({
    super.key,
    this.currentProfile,
    required this.onSave,
  });

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String _selectedGoal = 'Fat Loss';

  final _goals = [
    'Fat Loss',
    'Muscle Gain',
    'Strength',
    'Maintenance',
    'General Fitness',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentProfile?.name);
    _heightController = TextEditingController(
      text: widget.currentProfile?.heightCm.toString(),
    );
    _weightController = TextEditingController(
      text: widget.currentProfile?.weightKg.toString(),
    );
    if (widget.currentProfile?.goal != null) {
      _selectedGoal = widget.currentProfile!.goal;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit Profile', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGoal,
              decoration: const InputDecoration(
                labelText: 'Goal',
                border: OutlineInputBorder(),
              ),
              items: _goals
                  .map(
                    (goal) => DropdownMenuItem(value: goal, child: Text(goal)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedGoal = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final height = double.tryParse(_heightController.text) ?? 0;
                    final weight = double.tryParse(_weightController.text) ?? 0;

                    if (_nameController.text.isEmpty ||
                        height <= 0 ||
                        weight <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields correctly'),
                        ),
                      );
                      return;
                    }

                    final profile = UserProfile(
                      name: _nameController.text,
                      heightCm: height,
                      weightKg: weight,
                      goal: _selectedGoal,
                      createdAt:
                          widget.currentProfile?.createdAt ?? DateTime.now(),
                    );

                    widget.onSave(profile);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
