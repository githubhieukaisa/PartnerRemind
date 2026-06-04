import 'dart:io';
import 'package:isar/isar.dart';
import 'package:PartnerReminder/models/subject.dart';
import 'package:PartnerReminder/models/session_log.dart';
import 'package:PartnerReminder/models/break_bank_snapshot.dart';
import 'package:PartnerReminder/models/daily_reset.dart';

void main() async {
  print('Bắt đầu khôi phục dữ liệu...');
  
  // Khởi tạo core Isar (cần download binaries nếu chạy thuần dart)
  await Isar.initializeIsarCore(download: true);

  final appData = Platform.environment['APPDATA'];
  final dir = Directory('$appData\\PartnerRemind\\isar');
  
  final isar = await Isar.open(
    [
      SubjectSchema,
      SessionLogSchema,
      BreakBankSnapshotSchema,
      DailyResetSchema,
    ],
    directory: dir.path,
  );

  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  // Lấy tất cả session log của hôm nay
  final logsToday = await isar.sessionLogs
      .filter()
      .startTimeBetween(startOfDay, endOfDay)
      .findAll();

  print('Tìm thấy ${logsToday.length} phiên học hôm nay.');

  final Map<int, int> subjectTimes = {};
  for (var log in logsToday) {
    if (log.subjectId != null) {
      subjectTimes[log.subjectId!] = (subjectTimes[log.subjectId!] ?? 0) + log.elapsedSeconds;
    }
  }

  await isar.writeTxn(() async {
    for (var entry in subjectTimes.entries) {
      final subject = await isar.subjects.get(entry.key);
      if (subject != null) {
        // Chỉ phục hồi nếu thời gian hiện tại nhỏ hơn thời gian thực tế đã học
        if (subject.studyTimeTodaySeconds < entry.value) {
          print('Phục hồi môn ${subject.name}: ${subject.studyTimeTodaySeconds} -> ${entry.value} giây');
          subject.studyTimeTodaySeconds = entry.value;
          subject.lastUpdated = DateTime.now();
          await isar.subjects.put(subject);
        }
      }
    }
    
    // Xoá bản ghi DailyReset bị tạo nhầm hôm nay
    final wrongResets = await isar.dailyResets
        .filter()
        .resetDateBetween(startOfDay, endOfDay)
        .findAll();
        
    for (var r in wrongResets) {
      print('Xoá bản ghi reset sai lúc ${r.resetDate}');
      await isar.dailyResets.delete(r.id);
    }
  });

  await isar.close();
  print('Khôi phục hoàn tất!');
  exit(0);
}
