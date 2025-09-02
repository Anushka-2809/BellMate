import 'package:flutter/material.dart';
import 'package:myapp/timetable.dart';

class AddTimetableScreen extends StatefulWidget {
  const AddTimetableScreen({super.key});

  @override
  State<AddTimetableScreen> createState() => _AddTimetableScreenState();
}

class _AddTimetableScreenState extends State<AddTimetableScreen> {
  final _subjectController = TextEditingController();
  final _timeController = TextEditingController();
  final _classNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Timetable'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _classNameController,
              decoration: const InputDecoration(
                labelText: 'Class Name',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newTimetable = Timetable(
                  subject: _subjectController.text,
                  time: _timeController.text,
                  className: _classNameController.text,
                  date: _selectedDate,
                );
                Navigator.pop(context, newTimetable);
              },
              child: const Text('Add Timetable'),
            ),
          ],
        ),
      ),
    );
  }
}
