import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../providers/subject_provider.dart';
import 'edit_subject_dialog.dart';

/// Widget to display list of study subjects
class SubjectListDisplay extends ConsumerWidget {
  final VoidCallback? onAddSubject;

  const SubjectListDisplay({super.key, this.onAddSubject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider);

    if (subjects.isEmpty) {
      return _EmptySubjectList(onAddSubject: onAddSubject);
    }

    // Just return the subject list (header is in parent _SubjectsTab)
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return _SubjectCard(subject: subject);
      },
    );
  }
}

/// Empty state when no subjects are added
class _EmptySubjectList extends StatelessWidget {
  final VoidCallback? onAddSubject;

  const _EmptySubjectList({this.onAddSubject});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Icon(Icons.book_outlined, size: 48, color: Colors.grey[400]),
          const Text(
            'No subjects yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const Text(
            'Add a subject to start tracking your study progress',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          ElevatedButton.icon(
            onPressed: onAddSubject,
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Subject'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual subject card
class _SubjectCard extends ConsumerWidget {
  final Subject subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressPercent = subject.getProgressPercentage();
    final remainingMinutes = subject.getRemainingMinutes();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            // Subject name and target
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subject.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${subject.studyTimeToday}/${subject.effectiveTargetMinutes} min',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (subject.carryOverMinutes != 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subject.carryOverMinutes < 0
                                  ? '${subject.carryOverMinutes}m debt from yesterday'
                                  : '+${subject.carryOverMinutes}m surplus',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: subject.carryOverMinutes < 0
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      tooltip: 'Edit subject',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              EditSubjectDialog(subject: subject),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      tooltip: 'Delete subject',
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Subject'),
                              content: Text(
                                'Are you sure you want to delete ${subject.name}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldDelete == true) {
                          await ref
                              .read(subjectProvider.notifier)
                              .deleteSubject(subject.id);
                        }
                      },
                      icon: const Icon(Icons.delete, size: 18),
                      color: Colors.red,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),

            // Progress bar
            LinearProgressIndicator(
              value: progressPercent.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                remainingMinutes <= 0 ? Colors.green : Colors.deepPurple,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),

            // Status
            if (remainingMinutes > 0)
              Text(
                '$remainingMinutes minutes remaining',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              )
            else
              const Text(
                '✅ Daily target reached!',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
