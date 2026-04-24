import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../providers/subject_provider.dart';

/// Dialog for editing an existing study subject
class EditSubjectDialog extends ConsumerStatefulWidget {
  final Subject subject;

  const EditSubjectDialog({super.key, required this.subject});

  @override
  ConsumerState<EditSubjectDialog> createState() => _EditSubjectDialogState();
}

class _EditSubjectDialogState extends ConsumerState<EditSubjectDialog> {
  late TextEditingController _subjectNameController;
  late TextEditingController _dailyTargetController;
  TextEditingController? _debtMinutesController;

  @override
  void initState() {
    super.initState();
    _subjectNameController = TextEditingController(text: widget.subject.name);
    _dailyTargetController = TextEditingController(
      text: widget.subject.dailyTargetMinutes.toString(),
    );
    if (widget.subject.carryOverMinutes < 0) {
      _debtMinutesController = TextEditingController(
        text: widget.subject.carryOverMinutes.abs().toString(),
      );
    }
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _dailyTargetController.dispose();
    _debtMinutesController?.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateSubject() async {
    final name = _subjectNameController.text.trim();
    final targetMinutesText = _dailyTargetController.text.trim();
    final debtMinutesText = _debtMinutesController?.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a subject name')),
      );
      return;
    }

    final targetMinutes = int.tryParse(targetMinutesText);
    if (targetMinutes == null || targetMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily target must be a positive number')),
      );
      return;
    }

    int carryOverMinutes = widget.subject.carryOverMinutes;
    if (widget.subject.carryOverMinutes < 0) {
      final parsedDebt = int.tryParse(debtMinutesText ?? '');
      if (parsedDebt == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debt minutes must be a valid integer')),
        );
        return;
      }

      if (parsedDebt < 0 ||
          parsedDebt > widget.subject.carryOverMinutes.abs()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Debt must be between 0 and ${widget.subject.carryOverMinutes.abs()}',
            ),
          ),
        );
        return;
      }

      carryOverMinutes = -parsedDebt;
    }

    try {
      final updatedSubject =
          Subject(
              name: name,
              dailyTargetMinutes: targetMinutes,
              studyTimeToday: widget.subject.studyTimeToday,
              carryOverMinutes: carryOverMinutes,
              isActive: widget.subject.isActive,
            )
            ..id = widget.subject.id
            ..createdAt = widget.subject.createdAt
            ..lastUpdated = DateTime.now()
            ..notes = widget.subject.notes;

      await ref.read(subjectProvider.notifier).updateSubject(updatedSubject);

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Subject "$name" updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error updating subject: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Subject'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
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
            if (widget.subject.carryOverMinutes < 0)
              TextField(
                controller: _debtMinutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Debt Minutes',
                  hintText: widget.subject.carryOverMinutes.abs().toString(),
                  helperText:
                      'Allowed range: 0 to ${widget.subject.carryOverMinutes.abs()}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.money_off),
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
          onPressed: _handleUpdateSubject,
          icon: const Icon(Icons.check),
          label: const Text('Save Changes'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
