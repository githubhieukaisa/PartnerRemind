import 'package:equatable/equatable.dart';

/// Configuration for Study/Break Time ratio
/// Example: StudyRatioConfig(studyMinutes: 6, breakMinutes: 1)
/// means for every 6 minutes of study, 1 minute of break time is accumulated
class StudyRatioConfig extends Equatable {
  /// Study duration in minutes (e.g., 6)
  final int studyMinutes;

  /// Break time earned per study period in minutes (e.g., 1)
  final int breakMinutes;

  const StudyRatioConfig({
    required this.studyMinutes,
    required this.breakMinutes,
  });

  /// Create default 6:1 ratio (6 min study = 1 min break)
  factory StudyRatioConfig.default6to1() {
    return const StudyRatioConfig(studyMinutes: 6, breakMinutes: 1);
  }

  /// Create 5:1 ratio
  factory StudyRatioConfig.ratio5to1() {
    return const StudyRatioConfig(studyMinutes: 5, breakMinutes: 1);
  }

  /// Create 4:1 ratio
  factory StudyRatioConfig.ratio4to1() {
    return const StudyRatioConfig(studyMinutes: 4, breakMinutes: 1);
  }

  /// Calculate break time accumulated based on study duration
  /// Uses proportional/linear accumulation for smooth real-time updates
  /// Formula: breakSeconds = studySeconds * (breakMinutes / studyMinutes)
  Duration calculateBreakTimeAccumulated(Duration studyDuration) {
    final studySeconds = studyDuration.inSeconds;

    // Proportional accumulation: for every studyMinutes seconds, earn breakMinutes
    // Example: 6:1 ratio means for every 6 seconds of study, earn 1 second of break
    final breakSeconds = (studySeconds * breakMinutes) ~/ studyMinutes;

    return Duration(seconds: breakSeconds);
  }

  /// Get ratio display string (e.g., "6:1")
  String getRatioDisplay() => '$studyMinutes:$breakMinutes';

  @override
  List<Object?> get props => [studyMinutes, breakMinutes];
}
