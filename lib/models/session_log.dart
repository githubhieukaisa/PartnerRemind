import 'package:isar/isar.dart';

part 'session_log.g.dart';

/// Session log model - audit trail for timer sessions
/// Tracks every work session for analytics and verification
@Collection()
class SessionLog {
  Id id = Isar.autoIncrement;

  /// Associated subject ID (nullable for break sessions)
  int? subjectId;

  /// Session start time
  late DateTime startTime;

  /// Session end time
  DateTime? endTime;

  /// Total elapsed duration (in seconds)
  late int elapsedSeconds;

  /// Session type: 'study' or 'break'
  late String sessionType;

  /// Is this session currently active/running?
  late bool isActive;

  /// Creation timestamp
  late DateTime createdAt;

  /// Notes for this session
  String? notes;

  /// Isar requires a creation timestamp for sorting
  late DateTime recordedAt;

  SessionLog({
    this.subjectId,
    required this.startTime,
    this.endTime,
    this.elapsedSeconds = 0,
    required this.sessionType,
    this.isActive = false,
  }) {
    createdAt = DateTime.now();
    recordedAt = DateTime.now();
  }

  /// Calculate total duration from start to end
  Duration getDuration() {
    return Duration(seconds: elapsedSeconds);
  }

  /// Format elapsed time as HH:MM:SS
  String formatDuration() {
    final duration = Duration(seconds: elapsedSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
