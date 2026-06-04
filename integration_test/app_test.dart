import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:PartnerReminder/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End E2E Testing for Windows Desktop', (WidgetTester tester) async {
    // 1. Khởi động ứng dụng
    app.main();
    // Đợi app khởi động và giao diện render xong (bao gồm cả Isar, WindowManager)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 2. Chuyển sang Tab "Subjects" để thêm môn học
    // Tìm tab Subjects theo label
    final subjectsTab = find.text('Subjects');
    expect(subjectsTab, findsOneWidget, reason: 'Phải tìm thấy tab Subjects');
    await tester.tap(subjectsTab);
    await tester.pumpAndSettle();

    // 3. Bấm nút "Add Subject"
    final addSubjectButton = find.text('Add Subject');
    expect(addSubjectButton, findsOneWidget, reason: 'Phải tìm thấy nút Add Subject');
    await tester.tap(addSubjectButton);
    await tester.pumpAndSettle();

    // 4. Điền thông tin môn học
    final nameField = find.widgetWithText(TextField, 'Subject Name');
    final targetField = find.widgetWithText(TextField, 'Daily Target (minutes)');
    
    await tester.enterText(nameField, 'Integration Test Subject');
    await tester.enterText(targetField, '60');
    await tester.pumpAndSettle();

    // 5. Xác nhận thêm môn học (bấm nút "Add Subject" trong Dialog)
    final confirmAddButton = find.widgetWithText(ElevatedButton, 'Add Subject').last;
    await tester.tap(confirmAddButton);
    await tester.pumpAndSettle();

    // Đợi thông báo (SnackBar) ẩn đi
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 6. Quay lại Tab "Timer"
    final timerTab = find.byIcon(Icons.timer).first;
    await tester.tap(timerTab);
    await tester.pumpAndSettle();

    // 7. Chọn môn học vừa tạo trong Dropdown
    final dropdown = find.byType(DropdownButton<int?>);
    expect(dropdown, findsOneWidget, reason: 'Phải tìm thấy dropdown chọn môn học');
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    final subjectItem = find.text('Integration Test Subject').last;
    await tester.tap(subjectItem);
    await tester.pumpAndSettle();

    // 8. Bắt đầu Timer (Stopwatch Mode)
    final startButton = find.byIcon(Icons.play_arrow);
    expect(startButton, findsOneWidget, reason: 'Phải tìm thấy nút Start');
    await tester.tap(startButton);
    await tester.pump();

    // 9. Để đồng hồ chạy vài giây
    print('⏳ Đang mô phỏng quá trình học 3 giây...');
    await tester.pump(const Duration(seconds: 3));
    
    // 10. Tạm dừng và Dừng Timer
    final pauseButton = find.byIcon(Icons.pause);
    expect(pauseButton, findsOneWidget, reason: 'Phải tìm thấy nút Pause');
    await tester.tap(pauseButton);
    await tester.pumpAndSettle();

    final stopButton = find.byIcon(Icons.stop);
    expect(stopButton, findsOneWidget, reason: 'Phải tìm thấy nút Stop & Save');
    await tester.tap(stopButton);
    await tester.pumpAndSettle();

    // Đợi 1 chút để logic tính toán Break Bank và lưu Database hoàn tất
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // 11. Xác minh Break Bank (Ngân hàng thời gian nghỉ) đã được cộng dồn (Không còn 00:00:00.00)
    final breakBankZero = find.descendant(
      of: find.byWidgetPredicate((widget) => widget.runtimeType.toString() == 'BreakBankDisplay'),
      matching: find.text('00:00:00.00'),
    );
    expect(breakBankZero, findsNothing, reason: 'Break Bank phải được cộng thời gian nghỉ, không thể là 00:00:00.00');

    print('✅ Integration Test: Các kịch bản cốt lõi đã PASS!');
  });
}
