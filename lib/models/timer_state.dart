import 'package:equatable/equatable.dart';

/// Timer mode: counting up (stopwatch) or counting down
enum TimerMode {
  stopwatch, // Count up like a stopwatch
  countdown, // Count down to zero
  breakCountdown, // Count down break time from break bank
}

/// Represents the state of the precision timer
class TimerState extends Equatable {
  final DateTime? startTime;
  final Duration elapsed;
  final bool isRunning;
  final TimerMode mode; // Default: stopwatch
  final Duration? targetDuration; // For countdown mode only
  final bool isFinished; // True when countdown reaches zero

  const TimerState({
    this.startTime,
    this.elapsed = Duration.zero,
    this.isRunning = false,
    this.mode = TimerMode.stopwatch,
    this.targetDuration,
    this.isFinished = false,
  });

  /// Get actual study time spent (real elapsed time, regardless of mode)
  /// For stopwatch: total accumulated time
  /// For countdown: time actually spent (not remaining)
  Duration getActualStudyTime() {
    if (!isRunning || startTime == null) {
      return elapsed;
    }
    final delta = DateTime.now().difference(startTime!);
    return elapsed + delta;
  }

  /// Get display time for UI rendering
  /// For stopwatch: shows accumulated time
  /// For countdown: shows remaining time (works when running or paused)
  Duration getDisplayTime() {
    if (mode == TimerMode.stopwatch) {
      // Stopwatch displays actual time spent
      return getActualStudyTime();
    } else {
      // Countdown displays remaining time (correct for both running and paused states)
      final actualSpent = getActualStudyTime();
      final remaining = (targetDuration ?? Duration.zero) - actualSpent;
      if (remaining <= Duration.zero) {
        return Duration.zero;
      }
      return remaining;
    }
  }

  /// Check if countdown has finished
  bool checkCountdownFinished() {
    if (mode != TimerMode.countdown && mode != TimerMode.breakCountdown) {
      return false;
    }
    return getDisplayTime() <= Duration.zero;
  }

  @override
  List<Object?> get props => [
    startTime,
    elapsed,
    isRunning,
    mode,
    targetDuration,
    isFinished,
  ];
}
