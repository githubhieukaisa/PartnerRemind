import 'package:equatable/equatable.dart';

/// Represents accumulated break time bank
class BreakBank extends Equatable {
  final Duration totalBreakTime;
  final DateTime lastUpdated;

  const BreakBank({
    this.totalBreakTime = Duration.zero,
    required this.lastUpdated,
  });

  /// Add break time to the bank
  BreakBank addBreakTime(Duration duration) {
    return BreakBank(
      totalBreakTime: totalBreakTime + duration,
      lastUpdated: DateTime.now(),
    );
  }

  /// Deduct break time from the bank
  BreakBank deductBreakTime(Duration duration) {
    final newTotal = totalBreakTime - duration;
    return BreakBank(
      totalBreakTime: newTotal.isNegative ? Duration.zero : newTotal,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [totalBreakTime, lastUpdated];
}
