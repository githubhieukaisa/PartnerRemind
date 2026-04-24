import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the active tab in the desktop navigation
/// 0 = Timer Tab, 1 = Subjects Tab, 2 = Settings Tab
final activeTabProvider = StateProvider<int>((ref) => 0);

/// Track currently selected subject for study session
/// If null, timer cannot start (user must select subject first)
final selectedSubjectIdProvider = StateProvider<int?>((ref) => null);
