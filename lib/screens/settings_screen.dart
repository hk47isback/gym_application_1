import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/user_profile.dart';
import '../models/app_settings.dart';
import '../services/hive_service.dart';
import '../widgets/profile_edit_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _hiveService = HiveService();
  late AppSettings _settings;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadUserProfile();
  }

  void _loadSettings() {
    _settings = _hiveService.getAppSettings();
  }

  void _loadUserProfile() {
    _userProfile = _hiveService.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // User Profile Section
          _buildProfileSection(),
          const Divider(),

          // App Settings Section
          _buildAppSettingsSection(),
          const Divider(),

          // Data Management Section
          _buildDataSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Profile',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(_userProfile?.name ?? 'Set up your profile'),
          subtitle: _userProfile != null
              ? Text(
                  '${_userProfile!.heightCm} cm • ${_userProfile!.weightKg} kg')
              : const Text('Add your details'),
          trailing: const Icon(Icons.edit),
          onTap: _editProfile,
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'App Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: _settings.darkMode,
          onChanged: (value) {
            setState(() {
              _settings = AppSettings(
                darkMode: value,
                notificationsEnabled: _settings.notificationsEnabled,
                useMetric: _settings.useMetric,
              );
            });
            _hiveService.saveAppSettings(_settings);
          },
        ),
        SwitchListTile(
          title: const Text('Notifications'),
          subtitle: const Text('Workout reminders'),
          value: _settings.notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _settings = AppSettings(
                darkMode: _settings.darkMode,
                notificationsEnabled: value,
                useMetric: _settings.useMetric,
              );
            });
            _hiveService.saveAppSettings(_settings);
          },
        ),
        SwitchListTile(
          title: const Text('Use Metric Units'),
          subtitle: const Text('kg/cm instead of lb/in'),
          value: _settings.useMetric,
          onChanged: (value) {
            setState(() {
              _settings = AppSettings(
                darkMode: _settings.darkMode,
                notificationsEnabled: _settings.notificationsEnabled,
                useMetric: value,
              );
            });
            _hiveService.saveAppSettings(_settings);
          },
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Data Management',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text('Workout Statistics'),
          subtitle: Text(
              '${_hiveService.getAllWorkoutLogs().length} workouts completed'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            _showWorkoutStatistics(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Export Data'),
          subtitle: const Text('Backup your workout data'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            _exportWorkoutData();
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_sweep, color: Colors.red),
          title:
              const Text('Clear All Data', style: TextStyle(color: Colors.red)),
          subtitle: const Text('Reset app to initial state'),
          onTap: _showClearDataDialog,
        ),
      ],
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => ProfileEditDialog(
        currentProfile: _userProfile,
        onSave: (profile) {
          setState(() {
            _userProfile = profile;
          });
          _hiveService.saveUserProfile(profile);
        },
      ),
    );
  }

  void _showWorkoutStatistics(BuildContext context) {
    final workoutLogs = _hiveService.getAllWorkoutLogs();
    final totalWorkouts = workoutLogs.length;
    final currentStreak = _hiveService.getCurrentStreak();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Total Workouts', '$totalWorkouts'),
            _buildStatRow('Current Streak', '$currentStreak days'),
            _buildStatRow(
                'Total Exercises', '${_hiveService.getAllExercises().length}'),
            const SizedBox(height: 16),
            if (workoutLogs.isNotEmpty) ...[
              const Text('Recent Activity:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...workoutLogs.take(3).map((log) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                        '${log.date.toString().split(' ')[0]} - ${log.exercises.length} exercises'),
                  )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _exportWorkoutData() async {
    try {
      final workoutLogs = _hiveService.getAllWorkoutLogs();
      final exercises = _hiveService.getAllExercises();

      final exportData = {
        'export_date': DateTime.now().toIso8601String(),
        'total_workouts': workoutLogs.length,
        'total_exercises': exercises.length,
        'current_streak': _hiveService.getCurrentStreak(),
        'workouts': workoutLogs
            .map((log) => {
                  'date': log.date.toIso8601String(),
                  'exercises_completed': log.exercises.length,
                  'mood': log.mood,
                })
            .toList(),
      };

      // For now, just show a success message with data summary
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Summary'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data ready for export:'),
                SizedBox(height: 8),
                Text('• ${workoutLogs.length} workout sessions'),
                Text('• ${exercises.length} exercises in library'),
                Text('• ${_hiveService.getCurrentStreak()} day current streak'),
                SizedBox(height: 16),
                Text('Feature coming soon: Save to file',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your workout data, progress, and settings. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Clear all Hive boxes
                await _hiveService.workoutLogsBox.clear();
                await _hiveService.streaksBox.clear();
                await _hiveService.userProfileBox.clear();

                Navigator.of(context).pop();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ All workout data cleared successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Refresh the screen
                  setState(() {
                    _loadSettings();
                    _loadUserProfile();
                  });
                }
              } catch (e) {
                Navigator.of(context).pop();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to clear data: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }
}
