import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/navigation_provider.dart';
import '../providers/precision_timer_provider.dart';
import '../providers/recent_countdowns_provider.dart';
import '../providers/subject_provider.dart';

/// Subject-aware timer controls that disable Start/Countdown if no subject selected.
class SubjectAwareTimerControls extends ConsumerWidget {
  final bool subjectSelected;

  const SubjectAwareTimerControls({super.key, required this.subjectSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(precisionTimerProvider);
    final timerNotifier = ref.read(precisionTimerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        if (!subjectSelected)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red.withValues(alpha: 0.1),
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Select a subject first to start studying',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!timerState.isRunning && timerState.startTime == null)
              ElevatedButton.icon(
                onPressed: subjectSelected ? () => timerNotifier.start() : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            if (timerState.isRunning)
              ElevatedButton.icon(
                onPressed: () => timerNotifier.pause(),
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            if (!timerState.isRunning &&
                timerState.startTime == null &&
                timerState.elapsed > Duration.zero)
              ElevatedButton.icon(
                onPressed: () => timerNotifier.resume(),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            if (!timerState.isRunning &&
                timerState.startTime == null &&
                timerState.elapsed > Duration.zero)
              ElevatedButton.icon(
                onPressed: () async => await timerNotifier.stop(),
                icon: const Icon(Icons.stop),
                label: const Text('Stop & Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            if (!timerState.isRunning && timerState.startTime == null)
              ElevatedButton.icon(
                onPressed: subjectSelected
                    ? () => _showCountdownDialog(context)
                    : null,
                icon: const Icon(Icons.hourglass_bottom),
                label: const Text('Countdown'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showCountdownDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _CountdownDialog(),
    );
  }
}

class _CountdownDialog extends ConsumerStatefulWidget {
  const _CountdownDialog();

  @override
  ConsumerState<_CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends ConsumerState<_CountdownDialog> {
  late final TextEditingController controller;
  int? selectedMinutes = 25;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '25');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void selectMinutes(int minutes) {
    setState(() {
      selectedMinutes = minutes;
      controller.text = minutes.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recent = ref.watch(recentCountdownsProvider);
    final selectedId = ref.watch(selectedSubjectIdProvider);
    final subjects = ref.watch(subjectProvider);
    final selectedSubject = selectedId == null
        ? null
        : subjects.where((s) => s.id == selectedId).isEmpty
        ? null
        : subjects.firstWhere((s) => s.id == selectedId);
    final remainingMinutes = selectedSubject?.getRemainingMinutes() ?? 0;

    return AlertDialog(
      title: const Text('Start Countdown'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            const Text(
              'Quick Select:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (selectedSubject != null && remainingMinutes > 0)
                  Theme(
                    data: Theme.of(context).copyWith(
                      elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedMinutes == remainingMinutes
                              ? Colors.green
                              : Colors.green.withValues(alpha: 0.2),
                          foregroundColor: selectedMinutes == remainingMinutes
                              ? Colors.white
                              : Colors.green[900],
                        ),
                      ),
                    ),
                    child: _PresetButton(
                      label: 'Finish Target (${remainingMinutes}m)',
                      minutes: remainingMinutes,
                      isSelected: selectedMinutes == remainingMinutes,
                      onTap: () => selectMinutes(remainingMinutes),
                    ),
                  ),
                _PresetButton(
                  label: '15m',
                  minutes: 15,
                  isSelected: selectedMinutes == 15,
                  onTap: () => selectMinutes(15),
                ),
                _PresetButton(
                  label: '25m',
                  minutes: 25,
                  isSelected: selectedMinutes == 25,
                  onTap: () => selectMinutes(25),
                ),
                _PresetButton(
                  label: '50m',
                  minutes: 50,
                  isSelected: selectedMinutes == 50,
                  onTap: () => selectMinutes(50),
                ),
              ],
            ),
            if (recent.isNotEmpty) ...[
              const Divider(),
              const Text(
                'Recent:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recent
                    .map(
                      (minutes) => _PresetButton(
                        label: '${minutes}m',
                        minutes: minutes,
                        isSelected: selectedMinutes == minutes,
                        onTap: () => selectMinutes(minutes),
                      ),
                    )
                    .toList(),
              ),
            ],
            const Divider(),
            const Text(
              'Or enter custom minutes:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null && parsed > 0) {
                  setState(() {
                    selectedMinutes = parsed;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Minutes',
                prefixIcon: const Icon(Icons.timer),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (selectedMinutes != null && selectedMinutes! > 0) {
              final timerNotifier = ref.read(precisionTimerProvider.notifier);
              ref
                  .read(recentCountdownsProvider.notifier)
                  .addRecent(selectedMinutes!);
              timerNotifier.startCountdown(Duration(minutes: selectedMinutes!));
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final int minutes;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetButton({
    required this.label,
    required this.minutes,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.deepPurple : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: isSelected ? 4 : 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
