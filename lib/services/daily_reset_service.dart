import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../persistence/isar_service.dart';
import '../models/daily_reset.dart';
import '../providers/break_bank_provider.dart';
import '../providers/subject_provider.dart';

/// Service to handle daily reset logic at 00:00
class DailyResetService extends Notifier<void> {
  Timer? _resetTimer;

  @override
  void build() {
    ref.onDispose(() {
      _resetTimer?.cancel();
    });
    initialize();
  }

  /// Initialize the daily reset scheduler
  void initialize() {
    unawaited(_initializeInternal());
  }

  Future<void> _initializeInternal() async {
    await _checkAndPerformMissedReset();
    _scheduleNextReset();
  }

  /// Catch up missed reset if the app was closed across midnight.
  Future<void> _checkAndPerformMissedReset() async {
    try {
      final isarService = IsarService();
      final todayReset = await isarService.getTodayDailyReset();

      if (todayReset != null) {
        return;
      }

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      final subjects = await isarService.getAllSubjects();
      final breakBankSnapshot = await isarService.getBreakBankSnapshot();

      final hasCarryOverStudyData = subjects.any((s) => s.studyTimeTodaySeconds > 0);
      final breakBankSnapshotIsStale = breakBankSnapshot.lastUpdated.isBefore(
        startOfToday,
      );

      if (hasCarryOverStudyData || breakBankSnapshotIsStale) {
        print('🔁 Missed daily reset detected. Running catch-up reset...');
        await _performDailyReset();
      }
    } catch (e) {
      print('❌ Error checking missed daily reset: $e');
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
          .map((s) => '${s.name}: ${s.studyTimeTodaySeconds ~/ 60}m')
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
          breakTimeAfterReset = breakTimeBeforeReset;
          break;
        case 'keep_partial':
          if (breakBankSnapshot.partialResetMinutes != null) {
            breakTimeAfterReset = (breakBankSnapshot.partialResetMinutes! * 60)
                .toInt();
          }
          break;
        case 'reset':
        default:
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

      // Refresh providers to update UI
      ref.read(breakBankProvider.notifier).refreshFromDatabase();
      ref.read(subjectProvider.notifier).refreshFromDatabase();
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

      final breakBankSnapshot = await isarService.getBreakBankSnapshot();
      final breakTimeBeforeReset = breakBankSnapshot.totalBreakSeconds;

      final subjects = await isarService.getAllSubjects();
      final subjectDataBefore = subjects
          .map((s) => '${s.name}: ${s.studyTimeTodaySeconds ~/ 60}m')
          .toList();

      breakBankSnapshot.dailyResetPreference = action;
      if (action == 'keep_partial' && partialBreakMinutes != null) {
        breakBankSnapshot.partialResetMinutes = partialBreakMinutes;
      }

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

      breakBankSnapshot.totalBreakSeconds = breakTimeAfterReset;
      await isarService.updateBreakBankSnapshot(breakBankSnapshot);
      await isarService.resetAllSubjectsDailyTime();

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

      // Refresh providers to update UI
      ref.read(breakBankProvider.notifier).refreshFromDatabase();
      ref.read(subjectProvider.notifier).refreshFromDatabase();
    } catch (e) {
      print('❌ Error performing manual reset: $e');
    }
  }
}

/// Riverpod provider for daily reset service
final dailyResetServiceProvider = NotifierProvider<DailyResetService, void>(
  DailyResetService.new,
);
