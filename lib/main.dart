import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'services/hive_service.dart';
import 'services/data_initialization_service.dart';
import 'config/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('🚀 Starting app initialization...');

    // Initialize Hive first
    await HiveService().init();
    print('✅ Hive initialization completed');

    // Initialize default data
    await DataInitializationService().initializeDefaultData();
    print('✅ Default data initialization completed');

    print('🎉 App initialization successful');
  } catch (e) {
    print('❌ Initialization error: $e');
    // Continue anyway to show the app, even if initialization failed
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gym Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
