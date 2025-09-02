import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/gradient_button.dart';
import 'package:myapp/timetable_provider.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final _subjectController = TextEditingController();
  String _selectedDay = 'Monday';
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    Provider.of<TimetableProvider>(context, listen: false).loadTimetable();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: timetableProvider.timetable[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                final entry = timetableProvider.timetable[_selectedDay]![index];
                return ListTile(
                  title: Text(entry['subject']!),
                  subtitle: Text(entry['time']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      timetableProvider.deleteEntry(_selectedDay, index);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: _selectedDay,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDay = newValue!;
                    });
                  },
                  items: <String>[
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                    'Sunday'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    hintText: 'Enter subject',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time: ${_selectedTime.format(context)}'),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: const Text('Select Time'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GradientButton(
                  onPressed: () {
                    if (_subjectController.text.isNotEmpty) {
                      timetableProvider.addEntry(
                        _selectedDay,
                        _subjectController.text,
                        _selectedTime.format(context),
                      );
                      _subjectController.clear();
                    }
                  },
                  text: 'Add Entry',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
