import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/break_bank.dart';

/// Controller for Break Bank state management
class BreakBankNotifier extends AutoDisposeNotifier<BreakBank> {
  @override
  BreakBank build() {
    return BreakBank(lastUpdated: DateTime.now());
  }

  /// Add break time to the bank (from completed work sessions)
  void addBreakTime(Duration duration) {
    state = state.addBreakTime(duration);
  }

  /// Deduct break time from the bank (when taking a break)
  void useBreakTime(Duration duration) {
    state = state.deductBreakTime(duration);
  }

  /// Reset the break bank
  void reset() {
    state = BreakBank(lastUpdated: DateTime.now());
  }

  /// Get remaining break time available
  Duration getAvailableBreakTime() {
    return state.totalBreakTime;
  }
}

/// Riverpod provider for Break Bank
final breakBankProvider =
    AutoDisposeNotifierProvider<BreakBankNotifier, BreakBank>(
      BreakBankNotifier.new,
    );
