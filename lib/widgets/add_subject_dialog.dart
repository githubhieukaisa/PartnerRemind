import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subject_provider.dart';

/// Dialog for adding a new study subject
class AddSubjectDialog extends ConsumerStatefulWidget {
  const AddSubjectDialog({super.key});

  @override
  ConsumerState<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends ConsumerState<AddSubjectDialog> {
  late TextEditingController _subjectNameController;
  late TextEditingController _dailyTargetController;

  @override
  void initState() {
    super.initState();
    _subjectNameController = TextEditingController();
    _dailyTargetController = TextEditingController(
      text: '120',
    ); // Default 120 minutes
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _dailyTargetController.dispose();
    super.dispose();
  }

  void _handleAddSubject() async {
    final name = _subjectNameController.text.trim();
    final targetMinutesText = _dailyTargetController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a subject name')),
      );
      return;
    }

    final targetMinutes = int.tryParse(targetMinutesText) ?? 120;

    try {
      await ref
          .read(subjectProvider.notifier)
          .addSubject(name: name, dailyTargetMinutes: targetMinutes);

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Subject "$name" added successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error adding subject: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Subject'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            // Subject name input
            TextField(
              controller: _subjectNameController,
              decoration: InputDecoration(
                labelText: 'Subject Name',
                hintText: 'e.g., Mathematics, English',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.book),
              ),
              textInputAction: TextInputAction.next,
            ),

            // Daily target input
            TextField(
              controller: _dailyTargetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daily Target (minutes)',
                hintText: '120',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.timer),
                suffixText: 'min',
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
          onPressed: _handleAddSubject,
          icon: const Icon(Icons.check),
          label: const Text('Add Subject'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
