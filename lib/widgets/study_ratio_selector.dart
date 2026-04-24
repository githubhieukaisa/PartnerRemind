import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/study_ratio_provider.dart';

/// Widget for selecting and configuring study/break ratio
class StudyRatioSelector extends ConsumerWidget {
  const StudyRatioSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratio = ref.watch(studyRatioProvider);
    final ratioNotifier = ref.read(studyRatioProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.withValues(alpha: 0.1),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          // Header
          const Row(
            children: [
              Icon(Icons.speed, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Study/Break Ratio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          // Current ratio display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue.withValues(alpha: 0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Ratio:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  ratio.getRatioDisplay(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          // Preset ratio buttons
          const Text(
            'Quick Select:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RatioButton(
                label: '6:1',
                isSelected: ratio.studyMinutes == 6 && ratio.breakMinutes == 1,
                onPressed: () => ratioNotifier.setRatio6to1(),
              ),
              _RatioButton(
                label: '5:1',
                isSelected: ratio.studyMinutes == 5 && ratio.breakMinutes == 1,
                onPressed: () => ratioNotifier.setRatio5to1(),
              ),
              _RatioButton(
                label: '4:1',
                isSelected: ratio.studyMinutes == 4 && ratio.breakMinutes == 1,
                onPressed: () => ratioNotifier.setRatio4to1(),
              ),
            ],
          ),

          // Info text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.amber.withValues(alpha: 0.1),
            ),
            child: Text(
              'For every ${ratio.studyMinutes} minutes of study, you earn ${ratio.breakMinutes} minute${ratio.breakMinutes > 1 ? 's' : ''} of break time.',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual ratio button
class _RatioButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _RatioButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
