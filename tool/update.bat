@echo off
cd /d "f:\Gym App\New folder\gym_application_1"
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
