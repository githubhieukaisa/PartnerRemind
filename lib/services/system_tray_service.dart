import 'dart:io';

import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

/// System tray integration service
/// Handles minimizing to tray and tray interactions
class SystemTrayService {
  static final SystemTrayService _instance = SystemTrayService._internal();
  late SystemTray systemTray;
  late Menu menu;
  bool _isInitialized = false;

  factory SystemTrayService() {
    return _instance;
  }

  SystemTrayService._internal();

  /// Initialize system tray
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      systemTray = SystemTray();

      // Set tray menu
      await _setupTrayMenu();

      _isInitialized = true;
      print('✅ System tray initialized');
    } catch (e) {
      print('❌ Error initializing system tray: $e');
    }
  }

  /// Setup tray context menu
  Future<void> _setupTrayMenu() async {
    // Create tray icon
    final String path = Platform.isWindows
        ? 'assets/app_icon.ico'
        : 'assets/app_icon.png';
    await systemTray.initSystemTray(title: "PartnerRemind", iconPath: path);

    systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        _showWindow();
      }
    });
    // Create menu items
    menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show', onClicked: (menuItem) => _showWindow()),
      MenuItemLabel(label: 'Hide', onClicked: (menuItem) => _hideWindow()),
      MenuSeparator(),
      MenuItemLabel(label: 'Quit', onClicked: (menuItem) => _quitApp()),
    ]);

    await systemTray.setContextMenu(menu);
  }

  /// Show window from tray
  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
    print('👁️ Window shown from tray');
  }

  /// Hide window to tray
  Future<void> _hideWindow() async {
    await windowManager.hide();
    print('👁️ Window hidden to tray');
  }

  /// Quit application
  Future<void> _quitApp() async {
    await windowManager.close();
  }

  /// Minimize window to tray
  Future<void> minimizeToTray() async {
    if (!_isInitialized) {
      await initialize();
    }
    await _hideWindow();
  }

  /// Show from tray
  Future<void> showFromTray() async {
    await _showWindow();
  }

  /// Check if tray is available
  bool get isAvailable => _isInitialized;

  /// Cleanup
  void dispose() {
    // Cleanup tray if needed
  }
}
