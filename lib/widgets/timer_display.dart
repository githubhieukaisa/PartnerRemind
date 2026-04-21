import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/precision_timer_provider.dart';

/// Formats a Duration into a readable string (HH:MM:SS.ms)
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;
  final milliseconds =
      (duration.inMilliseconds % 1000) ~/ 10; // Show centiseconds

  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}.'
      '${milliseconds.toString().padLeft(2, '0')}';
}

/// Displays the precision timer with real-time updates
class TimerDisplay extends ConsumerWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(precisionTimerProvider);
    final currentElapsed = timerState.getCurrentElapsed();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Timer display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.deepPurple.withValues(alpha: 0.1),
            border: Border.all(color: Colors.deepPurple, width: 2),
          ),
          child: Text(
            formatDuration(currentElapsed),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.deepPurple,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Status indicator
        Chip(
          label: Text(
            timerState.isRunning ? 'Running' : 'Paused',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: timerState.isRunning ? Colors.green : Colors.orange,
        ),
      ],
    );
  }
}

/// Control buttons for the timer
class TimerControls extends ConsumerWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(precisionTimerProvider);
    final timerNotifier = ref.read(precisionTimerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Start button
        if (!timerState.isRunning && timerState.startTime == null)
          ElevatedButton.icon(
            onPressed: () => timerNotifier.start(),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),

        // Resume button
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),

        // Pause button
        if (timerState.isRunning)
          ElevatedButton.icon(
            onPressed: () => timerNotifier.pause(),
            icon: const Icon(Icons.pause),
            label: const Text('Pause'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),

        // Stop button
        if (timerState.elapsed > Duration.zero)
          ElevatedButton.icon(
            onPressed: () => timerNotifier.stop(),
            icon: const Icon(Icons.stop),
            label: const Text('Stop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
      ],
    );
  }
}
