import 'dart:ui' show Size, Offset;
import 'package:window_manager/window_manager.dart';

/// Window management service for desktop app control
/// Handles window positioning, sizing, always-on-top, and state persistence
class WindowManagementService {
  static final WindowManagementService _instance =
      WindowManagementService._internal();

  factory WindowManagementService() {
    return _instance;
  }

  WindowManagementService._internal();

  /// Initialize window manager (call once at app startup)
  static Future<void> initialize() async {
    await windowManager.ensureInitialized();

    /// Configure initial window properties
    const windowOptions = WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(600, 400),
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // Use custom title bar
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    print('✅ Window manager initialized');
  }

  /// Enable always-on-top mode (compact study mode)
  Future<void> enableAlwaysOnTop() async {
    try {
      await windowManager.setAlwaysOnTop(true);
      print('📌 Always-on-top enabled');
    } catch (e) {
      print('❌ Error enabling always-on-top: $e');
    }
  }

  /// Disable always-on-top mode
  Future<void> disableAlwaysOnTop() async {
    try {
      await windowManager.setAlwaysOnTop(false);
      print('📌 Always-on-top disabled');
    } catch (e) {
      print('❌ Error disabling always-on-top: $e');
    }
  }

  /// Check if always-on-top is active
  Future<bool> isAlwaysOnTop() async {
    try {
      return await windowManager.isAlwaysOnTop();
    } catch (e) {
      print('❌ Error checking always-on-top: $e');
      return false;
    }
  }

  /// Minimize window to background
  Future<void> minimizeWindow() async {
    try {
      await windowManager.minimize();
      print('👇 Window minimized');
    } catch (e) {
      print('❌ Error minimizing window: $e');
    }
  }

  /// Maximize window
  Future<void> maximizeWindow() async {
    try {
      await windowManager.maximize();
      print('📈 Window maximized');
    } catch (e) {
      print('❌ Error maximizing window: $e');
    }
  }

  /// Restore window to normal size
  Future<void> restoreWindow() async {
    try {
      await windowManager.restore();
      print('📦 Window restored');
    } catch (e) {
      print('❌ Error restoring window: $e');
    }
  }

  /// Close the window/app
  Future<void> closeWindow() async {
    try {
      await windowManager.close();
      print('✖️ Window closed');
    } catch (e) {
      print('❌ Error closing window: $e');
    }
  }

  /// Get current window size
  Future<Size> getWindowSize() async {
    try {
      return await windowManager.getSize();
    } catch (e) {
      print('❌ Error getting window size: $e');
      return const Size(1200, 800);
    }
  }

  /// Set window size
  Future<void> setWindowSize(Size size) async {
    try {
      await windowManager.setSize(size);
      print('📐 Window size set to ${size.width}x${size.height}');
    } catch (e) {
      print('❌ Error setting window size: $e');
    }
  }

  /// Get current window position
  Future<Offset> getWindowPosition() async {
    try {
      return await windowManager.getPosition();
    } catch (e) {
      print('❌ Error getting window position: $e');
      return Offset.zero;
    }
  }

  /// Set window position
  Future<void> setWindowPosition(Offset position) async {
    try {
      await windowManager.setPosition(position);
      print('📍 Window position set to ${position.dx},${position.dy}');
    } catch (e) {
      print('❌ Error setting window position: $e');
    }
  }

  /// Set compact mode (reduced window for studying)
  /// Window becomes a horizontal bar at top of screen
  Future<void> setCompactStudyMode() async {
    try {
      const compactHeight = 100.0;
      final screenSize = await _getScreenSize();

      // Position at top center of screen
      await windowManager.setSize(const Size(800, compactHeight));
      await windowManager.setPosition(Offset((screenSize.width - 800) / 2, 0));
      await windowManager.setAlwaysOnTop(true);

      print('📊 Compact study mode activated');
    } catch (e) {
      print('❌ Error setting compact mode: $e');
    }
  }

  /// Return to normal mode from compact study mode
  Future<void> setNormalMode() async {
    try {
      await windowManager.setAlwaysOnTop(false);
      await windowManager.setSize(const Size(1200, 800));
      await windowManager.center();

      print('📖 Normal mode activated');
    } catch (e) {
      print('❌ Error setting normal mode: $e');
    }
  }

  /// Get approximate screen size (for positioning)
  Future<Size> _getScreenSize() async {
    // Note: This is a simplified version
    // In production, you'd use a screen utility package
    return const Size(1920, 1080); // Default to common 1080p
  }

  /// Check if window is visible
  Future<bool> isWindowVisible() async {
    try {
      return await windowManager.isVisible();
    } catch (e) {
      print('❌ Error checking window visibility: $e');
      return true;
    }
  }

  /// Show window
  Future<void> showWindow() async {
    try {
      await windowManager.show();
      print('👁️ Window shown');
    } catch (e) {
      print('❌ Error showing window: $e');
    }
  }

  /// Hide window (but keep running in background)
  Future<void> hideWindow() async {
    try {
      await windowManager.hide();
      print('👁️ Window hidden');
    } catch (e) {
      print('❌ Error hiding window: $e');
    }
  }

  /// Set window as focused
  Future<void> focusWindow() async {
    try {
      await windowManager.focus();
      print('🎯 Window focused');
    } catch (e) {
      print('❌ Error focusing window: $e');
    }
  }
}
