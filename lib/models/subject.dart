import 'package:isar/isar.dart';

part 'subject.g.dart';

/// Subject model - represents a learning subject
/// Isar collection for storing subject information and daily tracking
@Collection()
class Subject {
  Id id = Isar.autoIncrement;

  /// Subject name (e.g., "Mathematics", "English")
  late String name;

  /// Daily target study hours (in minutes for precision)
  late int dailyTargetMinutes;

  /// Study time accumulated today (in seconds)
  late int studyTimeTodaySeconds;

  /// Carry over seconds (positive for surplus, negative for debt)
  late int carryOverSeconds;

  /// Custom study ratio (e.g., 12 for 12:1). Null means use global default.
  int? studyRatio;

  /// Last update timestamp
  late DateTime lastUpdated;

  /// Creation timestamp
  late DateTime createdAt;

  /// Whether this subject is active
  late bool isActive;

  /// Notes or description
  String? notes;

  Subject({
    required this.name,
    required this.dailyTargetMinutes,
    this.studyTimeTodaySeconds = 0,
    this.carryOverSeconds = 0,
    this.studyRatio,
    this.isActive = true,
  }) {
    lastUpdated = DateTime.now();
    createdAt = DateTime.now();
  }

  /// Effective daily target adjusted for carry over (in seconds)
  int get effectiveTargetSeconds => (dailyTargetMinutes * 60) - carryOverSeconds;

  /// Get remaining time to reach daily target (in seconds)
  int getRemainingSeconds() {
    final remaining = effectiveTargetSeconds - studyTimeTodaySeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// Get progress as percentage (0.0 - 1.0)
  double getProgressPercentage() {
    if (effectiveTargetSeconds <= 0) return 1.0;
    return (studyTimeTodaySeconds / effectiveTargetSeconds).clamp(0.0, 1.0);
  }

  /// Add study time (in seconds)
  void addStudyTimeSeconds(int seconds) {
    studyTimeTodaySeconds += seconds;
    lastUpdated = DateTime.now();
  }

  /// Reset today's study time
  void resetTodayStudyTime() {
    studyTimeTodaySeconds = 0;
    lastUpdated = DateTime.now();
  }
}
