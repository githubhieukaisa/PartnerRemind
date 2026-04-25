import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/timer_state.dart';
import '../providers/window_state_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/subject_provider.dart';
import '../providers/precision_timer_provider.dart';
import '../widgets/timer_display.dart';
import '../widgets/break_bank_display.dart';
import '../widgets/custom_title_bar.dart';
import '../widgets/compact_study_bar.dart';
import '../widgets/add_subject_dialog.dart';
import '../widgets/study_ratio_selector.dart';
import '../widgets/subject_list_display.dart';
import '../widgets/subject_aware_timer_controls.dart';
import '../services/daily_reset_service.dart';

/// Home screen with window management, multi-tab navigation, and timer integration
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Force daily reset service initialization when home screen is built.
    ref.read(dailyResetServiceProvider);

    final windowState = ref.watch(windowStateProvider);
    final windowNotifier = ref.read(windowStateProvider.notifier);
    final activeTab = ref.watch(activeTabProvider);
    final activeTabNotifier = ref.read(activeTabProvider.notifier);

    // In compact mode, show minimal study bar
    if (windowState.isCompactMode) {
      return Scaffold(
        body: Column(
          children: [
            CustomTitleBar(
              title: 'PartnerRemind',
              isCompactMode: true,
              onCompactToggle: () => windowNotifier.toggleCompactMode(),
            ),
            const Expanded(child: CompactStudyBar()),
          ],
        ),
      );
    }

    // Normal mode: multi-tab desktop layout
    return Scaffold(
      body: Column(
        children: [
          // Global CustomTitleBar at top
          CustomTitleBar(
            title: 'PartnerRemind - Study Assistant',
            isCompactMode: false,
            onCompactToggle: () => windowNotifier.toggleCompactMode(),
            onMinimize: () => windowNotifier.minimizeWindow(),
            onMaximize: () => windowNotifier.maximizeWindow(),
            onClose: () => windowNotifier.closeWindow(),
          ),
          // Body with NavigationRail + Tab Content
          Expanded(
            child: Row(
              children: [
                // Sidebar navigation
                NavigationRail(
                  selectedIndex: activeTab,
                  onDestinationSelected: (index) =>
                      activeTabNotifier.state = index,
                  labelType: NavigationRailLabelType.all,
                  extended: false,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.timer),
                      label: Text('Timer'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.subject),
                      label: Text('Subjects'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                // Tab content area
                Expanded(
                  child: IndexedStack(
                    index: activeTab,
                    children: const [
                      _TimerTab(),
                      _SubjectsTab(),
                      _SettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Timer Tab - Study session with subject selection
class _TimerTab extends ConsumerStatefulWidget {
  const _TimerTab();

  @override
  ConsumerState<_TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends ConsumerState<_TimerTab> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Hàm hiển thị Báo thức
  Future<void> _showEndOfSessionModal(TimerMode timerMode) async {
    try {
      // Ép Volume lên 1.0 (100%) để đảm bảo luôn nghe thấy
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('clock_alarm.mp3'));
      print('🔊 Đang phát âm thanh báo thức...');
    } catch (e) {
      print('❌ Lỗi phát âm thanh: $e');
    }

    if (!mounted) return;

    final timerNotifier = ref.read(precisionTimerProvider.notifier);
    final currentTarget = ref.read(precisionTimerProvider).targetDuration;
    final initialMinutes = (currentTarget?.inMinutes ?? 25);
    final minutesController = TextEditingController(
      text: initialMinutes.toString(),
    );
    int customMinutes = initialMinutes;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        if (timerMode == TimerMode.breakCountdown) {
          return AlertDialog(
            title: const Text(
              'Break is over! 🚀',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            content: const Text(
              'Ready to get back to work?',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  _audioPlayer.stop();
                  Navigator.of(context).pop();
                  timerNotifier.start();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Studying'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  _audioPlayer.stop();
                  Navigator.of(context).pop();
                  await timerNotifier.stop();
                },
                icon: const Icon(Icons.stop),
                label: const Text('Stop & Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        }

        return AlertDialog(
          title: const Text(
            "Time's up! ⏰",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Do you want to continue studying?',
                  style: TextStyle(fontSize: 14),
                ),
                const Divider(),
                const Text(
                  'Continue Countdown:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final parsed = int.tryParse(value);
                          if (parsed != null && parsed > 0) {
                            customMinutes = parsed;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Minutes',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          _audioPlayer.stop();
                          Navigator.of(context).pop();
                          timerNotifier.startCountdown(
                            Duration(minutes: customMinutes),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Countdown'),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _audioPlayer.stop();
                    Navigator.of(context).pop();
                    timerNotifier.start();
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Continue in Stopwatch Mode'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    _audioPlayer.stop();
                    Navigator.of(context).pop();
                    await timerNotifier.stop();
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop & Save Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _audioPlayer.stop();
                Navigator.of(context).pop();
              },
              child: const Text('Dismiss'),
            ),
          ],
        );
      },
    ).then((_) {
      // Ensure audio stops when dialog is dismissed by clicking outside
      _audioPlayer.stop();
      minutesController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. ĐẶT LISTENER VÀO NGAY ĐẦU HÀM BUILD (Chuẩn Riverpod)
    ref.listen<TimerState>(precisionTimerProvider, (prev, next) {
      if (next.isFinished &&
          (next.mode == TimerMode.countdown ||
              next.mode == TimerMode.breakCountdown) &&
          (prev == null || !prev.isFinished)) {
        _showEndOfSessionModal(next.mode);
      }
    });

    final subjects = ref.watch(subjectProvider);
    final selectedSubjectId = ref.watch(selectedSubjectIdProvider);
    final isValidSubject =
        selectedSubjectId == null ||
        subjects.any((s) => s.id == selectedSubjectId);
    final safeSelectedId = isValidSubject ? selectedSubjectId : null;

    if (!isValidSubject) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedSubjectIdProvider.notifier).state = null;
      });
    }

    final selectedSubjectNotifier = ref.read(
      selectedSubjectIdProvider.notifier,
    );
    final timerState = ref.watch(precisionTimerProvider);
    final isSessionActive =
        timerState.isRunning || timerState.elapsed > Duration.zero;
    final isBreakMode = timerState.mode == TimerMode.breakCountdown;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        spacing: 24,
        children: [
          // Subject selection dropdown
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  const Text(
                    'Select Subject for Study Session',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  if (subjects.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange.withValues(alpha: 0.1),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No subjects yet. Create one to start studying.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    DropdownButton<int?>(
                      isExpanded: true,
                      value: safeSelectedId,
                      hint: const Text('Choose a subject...'),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('-- No Subject --'),
                        ),
                        ...subjects.map(
                          (subject) => DropdownMenuItem<int?>(
                            value: subject.id,
                            child: Text(
                              subject.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      // Disable dropdown during active session
                      onChanged: (isSessionActive || isBreakMode)
                          ? null
                          : (value) => selectedSubjectNotifier.state = value,
                    ),
                  if (safeSelectedId != null)
                    Text(
                      'Selected: ${subjects.firstWhere((s) => s.id == safeSelectedId).name}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Timer display and controls
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                spacing: 24,
                children: [
                  const Text(
                    'Precision Timer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const TimerDisplay(),
                  SubjectAwareTimerControls(
                    subjectSelected: selectedSubjectId != null,
                  ),
                ],
              ),
            ),
          ),

          // Break Bank info section
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                spacing: 16,
                children: [
                  const Text(
                    'Break Time Bank',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const BreakBankDisplay(),
                  const SizedBox(height: 8),
                  const BreakBankControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subjects Tab - Subject and break bank management
class _SubjectsTab extends ConsumerWidget {
  const _SubjectsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        spacing: 24,
        children: [
          // Subject management header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subject Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddSubjectDialog(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Subject'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          // Subject list
          SubjectListDisplay(
            onAddSubject: () {
              showDialog(
                context: context,
                builder: (context) => const AddSubjectDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Settings Tab - Configuration and feature info
class _SettingsTab extends ConsumerWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        spacing: 24,
        children: [
          // Study Ratio Configuration
          const StudyRatioSelector(),

          // Features info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.withValues(alpha: 0.1),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text(
                  'PartnerRemind Features',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '✅ Precision Timer - DateTime-based, survives system sleep\n'
                  '✅ Break Bank - Real-time persistence to local database\n'
                  '✅ Daily Reset - Automatic at 00:00 with user preferences\n'
                  '✅ Compact Mode - Always-on-top study bar\n'
                  '✅ Custom Title Bar - Dark mode with window controls\n'
                  '✅ Auto-accumulation - Break time earned based on study ratio\n'
                  '✅ Countdown Timer - Support for timed study sessions\n'
                  '✅ Multi-Tab UI - Organized desktop layout\n'
                  '✅ Subject Selection - Required for study session tracking\n'
                  '✅ Session Logging - All study sessions saved to database',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),

          // Version info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.withValues(alpha: 0.1),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'About',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text('PartnerRemind v1.0.0', style: TextStyle(fontSize: 12)),
                Text(
                  'Flutter Desktop Application',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
