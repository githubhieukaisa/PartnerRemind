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

  /// Study time accumulated today (in minutes)
  late int studyTimeToday;

  /// Carry over minutes (positive for surplus, negative for debt)
  late int carryOverMinutes;

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
    this.studyTimeToday = 0,
    this.carryOverMinutes = 0,
    this.isActive = true,
  }) {
    lastUpdated = DateTime.now();
    createdAt = DateTime.now();
  }

  /// Effective daily target adjusted for carry over
  int get effectiveTargetMinutes => dailyTargetMinutes - carryOverMinutes;

  /// Get remaining time to reach daily target (in minutes)
  int getRemainingMinutes() {
    final remaining = effectiveTargetMinutes - studyTimeToday;
    return remaining > 0 ? remaining : 0;
  }

  /// Get progress as percentage (0.0 - 1.0)
  double getProgressPercentage() {
    if (effectiveTargetMinutes <= 0) return 1.0;
    return (studyTimeToday / effectiveTargetMinutes).clamp(0.0, 1.0);
  }

  /// Add study time (in minutes)
  void addStudyTime(int minutes) {
    studyTimeToday += minutes;
    lastUpdated = DateTime.now();
  }

  /// Reset today's study time
  void resetTodayStudyTime() {
    studyTimeToday = 0;
    lastUpdated = DateTime.now();
  }
}
