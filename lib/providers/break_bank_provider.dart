import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/break_bank.dart';
import '../models/timer_state.dart';
import '../persistence/isar_service.dart';
import 'precision_timer_provider.dart';
import 'study_ratio_provider.dart';

/// Controller for Break Bank state management with Isar persistence
/// Supports auto-accumulation of break time based on study duration
class BreakBankNotifier extends Notifier<BreakBank> {
  late IsarService _isarService;
  Duration _lastPersistedBreakTime = Duration.zero;
  DateTime? _lastPersistTime;

  // Accumulation tracking
  Duration _accumulatedBreakTime = Duration.zero;
  Timer? _batchPersistTimer;
  static const Duration _batchPersistInterval = Duration(minutes: 2);

  @override
  BreakBank build() {
    _isarService = IsarService();

    // Load from Isar on build
    _loadFromDatabase();

    // Setup auto-accumulation listener
    _setupAutoAccumulationListener();

    // Setup batch persistence timer (every 2 minutes)
    _setupBatchPersistenceTimer();

    // Cleanup on dispose
    ref.onDispose(() {
      _batchPersistTimer?.cancel();
    });

    // Return initial state while loading
    return BreakBank(lastUpdated: DateTime.now());
  }

  /// Listen to precision timer and auto-accumulate break time
  void _setupAutoAccumulationListener() {
    ref.listen(precisionTimerProvider, (previous, next) {
      // Never generate break credit while user is consuming break time.
      if (next.mode == TimerMode.breakCountdown) {
        return;
      }

      final ratio = ref.read(studyRatioProvider);

      // Only accumulate when timer is running
      if (next.isRunning) {
        // Calculate accumulated break time based on actual study duration (not display time)
        final actualStudyDuration = next.getActualStudyTime();
        final calculatedBreakTime = ratio.calculateBreakTimeAccumulated(
          actualStudyDuration,
        );

        // Add the difference to our accumulation (avoid double-counting)
        if (calculatedBreakTime > _accumulatedBreakTime) {
          final newBreakTime = calculatedBreakTime - _accumulatedBreakTime;
          _accumulatedBreakTime = calculatedBreakTime;

          // Update state in-memory (UI sees immediate update)
          state = state.addBreakTime(newBreakTime);
        }
      }

      // Persist to DB when timer transitions to paused/stopped
      if (previous != null && previous.isRunning && !next.isRunning) {
        _persistAccumulatedBreakTime();
      }
    });
  }

  /// Setup batch persistence every 2 minutes
  void _setupBatchPersistenceTimer() {
    _batchPersistTimer?.cancel();
    _batchPersistTimer = Timer.periodic(_batchPersistInterval, (_) {
      _persistAccumulatedBreakTime();
    });
  }

  /// Persist accumulated break time to Isar database
  Future<void> _persistAccumulatedBreakTime() async {
    try {
      if (_accumulatedBreakTime > Duration.zero) {
        // Add to database
        await _isarService.addBreakTime(_accumulatedBreakTime.inSeconds);

        // Reset accumulation counter
        _accumulatedBreakTime = Duration.zero;
        _lastPersistTime = DateTime.now();

        print('✅ Break bank batch persisted to Isar');
      }
    } catch (e) {
      print('❌ Error batch persisting break time: $e');
    }
  }

  /// Load break bank state from Isar database
  Future<void> _loadFromDatabase() async {
    try {
      final snapshot = await _isarService.getBreakBankSnapshot();
      state = BreakBank(
        totalBreakTime: Duration(seconds: snapshot.totalBreakSeconds),
        lastUpdated: snapshot.lastUpdated,
      );
      _lastPersistedBreakTime = Duration(seconds: snapshot.totalBreakSeconds);
    } catch (e) {
      print('Error loading break bank: $e');
      state = BreakBank(lastUpdated: DateTime.now());
    }
  }

  /// Add break time manually to the bank (immediate persistence)
  /// Use this for manual additions via UI buttons
  Future<void> addBreakTime(Duration duration) async {
    try {
      // Update in-memory state
      state = state.addBreakTime(duration);

      // Persist immediately to Isar (manual additions)
      await _isarService.addBreakTime(duration.inSeconds);
      _lastPersistedBreakTime = state.totalBreakTime;
    } catch (e) {
      print('Error adding break time: $e');
    }
  }

  /// Deduct break time from the bank (immediate persistence)
  Future<void> useBreakTime(Duration duration) async {
    try {
      // Update in-memory state
      state = state.deductBreakTime(duration);

      // Persist immediately to Isar
      await _isarService.useBreakTime(duration.inSeconds);
      _lastPersistedBreakTime = state.totalBreakTime;
    } catch (e) {
      print('Error using break time: $e');
    }
  }

  /// Reset the break bank (immediate persistence)
  Future<void> reset() async {
    try {
      // Update in-memory state
      state = BreakBank(lastUpdated: DateTime.now());

      // Reset accumulation counter
      _accumulatedBreakTime = Duration.zero;

      // Persist immediately to Isar
      await _isarService.resetBreakBank();
      _lastPersistedBreakTime = Duration.zero;
    } catch (e) {
      print('Error resetting break bank: $e');
    }
  }

  /// Get remaining break time available
  Duration getAvailableBreakTime() {
    return state.totalBreakTime;
  }

  /// Reload from database (after manual persistence)
  Future<void> reload() async {
    await _loadFromDatabase();
  }

  void refreshFromDatabase() {
    _loadFromDatabase();
  }
}

/// Riverpod provider for Break Bank with Isar persistence
/// Uses Notifier (not AutoDispose) to keep bank alive across mode switches
final breakBankProvider = NotifierProvider<BreakBankNotifier, BreakBank>(
  BreakBankNotifier.new,
);
