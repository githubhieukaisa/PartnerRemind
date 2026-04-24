import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/window_management_service.dart';

/// Window state - tracks compact mode and other window properties
class WindowState {
  final bool isCompactMode;
  final bool isAlwaysOnTop;

  const WindowState({this.isCompactMode = false, this.isAlwaysOnTop = false});

  WindowState copyWith({bool? isCompactMode, bool? isAlwaysOnTop}) {
    return WindowState(
      isCompactMode: isCompactMode ?? this.isCompactMode,
      isAlwaysOnTop: isAlwaysOnTop ?? this.isAlwaysOnTop,
    );
  }
}

/// Window state notifier
class WindowStateNotifier extends StateNotifier<WindowState> {
  final WindowManagementService _windowService = WindowManagementService();

  WindowStateNotifier() : super(const WindowState());

  /// Toggle compact study mode
  Future<void> toggleCompactMode() async {
    final newState = !state.isCompactMode;

    if (newState) {
      await _windowService.setCompactStudyMode();
    } else {
      await _windowService.setNormalMode();
    }

    state = state.copyWith(isCompactMode: newState);
  }

  /// Toggle always-on-top
  Future<void> toggleAlwaysOnTop() async {
    final newState = !state.isAlwaysOnTop;

    if (newState) {
      await _windowService.enableAlwaysOnTop();
    } else {
      await _windowService.disableAlwaysOnTop();
    }

    state = state.copyWith(isAlwaysOnTop: newState);
  }

  /// Minimize window
  Future<void> minimizeWindow() async {
    await _windowService.minimizeWindow();
  }

  /// Maximize window
  Future<void> maximizeWindow() async {
    await _windowService.maximizeWindow();
  }

  /// Close window
  Future<void> closeWindow() async {
    await _windowService.closeWindow();
  }

  /// Set compact mode directly
  Future<void> setCompactMode(bool value) async {
    if (value != state.isCompactMode) {
      await toggleCompactMode();
    }
  }
}

/// Riverpod provider for window state
final windowStateProvider =
    StateNotifierProvider<WindowStateNotifier, WindowState>(
      (ref) => WindowStateNotifier(),
    );
