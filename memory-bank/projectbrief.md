# Project Brief: Gym Tracker - ADHD-Friendly, Offline-First

## Core Purpose

A minimalist mobile app designed to help users (especially ADHD-prone individuals) stick to a 5-day gym routine by removing friction, tracking progress offline, and staying focused without decisions or distractions.

## Key Requirements

### Functional Requirements

- **5-day workout tracking** with predefined routines
- **Offline-first operation** - no server dependency
- **Minimal decision fatigue** - clear, single-purpose screens
- **Progress tracking** with streak counting
- **Exercise library management**
- **Workout session recording** (sets, reps, weights)

### Non-Functional Requirements

- **ADHD-friendly design** - checkbox-style completion, calm colors
- **Fast access/exit** - quick workflow, no barriers
- **Cross-platform support** - Flutter for iOS/Android
- **Local data storage** - Hive NoSQL database
- **No signup required** - privacy-first approach

## Success Criteria

- Users can complete a workout session in < 2 minutes setup time
- Zero decision points during active workout
- 100% offline functionality
- Streak tracking motivates consistency
- Clean, distraction-free interface

## Technical Constraints

- Flutter framework (Dart language)
- Hive local database (no server)
- Provider/Riverpod for state management
- Material Design 3 with light/dark themes
- Android-first deployment, iOS later
