import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/precision_timer_provider.dart';
import '../widgets/timer_display.dart';

/// Compact horizontal study bar for always-on-top mode
/// Shows only essential timer info in a minimal horizontal layout
class CompactStudyBar extends ConsumerWidget {
  const CompactStudyBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(precisionTimerProvider);
    final timerNotifier = ref.read(precisionTimerProvider.notifier);
    final currentElapsed = timerState.getDisplayTime();

    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Timer display - compact
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Study Time',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formatDuration(currentElapsed),
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: timerState.isRunning
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: timerState.isRunning ? Colors.green : Colors.orange,
                width: 1,
              ),
            ),
            child: Text(
              timerState.isRunning ? 'RUNNING' : 'PAUSED',
              style: TextStyle(
                color: timerState.isRunning ? Colors.green : Colors.orange,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Control buttons - minimal
          GestureDetector(
            onTap: () {
              if (timerState.isRunning) {
                timerNotifier.pause();
              } else if (timerState.elapsed > Duration.zero) {
                timerNotifier.resume();
              } else {
                timerNotifier.start();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                timerState.isRunning ? Icons.pause : Icons.play_arrow,
                size: 20,
                color: Colors.deepPurple,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Stop button
          GestureDetector(
            onTap: () => timerNotifier.stop(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.stop, size: 20, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
