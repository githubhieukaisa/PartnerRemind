import 'dart:io';
import 'package:isar/isar.dart';
import 'package:PartnerReminder/models/subject.dart';
import 'package:PartnerReminder/models/session_log.dart';
import 'package:PartnerReminder/models/break_bank_snapshot.dart';
import 'package:PartnerReminder/models/daily_reset.dart';

void main() async {
  await Isar.initializeIsarCore(download: true);
  final appData = Platform.environment['APPDATA'];
  final dir = Directory('$appData\\PartnerRemind\\isar');
  final isar = await Isar.open([SubjectSchema, SessionLogSchema, BreakBankSnapshotSchema, DailyResetSchema], directory: dir.path);
  
  final dataToRestore = {
    'Lập trình game': 1200 * 60,
    'Japanese Exam': -400 * 60,
    'JapaneseListening': -400 * 60,
    'HCM': -280 * 60,
    'PRM': 58 * 60,
    'PRN': -300 * 60,
    'Project': -180 * 60,
  };

  await isar.writeTxn(() async {
    final subjects = await isar.subjects.where().findAll();
    for (var s in subjects) {
      if (dataToRestore.containsKey(s.name)) {
        s.carryOverSeconds = dataToRestore[s.name]!;
        s.lastUpdated = DateTime.now();
        await isar.subjects.put(s);
        print('Đã phục hồi ${s.name}: ${s.carryOverSeconds ~/ 60} phút');
      }
    }
  });
  
  await isar.close();
  print('Khôi phục Nợ/Dư hoàn tất!');
  exit(0);
}
