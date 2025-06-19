# 🏋️ Gym Tracker - ADHD-Friendly Fitness App

An offline-first, minimalist mobile app designed to help users (especially ADHD-prone individuals) stick to a 5-day gym routine by removing friction, tracking progress, and maintaining focus without distractions.

## ✨ Features

### 🎯 Core Functionality

- **5-Day Workout Tracking** - Predefined weekly routines (Monday-Friday)
- **Offline-First Operation** - No server dependency, works without internet
- **Progress Tracking** - Streak counting and workout history
- **Exercise Library** - Comprehensive database with 33+ exercises
- **Smart Timer** - Workout session timing with pause/resume/reset controls
- **Completion Tracking** - Set-by-set progress with checkboxes

### 🧠 ADHD-Friendly Design

- **Minimal Decision Fatigue** - Clear, single-purpose screens
- **Checkbox-Style Completion** - Satisfying progress indicators
- **Calm Color Scheme** - Blues and soft oranges for focus
- **Fast Access/Exit** - Quick workflow, no barriers
- **Zero Signup Required** - Privacy-first approach

### 📱 User Interface

- **Today's Workout Display** - Shows current day and planned exercises
- **Streak Counter** - Visual fire emoji with consecutive workout days
- **Exercise Management** - Add, edit, delete exercises with swipe actions
- **Settings Panel** - Theme toggle, profile management, units preference
- **Smart Navigation** - Consistent back buttons with exit confirmation

## 🔧 Technical Stack

- **Framework**: Flutter 3.32.4 (Dart 3.8.1)
- **Database**: Hive 2.2.3 (Local NoSQL)
- **State Management**: Provider 6.1.1
- **Navigation**: GoRouter 13.2.0
- **Platform**: Cross-platform (iOS, Android, Web)

## 📁 Project Structure

```
lib/
├── config/
│   └── router.dart              # GoRouter configuration
├── models/
│   ├── adapters/                # Custom Hive adapters
│   └── *.dart                   # Data models with Hive annotations
├── screens/
│   ├── home_screen.dart         # Main dashboard
│   ├── workout_screen.dart      # Active workout session
│   ├── exercise_library_screen.dart # Exercise management
│   └── settings_screen.dart     # User preferences
├── services/
│   ├── hive_service.dart        # Database operations
│   ├── data_initialization_service.dart # Default data setup
│   └── workout_service.dart     # Workout-specific logic
├── widgets/
│   ├── workout_timer.dart       # Session timer with controls
│   ├── exercise_selection_dialog.dart # Exercise picker
│   └── profile_edit_dialog.dart # User profile editor
└── utils/
    └── constants.dart           # Type IDs and box names
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/gym-tracker.git
   cd gym-tracker
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**

   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**

   ```bash
   # Web
   flutter run -d chrome

   # Android
   flutter run -d android

   # iOS
   flutter run -d ios
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS App
flutter build ios --release

# Web
flutter build web --release
```

## 📊 Weekly Workout Plan

The app comes with a predefined 5-day split:

- **Monday**: Chest & Triceps
- **Tuesday**: Back & Biceps
- **Wednesday**: Legs
- **Thursday**: Shoulders
- **Friday**: Arms & Core
- **Weekend**: Rest Days

## 🎮 How to Use

1. **Start the App** - Automatic data initialization on first launch
2. **View Today's Workout** - See planned exercises for current day
3. **Start Workout** - Begin session with automatic timer
4. **Add Exercises** - Quick-add from today's plan or browse full library
5. **Track Progress** - Check off sets, enter reps and weights
6. **Complete Workout** - Finish session and update streak
7. **Manage Exercises** - Browse, add, edit exercises in library
8. **Customize Settings** - Theme, profile, units preferences

## 🏗️ Architecture

### Data Layer

- **Repository Pattern** with HiveService as central data access
- **Type-Safe Models** with Hive code generation
- **Reactive Updates** using ValueListenable

### Navigation

- **Declarative Routing** with GoRouter
- **Deep Linking Ready** URL-based structure
- **Screen Isolation** for maintainability

### State Management

- **Provider Pattern** for app-wide state
- **Local State** with StatefulWidget for screen-specific data
- **Persistent Storage** with Hive boxes

## 🎯 Success Metrics

The app is designed for:

- **Session Completion Rate**: >85% of started workouts finished
- **Weekly Consistency**: >60% of users hit 4+ workouts/week
- **Session Setup Time**: <60 seconds from app open to first exercise
- **Cognitive Load**: Zero decision points during workout

## 🔄 Future Enhancements

- **Progressive Overload Suggestions**
- **Apple Health Integration**
- **Custom Routine Builder**
- **Enhanced Analytics**
- **Rest Period Notifications**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have suggestions, please open an issue on GitHub.

---

**Built with ❤️ for the fitness community**
