# Technical Context

## Architecture Stack

### Core Technologies

- **Framework**: Flutter 3.0+ (Dart SDK >=3.0.0)
- **Database**: Hive 2.2.3 (Local NoSQL with type adapters)
- **State Management**: Provider 6.1.1 (Riverpod planned for future)
- **Navigation**: GoRouter 13.2.0
- **Storage**: path_provider for local file system access

### Key Dependencies

```yaml
# Database & Storage
hive: ^2.2.3
hive_flutter: ^1.1.0
path_provider: ^2.1.2
uuid: ^4.3.3

# Navigation & State
go_router: ^13.2.0
provider: ^6.1.1

# UI Components
flutter_speed_dial: ^7.0.0
table_calendar: ^3.0.9
percent_indicator: ^4.2.3
flutter_slidable: ^3.0.1

# Utils
intl: ^0.19.0
shared_preferences: ^2.2.2
```

### Database Schema (Hive Boxes)

#### Core Models with Type IDs:

- **UserProfile** (0): name, height, weight, goals
- **MuscleGroup** (1): muscle group definitions
- **Exercise** (2): exercise library with muscle group mapping
- **WeeklyPlan** (3): daily workout assignments
- **WorkoutLog** (4): completed workout sessions
- **WorkoutEntry** (5): individual exercise completion records
- **AppSettings** (6): theme, units, notifications
- **Streak** (7): daily consistency tracking

#### Box Names:

- `userProfile`: Single user profile
- `muscleGroups`: Predefined muscle groups
- `exercises`: Exercise library
- `weeklyPlan`: Weekly workout schedule
- `workoutLogs`: Historical workout data
- `appSettings`: User preferences
- `streaks`: Daily workout completion

## Current Implementation Status

### ✅ Implemented Features

1. **App Structure**: Main app with Material 3 theming
2. **Database Service**: Complete Hive setup with all models
3. **Navigation**: GoRouter with all main routes
4. **Home Screen**: Basic layout with today's workout card
5. **Workout Screen**: Session tracking with timer
6. **Exercise Management**: Basic CRUD operations
7. **Data Models**: All core models with Hive adapters

### 🔄 Partially Implemented

1. **Workout Session Flow**: Basic structure, needs refinement
2. **Exercise Selection**: Dialog exists but needs enhancement
3. **Streak Calculation**: Logic exists, needs UI integration

### ❌ Missing Features

1. **Weekly Plan Setup**: Day-specific workout assignments
2. **Settings Screen**: Theme toggle, profile management
3. **Exercise Library Screen**: Full CRUD interface
4. **Pre-populated Data**: Default exercises and muscle groups
5. **Streak UI**: Visual streak counter and history
6. **Workout Timer**: Enhanced timer with rest periods

## Code Organization

### Directory Structure

```
lib/
├── config/
│   └── router.dart              # GoRouter configuration
├── models/
│   ├── adapters/                # Custom Hive adapters
│   └── *.dart                   # Data models with Hive annotations
├── screens/
│   └── *.dart                   # UI screens (Home, Workout, etc.)
├── services/
│   ├── hive_service.dart        # Database operations
│   ├── database_service.dart    # Additional DB utilities
│   └── workout_service.dart     # Workout-specific logic
├── utils/
│   └── constants.dart           # Type IDs and box names
└── widgets/
    └── *.dart                   # Reusable UI components
```

### Code Quality Notes

- Some duplicate code in models (workout.dart has conflicting Exercise class)
- Error in hive_service.dart line 95 - missing proper Exercise filtering
- Needs consistent error handling and validation
- Build runner setup for Hive code generation
