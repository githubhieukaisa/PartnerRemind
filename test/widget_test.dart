// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:first_flutter/widgets/timer_display.dart';

void main() {
  test('formatDuration renders HH:MM:SS.cc', () {
    const input = Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 450);
    expect(formatDuration(input), '01:02:03.45');
  });
}
