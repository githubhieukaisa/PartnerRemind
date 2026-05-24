import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/break_bank_provider.dart';
import '../providers/precision_timer_provider.dart';
import '../providers/recent_countdowns_provider.dart';
import 'timer_display.dart';

/// Displays the accumulated break time bank
class BreakBankDisplay extends ConsumerWidget {
  const BreakBankDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakBank = ref.watch(breakBankProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.amber.withValues(alpha: 0.1),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Break Bank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              Text(
                formatDuration(breakBank.totalBreakTime),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value:
                breakBank.totalBreakTime.inSeconds /
                86400, // Normalize to 1 day
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

/// Controls for managing the break bank
class BreakBankControls extends ConsumerWidget {
  const BreakBankControls({super.key});

  void _showTakeBreakDialog(BuildContext context, int maxAvailableMinutes) {
    showDialog(
      context: context,
      builder: (context) =>
          _TakeBreakDialog(maxAvailableMinutes: maxAvailableMinutes),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakBank = ref.watch(breakBankProvider);
    final timerState = ref.watch(precisionTimerProvider);
    final breakBankNotifier = ref.read(breakBankProvider.notifier);
    final hasBreakTime = breakBank.totalBreakTime > Duration.zero;
    final timerBusy =
        timerState.isRunning || timerState.elapsed > Duration.zero;

    return Column(
      spacing: 12,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: (!hasBreakTime || timerBusy)
                ? null
                : () {
                    _showTakeBreakDialog(
                      context,
                      breakBank.totalBreakTime.inMinutes,
                    );
                  },
            icon: const Icon(Icons.self_improvement),
            label: Text(
              timerBusy
                  ? 'Finish Current Timer First'
                  : 'Take a Break (${formatDuration(breakBank.totalBreakTime)})',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
            ),
          ),
        ),

        // Quick add buttons for break time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _QuickAddButton(
              label: '+5m',
              duration: const Duration(minutes: 5),
              onPressed: () async => await breakBankNotifier.addBreakTime(
                const Duration(minutes: 5),
              ),
            ),
            _QuickAddButton(
              label: '+15m',
              duration: const Duration(minutes: 15),
              onPressed: () async => await breakBankNotifier.addBreakTime(
                const Duration(minutes: 15),
              ),
            ),
            _QuickAddButton(
              label: '+30m',
              duration: const Duration(minutes: 30),
              onPressed: () async => await breakBankNotifier.addBreakTime(
                const Duration(minutes: 30),
              ),
            ),
          ],
        ),
        // Reset button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async => await breakBankNotifier.reset(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Break Bank'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.7),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _TakeBreakDialog extends ConsumerStatefulWidget {
  final int maxAvailableMinutes;

  const _TakeBreakDialog({required this.maxAvailableMinutes});

  @override
  ConsumerState<_TakeBreakDialog> createState() => _TakeBreakDialogState();
}

class _TakeBreakDialogState extends ConsumerState<_TakeBreakDialog> {
  late final TextEditingController _minutesController;
  int? _selectedMinutes;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.maxAvailableMinutes;
    _minutesController = TextEditingController(
      text: widget.maxAvailableMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  void _selectMinutes(int minutes) {
    setState(() {
      _selectedMinutes = minutes;
      _minutesController.text = minutes.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recent = ref.watch(recentCountdownsProvider);
    final recentForBreak = recent
        .where(
          (minutes) => minutes > 0 && minutes <= widget.maxAvailableMinutes,
        )
        .toList();

    return AlertDialog(
      title: const Text('Take a Break'),
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
                _BreakPresetButton(
                  label: '5m',
                  minutes: 5,
                  isSelected: _selectedMinutes == 5,
                  onTap: () => _selectMinutes(5),
                ),
                _BreakPresetButton(
                  label: '10m',
                  minutes: 10,
                  isSelected: _selectedMinutes == 10,
                  onTap: () => _selectMinutes(10),
                ),
                _BreakPresetButton(
                  label: '15m',
                  minutes: 15,
                  isSelected: _selectedMinutes == 15,
                  onTap: () => _selectMinutes(15),
                ),
              ],
            ),
            if (recentForBreak.isNotEmpty) ...[
              const Divider(),
              const Text(
                'Recent:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recentForBreak
                    .map(
                      (minutes) => _BreakPresetButton(
                        label: '${minutes}m',
                        minutes: minutes,
                        isSelected: _selectedMinutes == minutes,
                        onTap: () => _selectMinutes(minutes),
                      ),
                    )
                    .toList(),
              ),
            ],
            const Divider(),
            TextField(
              controller: _minutesController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null && parsed > 0) {
                  setState(() {
                    _selectedMinutes = parsed;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Break Minutes',
                helperText: 'Max available: ${widget.maxAvailableMinutes} min',
                border: const OutlineInputBorder(),
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
        ElevatedButton(
          onPressed: () {
            final enteredMinutes = int.tryParse(_minutesController.text);

            if (enteredMinutes == null ||
                enteredMinutes <= 0 ||
                enteredMinutes > widget.maxAvailableMinutes) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Please enter a value between 1 and ${widget.maxAvailableMinutes} minutes.',
                  ),
                ),
              );
              return;
            }

            ref
                .read(recentCountdownsProvider.notifier)
                .addRecent(enteredMinutes);
            ref
                .read(precisionTimerProvider.notifier)
                .startBreak(Duration(minutes: enteredMinutes));
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black87,
          ),
          child: const Text('Start Break'),
        ),
      ],
    );
  }
}

class _BreakPresetButton extends StatelessWidget {
  final String label;
  final int minutes;
  final bool isSelected;
  final VoidCallback onTap;

  const _BreakPresetButton({
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
        backgroundColor: isSelected ? Colors.amber[700] : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: isSelected ? 3 : 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

/// Individual quick-add button for break time
class _QuickAddButton extends StatelessWidget {
  final String label;
  final Duration duration;
  final Future<void> Function() onPressed;

  const _QuickAddButton({
    required this.label,
    required this.duration,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
