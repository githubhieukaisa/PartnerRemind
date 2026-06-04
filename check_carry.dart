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
  
  final subjects = await isar.subjects.where().findAll();
  for (var s in subjects) {
    print('${s.name}: carryOver=${s.carryOverSeconds}');
  }
  
  await isar.close();
  exit(0);
}
