@echo off
echo Running Hive code generation...
flutter pub run build_runner build --delete-conflicting-outputs
echo Done!
