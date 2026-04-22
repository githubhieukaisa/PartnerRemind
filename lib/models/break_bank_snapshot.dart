import 'package:isar/isar.dart';

part 'break_bank_snapshot.g.dart';

/// Break Bank Snapshot - current state of accumulated break time
/// Singleton-like collection with single primary record
@Collection()
class BreakBankSnapshot {
  Id id = Isar.autoIncrement; // Will always be 1 for primary record

  /// Total accumulated break time (in seconds)
  late int totalBreakSeconds;

  /// Last update timestamp (for tracking changes)
  late DateTime lastUpdated;

  /// Daily reset preference: 'keep_all' | 'keep_partial' | 'reset'
  late String dailyResetPreference;

  /// If partial reset, how many minutes to keep
  int? partialResetMinutes;

  /// Version number (for optimistic locking if needed)
  late int version;

  /// Creation timestamp
  late DateTime createdAt;

  BreakBankSnapshot({
    this.totalBreakSeconds = 0,
    this.dailyResetPreference = 'keep_all',
  }) {
    lastUpdated = DateTime.now();
    createdAt = DateTime.now();
    version = 1;
  }

  /// Add break time (in seconds)
  void addBreakTime(int seconds) {
    totalBreakSeconds += seconds;
    lastUpdated = DateTime.now();
    version++;
  }

  /// Deduct break time (in seconds), floor at 0
  void useBreakTime(int seconds) {
    totalBreakSeconds = (totalBreakSeconds - seconds)
        .clamp(0, double.infinity)
        .toInt();
    lastUpdated = DateTime.now();
    version++;
  }

  /// Reset break bank to zero
  void reset() {
    totalBreakSeconds = 0;
    lastUpdated = DateTime.now();
    version++;
  }

  /// Get total break time as Duration
  Duration getBreakTime() => Duration(seconds: totalBreakSeconds);

  /// Get total break time as hours:minutes:seconds
  String formatBreakTime() {
    final duration = Duration(seconds: totalBreakSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
