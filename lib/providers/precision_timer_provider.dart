import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_state.dart';

/// Precision timer controller using DateTime-based calculations
class PrecisionTimerNotifier extends AutoDisposeNotifier<TimerState> {
  Timer? _updateTimer;

  @override
  TimerState build() {
    ref.onDispose(() {
      _updateTimer?.cancel();
    });
    return const TimerState();
  }

  /// Start the timer from zero
  void start() {
    state = TimerState(
      startTime: DateTime.now(),
      elapsed: Duration.zero,
      isRunning: true,
    );
    _startUpdateTimer();
  }

  /// Pause the timer (saves the current elapsed time)
  void pause() {
    if (!state.isRunning) return;

    final currentElapsed = state.getCurrentElapsed();
    state = TimerState(
      startTime: null,
      elapsed: currentElapsed,
      isRunning: false,
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
    );
    _startUpdateTimer();
  }

  /// Stop and reset the timer
  void stop() {
    _updateTimer?.cancel();
    state = const TimerState();
  }

  /// Add manual time to the timer (e.g., from break bank or adjustment)
  void addTime(Duration duration) {
    final currentElapsed = state.getCurrentElapsed();
    state = TimerState(
      startTime: DateTime.now(),
      elapsed: currentElapsed + duration,
      isRunning: state.isRunning,
    );
  }

  /// Internal method to update timer UI periodically
  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      // Rebuild UI with updated elapsed time
      state = TimerState(
        startTime: state.startTime,
        elapsed: state.elapsed,
        isRunning: state.isRunning,
      );
    });
  }
}

/// Riverpod provider for the precision timer
final precisionTimerProvider =
    AutoDisposeNotifierProvider<PrecisionTimerNotifier, TimerState>(
      PrecisionTimerNotifier.new,
    );
