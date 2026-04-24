import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../persistence/isar_service.dart';

/// Controller for Subjects state management with Isar persistence
class SubjectNotifier extends Notifier<List<Subject>> {
  late IsarService _isarService;

  @override
  List<Subject> build() {
    _isarService = IsarService();

    // Load from Isar on build
    _loadFromDatabase();

    // Return initial state while loading
    return [];
  }

  /// Load subjects from Isar database
  Future<void> _loadFromDatabase() async {
    try {
      final subjects = await _isarService.getAllSubjects();
      state = subjects;
    } catch (e) {
      print('Error loading subjects: $e');
      state = [];
    }
  }

  /// Add a new subject with name and daily target
  Future<void> addSubject({
    required String name,
    required int dailyTargetMinutes,
  }) async {
    try {
      final newSubject = Subject(
        name: name,
        dailyTargetMinutes: dailyTargetMinutes,
        studyTimeToday: 0,
      );
      await _isarService.addSubject(newSubject);
      // Reload from database to get the generated ID
      await _loadFromDatabase();
    } catch (e) {
      print('Error adding subject: $e');
    }
  }

  /// Update an existing subject
  Future<void> updateSubject(Subject subject) async {
    final previousState = state;
    state = [
      for (final current in state)
        if (current.id == subject.id) subject else current,
    ];

    try {
      await _isarService.updateSubject(subject);
      // Reload from database to ensure canonical persisted state.
      await _loadFromDatabase();
    } catch (e) {
      print('Error updating subject: $e');
      state = previousState;
    }
  }

  /// Delete a subject by id
  Future<void> deleteSubject(int id) async {
    try {
      await _isarService.deleteSubject(id);
      await _loadFromDatabase();
    } catch (e) {
      print(e);
    }
  }

  /// Get subject by ID
  Subject? getSubjectById(int id) {
    try {
      return state.firstWhere((subject) => subject.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add study time to a subject
  Future<void> addStudyTime(int subjectId, int minutes) async {
    try {
      final subject = getSubjectById(subjectId);
      if (subject != null) {
        subject.addStudyTime(minutes);
        await updateSubject(subject);
      }
    } catch (e) {
      print('Error adding study time: $e');
    }
  }

  /// Reset today's study time for all subjects
  Future<void> resetAllTodayStudyTime() async {
    try {
      await _isarService.resetAllSubjectsDailyTime();
      await _loadFromDatabase();
    } catch (e) {
      print('Error resetting study times: $e');
    }
  }

  /// Refresh from database (after manual persistence)
  void refreshFromDatabase() {
    _loadFromDatabase();
  }
}

/// Riverpod provider for Subjects with Isar persistence
/// Uses Notifier (not AutoDispose) to keep subjects alive across mode switches
final subjectProvider = NotifierProvider<SubjectNotifier, List<Subject>>(
  SubjectNotifier.new,
);
