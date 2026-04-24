import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'persistence/isar_service.dart';
import 'services/daily_reset_service.dart';
import 'services/window_management_service.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
