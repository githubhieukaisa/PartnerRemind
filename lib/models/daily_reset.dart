import 'package:isar/isar.dart';

part 'daily_reset.g.dart';

/// Daily Reset log - tracks daily reset preferences and actions
/// Used for audit trail and time compensation algorithm
@Collection()
class DailyReset {
  Id id = Isar.autoIncrement;

  /// Date of reset (YYYY-MM-DD)
  late DateTime resetDate;

  /// Reset action: 'keep_all' | 'keep_partial' | 'reset'
  late String action;

  /// Break time kept (in seconds) if 'keep_partial'
  int? keptBreakSeconds;

  /// Break time before reset
  late int breakTimeBeforeReset;

  /// Break time after reset
  late int breakTimeAfterReset;

  /// Subjects' daily study times before reset
  late List<String> subjectDataBeforeReset; // JSON-serialized

  /// Timestamp of when reset was executed
  late DateTime executedAt;

  /// User confirmation (was this manual or automatic?)
  late bool isManual;

  DailyReset({
    required this.resetDate,
    required this.action,
    required this.breakTimeBeforeReset,
    required this.breakTimeAfterReset,
    this.keptBreakSeconds,
    this.isManual = false,
  }) {
    executedAt = DateTime.now();
    subjectDataBeforeReset = [];
  }

  /// Check if this is today's reset
  bool isToday() {
    final today = DateTime.now();
    return resetDate.year == today.year &&
        resetDate.month == today.month &&
        resetDate.day == today.day;
  }
}
