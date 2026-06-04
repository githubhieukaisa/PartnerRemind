import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'persistence/isar_service.dart';
import 'services/daily_reset_service.dart';
import 'services/window_management_service.dart';
import 'providers/precision_timer_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager (desktop platform)
  try {
    await WindowManagementService.initialize();
    print('✅ Window manager initialized');
  } catch (e) {
    print('❌ Error initializing window manager: $e');
  }

  // Initialize Isar database
  try {
    await IsarService.initialize();
    print('✅ Isar database initialized successfully');
  } catch (e) {
    print('❌ Error initializing Isar: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initPreventClose();
  }

  Future<void> _initPreventClose() async {
    await windowManager.setPreventClose(true);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    print('🚪 Window close event detected. Performing auto-save...');
    
    // Hide the window immediately so the user feels it closed instantly
    await windowManager.hide();
    
    try {
      // Access the timer notifier to stop and save the current session.
      // This internally calls saveStudySession which saves to Isar.
      final timerNotifier = ref.read(
        precisionTimerProvider.notifier,
      );
      await timerNotifier.stop();

      print('✅ Auto-save complete. Exiting app.');
    } catch (e) {
      print('❌ Error during auto-save on exit: $e');
    }

    // Forcefully destroy the window and exit the application
    await windowManager.destroy();
  }

  @override
  Widget build(BuildContext context) {
    // Eager-initialize daily reset service at app startup.
    ref.read(dailyResetServiceProvider);

    return MaterialApp(
      title: 'PartnerRemind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        cardTheme: const CardThemeData(elevation: 2, margin: EdgeInsets.zero),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
