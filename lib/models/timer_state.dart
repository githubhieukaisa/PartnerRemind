import 'package:equatable/equatable.dart';

/// Represents the state of the precision timer
class TimerState extends Equatable {
  final DateTime? startTime;
  final Duration elapsed;
  final bool isRunning;

  const TimerState({
    this.startTime,
    this.elapsed = Duration.zero,
    this.isRunning = false,
  });

  /// Get the current elapsed time (includes both stored duration and live delta)
  Duration getCurrentElapsed() {
    if (!isRunning || startTime == null) {
      return elapsed;
    }
    final delta = DateTime.now().difference(startTime!);
    return elapsed + delta;
  }

  @override
  List<Object?> get props => [startTime, elapsed, isRunning];
}
