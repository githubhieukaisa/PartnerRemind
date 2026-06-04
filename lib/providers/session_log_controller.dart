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

      // Convert to whole seconds
      final seconds = elapsedDuration.inSeconds;
      if (seconds == 0) {
        print('⚠️ Session too short: < 1 second');
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
      print('✅ Session saved (ID: $id) - $seconds sec on subject $subjectId');

      // Update subject's study time in seconds
      await ref.read(subjectProvider.notifier).addStudyTime(subjectId, seconds);
      print('✅ Updated subject study time: +$seconds sec');

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
