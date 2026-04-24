import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_state.dart';
import 'break_bank_provider.dart';
import 'session_log_controller.dart';

/// Callback when countdown timer finishes
typedef OnCountdownFinished = void Function();

/// Precision timer controller using DateTime-based calculations
class PrecisionTimerNotifier extends Notifier<TimerState> {
  Timer? _updateTimer;
  OnCountdownFinished? _onCountdownFinished;
  Duration _consumedBreakTime = Duration.zero;
  static const Duration _breakPersistThreshold = Duration(seconds: 1);

  @override
  TimerState build() {
    ref.onDispose(() {
      _updateTimer?.cancel();
    });
    return const TimerState();
  }

  /// Register callback for when countdown finishes
  void setOnCountdownFinished(OnCountdownFinished callback) {
    _onCountdownFinished = callback;
  }

  /// Start the timer from zero (stopwatch mode)
  void start() {
    _resetBreakConsumption();
    state = TimerState(
      startTime: DateTime.now(),
      elapsed: Duration.zero,
      isRunning: true,
      mode: TimerMode.stopwatch,
    );
    _startUpdateTimer();
  }

  /// Start countdown timer with a target duration
  /// Example: startCountdown(Duration(minutes: 25)) for Pomodoro
  void startCountdown(Duration targetDuration) {
    _resetBreakConsumption();
    state = TimerState(
      startTime: DateTime.now(),
      elapsed: Duration.zero,
      isRunning: true,
      mode: TimerMode.countdown,
      targetDuration: targetDuration,
    );
    _startUpdateTimer();
  }

  /// Start break countdown timer using available break bank duration.
  void startBreak(Duration breakDuration) {
    final sanitizedDuration = breakDuration <= Duration.zero
        ? Duration.zero
        : breakDuration;
    if (sanitizedDuration == Duration.zero) return;

    _resetBreakConsumption();
    state = TimerState(
      startTime: DateTime.now(),
      elapsed: Duration.zero,
      isRunning: true,
      mode: TimerMode.breakCountdown,
      targetDuration: sanitizedDuration,
    );
    _startUpdateTimer();
  }

  /// Pause the timer (saves the current elapsed time)
  void pause() {
    if (!state.isRunning) return;

    if (state.mode == TimerMode.breakCountdown) {
      unawaited(_consumeBreakTime(force: true));
    }

    final actualStudyTime = state.getActualStudyTime();
    state = TimerState(
      startTime: null,
      elapsed: actualStudyTime,
      isRunning: false,
      mode: state.mode,
      targetDuration: state.targetDuration,
      isFinished: state.isFinished,
    );
    _updateTimer?.cancel();
  }

  /// Resume the timer from where it was paused
  void resume() {
    if (state.isRunning) return;

    state = TimerState(
      startTime: DateTime.now(),
      elapsed: state.elapsed,
      isRunning: true,
      mode: state.mode,
      targetDuration: state.targetDuration,
      isFinished: state.isFinished,
    );
    _startUpdateTimer();
  }

  /// Stop and save the study session, then reset the timer
  /// Saves for both stopwatch and countdown modes
  Future<void> stop() async {
    _updateTimer?.cancel();

    if (state.mode == TimerMode.breakCountdown) {
      await _consumeBreakTime(force: true);
      state = const TimerState();
      _resetBreakConsumption();
      return;
    }

    // Always save the session using actual study time (regardless of mode)
    final actualStudyTime = state.getActualStudyTime();
    if (actualStudyTime.inSeconds > 0) {
      // Save session and wait for completion before resetting
      await ref
          .read(sessionLogControllerProvider.notifier)
          .saveStudySession(
            elapsedDuration: actualStudyTime,
            timerState: state,
          );
    }

    // Reset state after saving
    state = const TimerState();
    _resetBreakConsumption();
  }

  /// Add manual time to the timer (e.g., from break bank or adjustment)
  void addTime(Duration duration) {
    final actualStudyTime = state.getActualStudyTime();
    state = TimerState(
      startTime: DateTime.now(),
      elapsed: actualStudyTime + duration,
      isRunning: state.isRunning,
      mode: state.mode,
      targetDuration: state.targetDuration,
      isFinished: state.isFinished,
    );
  }

  /// Internal method to update timer UI periodically and check for countdown completion
  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      // Countdown-like modes (study countdown + break countdown)
      if ((state.mode == TimerMode.countdown ||
              state.mode == TimerMode.breakCountdown) &&
          state.isRunning) {
        if (state.mode == TimerMode.breakCountdown) {
          await _consumeBreakTime();
        }

        final currentRemaining = state.getDisplayTime();

        if (currentRemaining <= Duration.zero) {
          final finishedMode = state.mode;

          // Countdown finished - mark finished state and stop timer
          final newState = TimerState(
            startTime: null,
            elapsed: Duration.zero,
            isRunning: false,
            mode: finishedMode,
            targetDuration: state.targetDuration,
            isFinished: true,
          );
          state = newState;
          _updateTimer?.cancel();

          if (finishedMode == TimerMode.countdown &&
              state.targetDuration != null) {
            // Save study countdown as a study session.
            await ref
                .read(sessionLogControllerProvider.notifier)
                .saveStudySession(
                  elapsedDuration: state.targetDuration!,
                  timerState: state,
                );
          }

          if (finishedMode == TimerMode.breakCountdown) {
            await _consumeBreakTime(force: true);
            _resetBreakConsumption();
          }

          // Trigger callback for study countdown only.
          if (finishedMode == TimerMode.countdown) {
            _onCountdownFinished?.call();
          }

          print('⏰ ${finishedMode.name} timer finished!');
          return;
        }
      }

      // Rebuild UI with updated elapsed time
      state = TimerState(
        startTime: state.startTime,
        elapsed: state.elapsed,
        isRunning: state.isRunning,
        mode: state.mode,
        targetDuration: state.targetDuration,
        isFinished: state.isFinished,
      );
    });
  }

  void _resetBreakConsumption() {
    _consumedBreakTime = Duration.zero;
  }

  Future<void> _consumeBreakTime({bool force = false}) async {
    if (state.mode != TimerMode.breakCountdown) {
      return;
    }

    final actualSpent = state.getActualStudyTime();
    final delta = actualSpent - _consumedBreakTime;

    if (delta <= Duration.zero) {
      return;
    }

    if (!force && delta < _breakPersistThreshold) {
      return;
    }

    await ref.read(breakBankProvider.notifier).useBreakTime(delta);
    _consumedBreakTime += delta;
  }
}

/// Riverpod provider for the precision timer
/// Uses Notifier (not AutoDispose) to keep timer alive across mode switches
final precisionTimerProvider =
    NotifierProvider<PrecisionTimerNotifier, TimerState>(
      PrecisionTimerNotifier.new,
    );
