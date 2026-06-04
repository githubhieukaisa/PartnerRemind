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
  TextEditingController? _debtSecondsController;
  int? _selectedStudyRatio;

  @override
  void initState() {
    super.initState();
    _subjectNameController = TextEditingController(text: widget.subject.name);
    _dailyTargetController = TextEditingController(
      text: widget.subject.dailyTargetMinutes.toString(),
    );
    _selectedStudyRatio = widget.subject.studyRatio;
    if (widget.subject.carryOverSeconds < 0) {
      _debtSecondsController = TextEditingController(
        text: (widget.subject.carryOverSeconds.abs() ~/ 60).toString(),
      );
    }
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _dailyTargetController.dispose();
    _debtSecondsController?.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateSubject() async {
    final name = _subjectNameController.text.trim();
    final targetMinutesText = _dailyTargetController.text.trim();
    final debtMinutesText = _debtSecondsController?.text.trim();

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

    int carryOverSeconds = widget.subject.carryOverSeconds;
    if (widget.subject.carryOverSeconds < 0) {
      final parsedDebtMinutes = int.tryParse(debtMinutesText ?? '');
      if (parsedDebtMinutes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debt minutes must be a valid integer')),
        );
        return;
      }

      final parsedDebtSeconds = parsedDebtMinutes * 60;

      if (parsedDebtSeconds < 0 ||
          parsedDebtSeconds > widget.subject.carryOverSeconds.abs()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Debt must be between 0 and ${widget.subject.carryOverSeconds.abs() ~/ 60}',
            ),
          ),
        );
        return;
      }

      carryOverSeconds = -parsedDebtSeconds;
    }

    try {
      final updatedSubject =
          Subject(
              name: name,
              dailyTargetMinutes: targetMinutes,
              studyTimeTodaySeconds: widget.subject.studyTimeTodaySeconds,
              carryOverSeconds: carryOverSeconds,
              studyRatio: _selectedStudyRatio,
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
            
            // Custom Study Ratio
            DropdownButtonFormField<int?>(
              value: _selectedStudyRatio,
              decoration: InputDecoration(
                labelText: 'Study/Break Ratio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.tune),
              ),
              items: const [
                DropdownMenuItem(
                  value: null,
                  child: Text('Global Default (from Settings)'),
                ),
                DropdownMenuItem(
                  value: 6,
                  child: Text('6:1 (Deep Work)'),
                ),
                DropdownMenuItem(
                  value: 12,
                  child: Text('12:1 (Light Task/Chores)'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('3:1 (Intense Focus)'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStudyRatio = value;
                });
              },
            ),

            if (widget.subject.carryOverSeconds < 0)
              TextField(
                controller: _debtSecondsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Debt Minutes',
                  hintText: (widget.subject.carryOverSeconds.abs() ~/ 60).toString(),
                  helperText:
                      'Allowed range: 0 to ${widget.subject.carryOverSeconds.abs() ~/ 60}',
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
