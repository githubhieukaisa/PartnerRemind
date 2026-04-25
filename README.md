# PartnerRemind

Desktop-first Flutter app for focused study sessions with precise timing,
break-time banking, daily reset automation, and local persistence.

## Overview

PartnerRemind is designed for Windows, macOS, and Linux with desktop-native
behavior in mind:

- Window controls and compact always-on-top mode
- Precision timer that remains accurate with sleep/wake cycles
- Subject-based study tracking and session history
- Local-first data storage with Isar
- System tray integration for background workflow

## Key Features

- Precision timer:
  - Stopwatch mode
  - Study countdown mode
  - Break countdown mode
- Break Time Bank:
  - Accumulates break time from study ratio
  - Real-time persistence to local database
- Daily reset at 00:00:
  - Automatic catch-up logic after app downtime
  - Reset policies: reset, keep all, keep partial
- Subject management:
  - Per-subject daily target tracking
  - Carry-over surplus/debt from previous day
- Desktop UX:
  - Custom title bar
  - Compact mode for minimal on-screen presence
  - System tray show/hide/quit actions

## Tech Stack

- Flutter + Dart 3
- Riverpod (state management)
- Isar (local database)
- window_manager (desktop window control)
- system_tray (tray integration)
- audioplayers (alarm feedback)

## Project Structure

```text
lib/
	main.dart
	models/         # timer state, subjects, logs, reset snapshots
	providers/      # Riverpod notifiers/providers
	persistence/    # Isar service and DB access
	services/       # window, tray, daily reset
	screens/        # app shell and tab pages
	widgets/        # reusable UI components
```

## Requirements

- Flutter SDK (stable)
- Dart SDK compatible with pubspec constraint
- Desktop toolchain for your target platform

### Windows

- Visual Studio 2022 with "Desktop development with C++"
- CMake + Ninja (normally bundled with Flutter tooling setup)

### macOS

- Xcode + command line tools

### Linux

- GCC/Clang, CMake, Ninja, GTK development packages

## Quick Start

```bash
flutter pub get
flutter run -d windows
```

Use `-d macos` or `-d linux` for other desktop targets.

## Build

```bash
flutter build windows
flutter build macos
flutter build linux
```

## Development Notes

- State logic is routed through Riverpod providers in `lib/providers`.
- Persistence is centralized in `IsarService` under `lib/persistence`.
- Daily reset scheduling and catch-up behavior live in
  `lib/services/daily_reset_service.dart`.
- Window sizing and compact mode behavior live in
  `lib/services/window_management_service.dart`.

## Useful Commands

```bash
# Analyze
flutter analyze

# Run tests
flutter test

# Regenerate Isar adapters if models change
flutter pub run build_runner build --delete-conflicting-outputs
```

## Troubleshooting

- Build fails on Windows:
  - Confirm Visual Studio C++ workload is installed.
- Generated model errors:
  - Re-run build_runner command shown above.
- App starts but data looks reset:
  - Verify local Isar path permissions for your OS profile directory.

## License

This project is licensed under the MIT License. See LICENSE for details.
