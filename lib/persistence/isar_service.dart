import 'dart:io';
import 'package:isar/isar.dart';
import '../models/subject.dart';
import '../models/session_log.dart';
import '../models/break_bank_snapshot.dart';
import '../models/daily_reset.dart';

/// Isar Database Service
/// Singleton for managing Isar database instance and initialization
class IsarService {
  static final IsarService _instance = IsarService._internal();
  static late Isar _isar;

  factory IsarService() {
    return _instance;
  }

  IsarService._internal();

  /// Get appropriate Isar directory based on platform
  static Future<String> _getIsarDirectory() async {
    try {
      if (Platform.isWindows) {
        // Windows: use APPDATA
        final appData = Platform.environment['APPDATA'];
        if (appData != null) {
          final dir = Directory('$appData\\PartnerRemind\\isar');
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
          return dir.path;
        }
      } else if (Platform.isMacOS) {
        // macOS: use ~/Library/Application Support
        final home = Platform.environment['HOME'];
        if (home != null) {
          final dir = Directory(
            '$home/Library/Application Support/PartnerRemind/isar',
          );
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
          return dir.path;
        }
      } else if (Platform.isLinux) {
        // Linux: use XDG_DATA_HOME or ~/.local/share
        final xdgData = Platform.environment['XDG_DATA_HOME'];
        if (xdgData != null) {
          final dir = Directory('$xdgData/PartnerRemind/isar');
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
          return dir.path;
        }

        final home = Platform.environment['HOME'];
        if (home != null) {
          final dir = Directory('$home/.local/share/PartnerRemind/isar');
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
          return dir.path;
        }
      }
    } catch (e) {
      print('⚠️ Error getting platform directory: $e');
    }

    // Fallback to system temp directory
    final tempDir = Directory.systemTemp;
    final dir = Directory('${tempDir.path}/PartnerRemind/isar');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  /// Initialize Isar database
  /// Must be called once at app startup
  static Future<void> initialize() async {
    if (Isar.getInstance() != null) {
      _isar = Isar.getInstance()!;
      return;
    }

    final isarDirPath = await _getIsarDirectory();
    print('📁 Isar database directory: $isarDirPath');

    _isar = await Isar.open(
      [
        SubjectSchema,
        SessionLogSchema,
        BreakBankSnapshotSchema,
        DailyResetSchema,
      ],
      directory: isarDirPath,
      inspector: true, // Enable inspector for debugging
    );
  }

  /// Get Isar instance
  static Isar get isar => _isar;

  /// Close Isar instance (cleanup)
  static Future<void> close() async {
    await _isar.close();
  }

  // ============ Subject Operations ============

  /// Get all active subjects
  Future<List<Subject>> getAllSubjects() async {
    return _isar.subjects.filter().isActiveEqualTo(true).findAll();
  }

  /// Get subject by ID
  Future<Subject?> getSubjectById(int id) async {
    return _isar.subjects.get(id);
  }

  /// Add new subject
  Future<int> addSubject(Subject subject) async {
    return _isar.writeTxn(() => _isar.subjects.put(subject));
  }

  /// Update subject
  Future<void> updateSubject(Subject subject) async {
    await _isar.writeTxn(() => _isar.subjects.put(subject));
  }

  /// Reset all subjects' daily study time and calculate carry-over (for 00:00 reset)
  Future<void> resetAllSubjectsDailyTime() async {
    final subjects = await getAllSubjects();
    await _isar.writeTxn(() async {
      for (var subject in subjects) {
        final difference = subject.studyTimeToday - subject.effectiveTargetMinutes;
        subject.carryOverMinutes = difference;
        subject.studyTimeToday = 0;
        subject.lastUpdated = DateTime.now();
        await _isar.subjects.put(subject);
      }
    });
  }

  // ============ Break Bank Operations ============

  /// Get current break bank snapshot
  Future<BreakBankSnapshot> getBreakBankSnapshot() async {
    var snapshot = await _isar.breakBankSnapshots.where().findFirst();
    if (snapshot == null) {
      // Create initial snapshot if none exists
      final newSnapshot = BreakBankSnapshot();
      await _isar.writeTxn(() async {
        await _isar.breakBankSnapshots.put(newSnapshot);
      });
      snapshot = newSnapshot;
    }
    return snapshot;
  }

  /// Update break bank snapshot
  Future<void> updateBreakBankSnapshot(BreakBankSnapshot snapshot) async {
    await _isar.writeTxn(() => _isar.breakBankSnapshots.put(snapshot));
  }

  /// Add break time immediately (for real-time persistence)
  Future<void> addBreakTime(int seconds) async {
    final snapshot = await getBreakBankSnapshot();
    snapshot.addBreakTime(seconds);
    await updateBreakBankSnapshot(snapshot);
  }

  /// Deduct break time immediately
  Future<void> useBreakTime(int seconds) async {
    final snapshot = await getBreakBankSnapshot();
    snapshot.useBreakTime(seconds);
    await updateBreakBankSnapshot(snapshot);
  }

  /// Reset break bank
  Future<void> resetBreakBank() async {
    final snapshot = await getBreakBankSnapshot();
    snapshot.reset();
    await updateBreakBankSnapshot(snapshot);
  }

  // ============ Session Log Operations ============

  /// Add session log
  Future<int> addSessionLog(SessionLog log) async {
    return _isar.writeTxn(() => _isar.sessionLogs.put(log));
  }

  /// Update session log
  Future<void> updateSessionLog(SessionLog log) async {
    await _isar.writeTxn(() => _isar.sessionLogs.put(log));
  }

  /// Get today's session logs
  Future<List<SessionLog>> getTodaySessionLogs() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _isar.sessionLogs
        .filter()
        .startTimeBetween(startOfDay, endOfDay)
        .sortByRecordedAt()
        .findAll();
  }

