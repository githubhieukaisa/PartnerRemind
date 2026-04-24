import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentCountdownsNotifier extends Notifier<List<int>> {
  static const String _key = 'recent_countdowns';

  @override
  List<int> build() {
    unawaited(_loadRecentCountdowns());
    return const [];
  }

  Future<void> _loadRecentCountdowns() async {
    final prefs = await SharedPreferences.getInstance();
    final loaded = prefs.getStringList(_key) ?? const [];

    final parsed = loaded
        .map(int.tryParse)
        .whereType<int>()
        .where((value) => value > 0)
        .toList();

    state = parsed.take(5).toList();
  }

  Future<void> addRecent(int minutes) async {
    if (minutes <= 0) return;

    final updated = [
      minutes,
      ...state.where((item) => item != minutes),
    ].take(5).toList();

    state = updated;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      updated.map((value) => value.toString()).toList(),
    );
  }
}

final recentCountdownsProvider =
    NotifierProvider<RecentCountdownsNotifier, List<int>>(
      RecentCountdownsNotifier.new,
    );
