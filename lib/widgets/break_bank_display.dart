import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/break_bank_provider.dart';
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
                3600, // Normalize to 1 hour
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakBankNotifier = ref.read(breakBankProvider.notifier);

    return Column(
      spacing: 12,
      children: [
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
