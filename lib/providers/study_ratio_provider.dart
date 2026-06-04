import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/study_ratio_config.dart';

/// Controller for Study/Break ratio configuration
class StudyRatioNotifier extends StateNotifier<StudyRatioConfig> {
  StudyRatioNotifier() : super(StudyRatioConfig.default6to1());

  /// Change study ratio to 6:1
  void setRatio6to1() {
    state = StudyRatioConfig.default6to1();
  }

  /// Change study ratio to 5:1
  void setRatio5to1() {
    state = StudyRatioConfig.ratio5to1();
  }

  /// Change study ratio to 4:1
  void setRatio4to1() {
    state = StudyRatioConfig.ratio4to1();
  }

  /// Change study ratio to 12:1
  void setRatio12to1() {
    state = StudyRatioConfig.ratio12to1();
  }

  /// Set custom ratio
  void setCustomRatio({required int studyMinutes, required int breakMinutes}) {
    if (studyMinutes > 0 && breakMinutes > 0) {
      state = StudyRatioConfig(
        studyMinutes: studyMinutes,
        breakMinutes: breakMinutes,
      );
    }
  }
}

/// Provider for Study/Break ratio configuration
final studyRatioProvider =
    StateNotifierProvider<StudyRatioNotifier, StudyRatioConfig>(
      (ref) => StudyRatioNotifier(),
    );
