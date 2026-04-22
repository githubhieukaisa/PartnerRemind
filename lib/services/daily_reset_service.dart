import 'dart:async';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../persistence/isar_service.dart';
import '../models/daily_reset.dart';

/// Service to handle daily reset logic at 00:00
class DailyResetService {
  static final DailyResetService _instance = DailyResetService._internal();
  Timer? _resetTimer;
  final List<VoidCallback> _resetListeners = [];

  factory DailyResetService() {
    return _instance;
  }

  DailyResetService._internal();

  /// Initialize the daily reset scheduler
  void initialize() {
    _scheduleNextReset();
  }

  /// Add listener for reset events
  void addResetListener(VoidCallback callback) {
    _resetListeners.add(callback);
  }

  /// Remove listener
  void removeResetListener(VoidCallback callback) {
    _resetListeners.remove(callback);
  }

  /// Notify all listeners of reset
  void _notifyResetListeners() {
    for (var listener in _resetListeners) {
      listener();
    }
  }

  /// Schedule the next 00:00 reset
  void _scheduleNextReset() {
    _resetTimer?.cancel();

    final now = DateTime.now();
    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    final durationUntilReset = tomorrow.difference(now);

    print('📅 Daily reset scheduled for ${tomorrow.toString()}');

    _resetTimer = Timer(durationUntilReset, () {
      _performDailyReset();
      _scheduleNextReset(); // Reschedule for next day
    });
  }

  /// Perform the actual daily reset
  Future<void> _performDailyReset() async {
    try {
      print('🔄 Performing daily reset at ${DateTime.now()}');

      final isarService = IsarService();

      // Get current break bank state before reset
      final breakBankSnapshot = await isarService.getBreakBankSnapshot();
      final breakTimeBeforeReset = breakBankSnapshot.totalBreakSeconds;

      // Get all subjects before reset
      final subjects = await isarService.getAllSubjects();
      final subjectDataBefore = subjects
          .map((s) => '${s.name}: ${s.studyTimeToday}m')
          .toList();

      // Check if there's already a reset for today
      final todayReset = await isarService.getTodayDailyReset();
      if (todayReset != null) {
        print('ℹ️ Reset already performed for today');
        return;
      }

      // Get daily reset preference
      String resetAction = breakBankSnapshot.dailyResetPreference;
      int breakTimeAfterReset = 0;

      // Apply reset based on preference
      switch (resetAction) {
        case 'keep_all':
          // Keep all break time
          breakTimeAfterReset = breakTimeBeforeReset;
          break;
        case 'keep_partial':
          // Keep only partial break time (if specified)
          if (breakBankSnapshot.partialResetMinutes != null) {
            breakTimeAfterReset = (breakBankSnapshot.partialResetMinutes! * 60)
                .toInt();
          }
          break;
        case 'reset':
        default:
          // Reset to zero
          breakTimeAfterReset = 0;
      }

      // Update break bank with new value
      breakBankSnapshot.totalBreakSeconds = breakTimeAfterReset;
      await isarService.updateBreakBankSnapshot(breakBankSnapshot);

      // Reset all subjects' daily study times
      await isarService.resetAllSubjectsDailyTime();

      // Log the reset action
      final dailyReset = DailyReset(
        resetDate: DateTime.now(),
        action: resetAction,
        breakTimeBeforeReset: breakTimeBeforeReset,
        breakTimeAfterReset: breakTimeAfterReset,
        keptBreakSeconds: resetAction == 'keep_partial'
            ? breakBankSnapshot.partialResetMinutes! * 60
            : null,
        isManual: false,
      );
      dailyReset.subjectDataBeforeReset = subjectDataBefore;

      await isarService.addDailyReset(dailyReset);

      print(
        '✅ Daily reset completed: break_before=$breakTimeBeforeReset, break_after=$breakTimeAfterReset, action=$resetAction',
      );

      // Notify listeners to update UI
      _notifyResetListeners();
    } catch (e) {
      print('❌ Error performing daily reset: $e');
    }
  }

  /// Manual reset (user-triggered)
  Future<void> manualReset({
    required String action,
    int? partialBreakMinutes,
  }) async {
    try {
      print('👤 Performing manual reset with action: $action');

      final isarService = IsarService();

      // Get current state before reset
      final breakBankSnapshot = await isarService.getBreakBankSnapshot();
      final breakTimeBeforeReset = breakBankSnapshot.totalBreakSeconds;

      // Get all subjects
      final subjects = await isarService.getAllSubjects();
      final subjectDataBefore = subjects
          .map((s) => '${s.name}: ${s.studyTimeToday}m')
          .toList();

      // Update reset preference
      breakBankSnapshot.dailyResetPreference = action;
      if (action == 'keep_partial' && partialBreakMinutes != null) {
        breakBankSnapshot.partialResetMinutes = partialBreakMinutes;
      }

      // Calculate new break time
      int breakTimeAfterReset = 0;
      switch (action) {
        case 'keep_all':
          breakTimeAfterReset = breakTimeBeforeReset;
          break;
        case 'keep_partial':
          if (partialBreakMinutes != null) {
            breakTimeAfterReset = (partialBreakMinutes * 60).toInt();
          }
          break;
        case 'reset':
        default:
          breakTimeAfterReset = 0;
      }

      // Apply reset
      breakBankSnapshot.totalBreakSeconds = breakTimeAfterReset;
      await isarService.updateBreakBankSnapshot(breakBankSnapshot);

      // Reset subjects
      await isarService.resetAllSubjectsDailyTime();

      // Log the manual reset
      final dailyReset = DailyReset(
        resetDate: DateTime.now(),
        action: action,
        breakTimeBeforeReset: breakTimeBeforeReset,
        breakTimeAfterReset: breakTimeAfterReset,
        keptBreakSeconds: action == 'keep_partial'
            ? (partialBreakMinutes ?? 0) * 60
            : null,
        isManual: true,
      );
      dailyReset.subjectDataBeforeReset = subjectDataBefore;

      await isarService.addDailyReset(dailyReset);

      print('✅ Manual reset completed');

      // Notify listeners
      _notifyResetListeners();
    } catch (e) {
      print('❌ Error performing manual reset: $e');
    }
  }

  /// Cleanup
  void dispose() {
    _resetTimer?.cancel();
    _resetListeners.clear();
  }
}

/// Riverpod provider for daily reset service
final dailyResetServiceProvider = Provider<DailyResetService>((ref) {
  final service = DailyResetService();
  service.initialize();

  // Cleanup on dispose
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});