  /// Get session logs for a specific subject today
  Future<List<SessionLog>> getSubjectSessionLogsToday(int subjectId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _isar.sessionLogs
        .filter()
        .subjectIdEqualTo(subjectId)
        .and()
        .startTimeBetween(startOfDay, endOfDay)
        .sortByRecordedAt()
        .findAll();
  }

  /// Get all session logs (with optional limit)
  Future<List<SessionLog>> getAllSessionLogs({int limit = 100}) async {
    return _isar.sessionLogs
        .where()
        .sortByRecordedAtDesc()
        .limit(limit)
        .findAll();
  }

  // ============ Daily Reset Operations ============

  /// Add daily reset log
  Future<int> addDailyReset(DailyReset reset) async {
    return _isar.writeTxn(() => _isar.dailyResets.put(reset));
  }

  /// Get today's daily reset (if exists)
  Future<DailyReset?> getTodayDailyReset() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _isar.dailyResets
        .filter()
        .resetDateBetween(startOfDay, endOfDay)
        .findFirst();
  }

  /// Get daily reset history (limit 30 days)
  Future<List<DailyReset>> getRecentDailyResets({int days = 30}) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    return _isar.dailyResets
        .filter()
        .resetDateGreaterThan(startDate)
        .sortByResetDateDesc()
        .findAll();
  }

  /// Clear all data (for testing or manual reset)
  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.subjects.clear();
      await _isar.sessionLogs.clear();
      await _isar.breakBankSnapshots.clear();
      await _isar.dailyResets.clear();
    });
  }

  /// Get database statistics (for debugging)
  Future<Map<String, int>> getDbStats() async {
    return {
      'subjects': await _isar.subjects.count(),
      'sessionLogs': await _isar.sessionLogs.count(),
      'breakBankSnapshots': await _isar.breakBankSnapshots.count(),
      'dailyResets': await _isar.dailyResets.count(),
    };
  }
}
