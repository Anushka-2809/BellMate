import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'period_model.dart';
import 'timetable_provider.dart';

class AddEditPeriodDialog extends StatefulWidget {
  final Period? period;
  final int? periodIndex;

  const AddEditPeriodDialog({super.key, this.period, this.periodIndex});

  @override
  State<AddEditPeriodDialog> createState() => _AddEditPeriodDialogState();
}

class _AddEditPeriodDialogState extends State<AddEditPeriodDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _name = widget.period?.name ?? '';
    _startTime = widget.period?.startTime ?? TimeOfDay.now();
    _endTime = widget.period?.endTime ?? TimeOfDay(hour: _startTime.hour + 1, minute: _startTime.minute);
  }

  Future<void> _selectTime(BuildContext context,
      {required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final timetableProvider =
          Provider.of<TimetableProvider>(context, listen: false);

      final newPeriod =
          Period(name: _name, startTime: _startTime, endTime: _endTime);

      if (widget.period == null) {
        timetableProvider.addPeriod(newPeriod);
      } else {
        timetableProvider.editPeriod(widget.periodIndex!, newPeriod);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.period == null ? 'Add Period' : 'Edit Period'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Period Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(_startTime.format(context)),
              onTap: () => _selectTime(context, isStartTime: true),
              trailing: const Icon(Icons.edit),
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(_endTime.format(context)),
              onTap: () => _selectTime(context, isStartTime: false),
              trailing: const Icon(Icons.edit),
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
          onPressed: _saveForm,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
