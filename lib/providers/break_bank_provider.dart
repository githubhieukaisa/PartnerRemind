import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/break_bank.dart';
import '../persistence/isar_service.dart';

/// Controller for Break Bank state management with Isar persistence
class BreakBankNotifier extends AutoDisposeNotifier<BreakBank> {
  late IsarService _isarService;

  @override
  BreakBank build() {
    _isarService = IsarService();

    // Load from Isar on build
    _loadFromDatabase();

    // Return initial state while loading
    return BreakBank(lastUpdated: DateTime.now());
  }

  /// Load break bank state from Isar database
  Future<void> _loadFromDatabase() async {
    try {
      final snapshot = await _isarService.getBreakBankSnapshot();
      state = BreakBank(
        totalBreakTime: Duration(seconds: snapshot.totalBreakSeconds),
        lastUpdated: snapshot.lastUpdated,
      );
    } catch (e) {
      print('Error loading break bank: $e');
      state = BreakBank(lastUpdated: DateTime.now());
    }
  }

  /// Add break time to the bank (and persist immediately)
  Future<void> addBreakTime(Duration duration) async {
    try {
      // Update in-memory state
      state = state.addBreakTime(duration);

      // Persist immediately to Isar
      await _isarService.addBreakTime(duration.inSeconds);
    } catch (e) {
      print('Error adding break time: $e');
    }
  }

  /// Deduct break time from the bank (and persist immediately)
  Future<void> useBreakTime(Duration duration) async {
    try {
      // Update in-memory state
      state = state.deductBreakTime(duration);

      // Persist immediately to Isar
      await _isarService.useBreakTime(duration.inSeconds);
    } catch (e) {
      print('Error using break time: $e');
    }
  }

  /// Reset the break bank (and persist)
  Future<void> reset() async {
    try {
      // Update in-memory state
      state = BreakBank(lastUpdated: DateTime.now());

      // Persist immediately to Isar
      await _isarService.resetBreakBank();
    } catch (e) {
      print('Error resetting break bank: $e');
    }
  }

  /// Get remaining break time available
  Duration getAvailableBreakTime() {
    return state.totalBreakTime;
  }

  /// Reload from database (after manual persistence)
  Future<void> reload() async {
    await _loadFromDatabase();
  }
}

/// Riverpod provider for Break Bank with Isar persistence
final breakBankProvider =
    AutoDisposeNotifierProvider<BreakBankNotifier, BreakBank>(
      BreakBankNotifier.new,
    );
