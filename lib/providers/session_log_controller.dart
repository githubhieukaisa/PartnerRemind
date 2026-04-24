import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_log.dart';
import '../models/timer_state.dart';
import '../persistence/isar_service.dart';
import 'subject_provider.dart';
import 'navigation_provider.dart';

/// Controller for managing study session lifecycle and persistence
class SessionLogController extends Notifier<void> {
  late IsarService _isarService;

  @override
  void build() {
    _isarService = IsarService();
  }

  /// Save a completed study session
  /// Called when timer stops or countdown finishes
  /// Returns the saved session ID, or null if save failed
  Future<int?> saveStudySession({
    required Duration elapsedDuration,
    required TimerState timerState,
  }) async {
    try {
      final subjectId = ref.read(selectedSubjectIdProvider);

      // Require subject selection for study sessions
      if (subjectId == null) {
        print('⚠️ Cannot save session: No subject selected');
        return null;
      }

      // Convert to whole minutes
      final minutes = elapsedDuration.inSeconds ~/ 60;
      if (minutes == 0) {
        print('⚠️ Session too short: < 1 minute');
        return null;
      }

      // Create SessionLog
      final sessionLog = SessionLog(
        subjectId: subjectId,
        startTime: DateTime.now().subtract(elapsedDuration),
        endTime: DateTime.now(),
        elapsedSeconds: elapsedDuration.inSeconds,
        sessionType: 'study',
        isActive: false,
      );

      // Save to Isar
      final id = await _isarService.addSessionLog(sessionLog);
      print('✅ Session saved (ID: $id) - $minutes min on subject $subjectId');

      // Update subject's study time
      await ref.read(subjectProvider.notifier).addStudyTime(subjectId, minutes);
      print('✅ Updated subject study time: +$minutes min');

      return id;
    } catch (e) {
      print('❌ Error saving session: $e');
      return null;
    }
  }
}

/// Riverpod provider for session log controller
final sessionLogControllerProvider =
    NotifierProvider<SessionLogController, void>(SessionLogController.new);
