import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_state.dart';
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
    final currentElapsed = timerState.getDisplayTime();
    final isBreakMode = timerState.mode == TimerMode.breakCountdown;
    final timerAccent = isBreakMode ? Colors.orange : Colors.deepPurple;
    final timerBackground = (isBreakMode ? Colors.amber : Colors.deepPurple)
        .withValues(alpha: 0.1);

    final statusText = isBreakMode
        ? (timerState.isRunning ? 'Resting' : 'Break Paused')
        : (timerState.isRunning ? 'Running' : 'Paused');

    final statusColor = isBreakMode
        ? (timerState.isRunning ? Colors.amber : Colors.orange)
        : (timerState.isRunning ? Colors.green : Colors.orange);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Timer display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: timerBackground,
            border: Border.all(color: timerAccent, width: 2),
          ),
          child: Text(
            formatDuration(currentElapsed),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: timerAccent,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Status and Mode indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            // Running/Paused status
            Chip(
              label: Text(
                statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: statusColor,
            ),

            // Timer mode indicator
            if (timerState.mode == TimerMode.countdown)
              Chip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Icon(Icons.hourglass_bottom, size: 16, color: Colors.white),
                    Text(
                      'Countdown',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.deepPurple,
              )
            else if (timerState.mode == TimerMode.breakCountdown)
              const Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Icon(Icons.self_improvement, size: 16, color: Colors.white),
                    Text(
                      'Break Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange,
              ),
          ],
        ),
      ],
    );
  }
}
