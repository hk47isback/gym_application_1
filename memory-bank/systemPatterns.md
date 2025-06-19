# System Patterns & Architecture

## Design Patterns

### Data Layer Pattern

- **Repository Pattern**: HiveService acts as central data repository
- **Model-First Design**: Hive models drive database schema
- **Type Safety**: Hive adapters for compile-time type checking
- **Reactive Data**: ValueListenable for UI updates

### Navigation Pattern

- **Declarative Routing**: GoRouter with path-based navigation
- **Screen Isolation**: Each screen is self-contained
- **Deep Linking Ready**: URL-based navigation structure

### State Management Approach

- **Provider Pattern**: Currently using Provider for state
- **Future Riverpod**: Planned migration for better separation
- **Local State**: StatefulWidget for screen-specific state
- **Persistent State**: Hive boxes for data persistence

## Key Architectural Decisions

### 1. Offline-First Architecture

**Decision**: Use Hive local database instead of remote backend
**Rationale**:

- ADHD users need immediate access without connection dependencies
- Privacy-first approach (no user accounts)
- Faster performance for workout tracking
- Simplified deployment and maintenance

### 2. Flutter Single Codebase

**Decision**: Flutter for cross-platform development
**Rationale**:

- Single codebase for iOS/Android
- Rich UI capabilities for fitness tracking
- Good performance for local data operations
- Strong ecosystem for required packages

### 3. Minimal Navigation Hierarchy

**Decision**: Flat navigation structure with GoRouter
**Routes**:

```
/ (Home)
├── /workout (Active session)
├── /exercises (Library management)
├── /exercises/:id (Exercise details)
└── /settings (User preferences)
```

**Rationale**: Reduces cognitive load for ADHD users

### 4. Component Architecture

#### Core Components:

1. **HiveService**: Central data access layer
2. **Screen Widgets**: UI presentation layer
3. **Model Classes**: Data structure definitions
4. **Service Classes**: Business logic layer

#### Data Flow:

```
UI Screen → HiveService → Hive Box → Local Storage
     ↑                                        ↓
UI Updates ← ValueListenable ← Box Changes ←
```

### 5. Code Generation Strategy

**Decision**: Use Hive code generation for type adapters
**Benefits**:

- Compile-time type safety
- Automatic serialization/deserialization
- Reduced boilerplate code
- Better maintainability

**Build Command**: `flutter packages pub run build_runner build`

## Error Handling Patterns

### Database Operations

- Graceful fallbacks for missing data
- Default values in getters (e.g., AppSettings)
- Validation before saving

### UI Error States

- Loading indicators for async operations
- Empty state handling
- User-friendly error messages

## Performance Considerations

### Memory Management

- Hive lazy loading for large datasets
- Proper disposal of listeners
- Efficient list building with ListView.builder

### Storage Optimization

- Indexed access for frequent queries
- Minimal data duplication
- Efficient DateTime handling for streaks

## Future Architecture Plans

### State Management Evolution

**Current**: Provider with StatefulWidget
**Planned**: Riverpod with proper separation of concerns
**Benefits**: Better testability, clearer data flow, reduced rebuilds

### Service Layer Enhancement

**Planned**: Dedicated service classes for:

- WorkoutService: Session management logic
- StreakService: Consistency tracking
- ExerciseService: Library management
- NotificationService: Reminder system
