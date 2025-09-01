import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTimetableScreen extends StatefulWidget {
  const AddTimetableScreen({super.key});

  @override
  State<AddTimetableScreen> createState() => _AddTimetableScreenState();
}

class _AddTimetableScreenState extends State<AddTimetableScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final timePickerTheme = TimePickerTheme.of(context).copyWith(
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[200],
      hourMinuteShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      dayPeriodBorderSide: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
      ),
      dayPeriodColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Theme.of(context).colorScheme.primary
              : isDarkMode
                  ? Colors.grey[800]!
                  : Colors.grey[300]!),
      dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Colors.white
              : isDarkMode
                  ? Colors.white
                  : Colors.black),
      hourMinuteColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Theme.of(context).colorScheme.primary
              : isDarkMode
                  ? Colors.grey[800]!
                  : Colors.grey[300]!),
      hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Colors.white
              : isDarkMode
                  ? Colors.white
                  : Colors.black),
      dialHandColor: Theme.of(context).colorScheme.primary,
      dialBackgroundColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      dialTextColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Colors.white
              : isDarkMode
                  ? Colors.white
                  : Colors.black),
      entryModeIconColor: Theme.of(context).colorScheme.primary,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Add Timetable')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              _buildDateTimePicker(
                labelText: 'Date',
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: 20),
              _buildTimePicker(
                labelText: 'Time',
                selectedTime: _selectedTime,
                onTimeSelected: (time) => setState(() => _selectedTime = time),
                timePickerTheme: timePickerTheme,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implement save logic
                  }
                },
                child: const Text('SUBMIT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String labelText,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          selectedDate != null
              ? DateFormat.yMMMd().format(selectedDate)
              : 'Select Date',
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required String labelText,
    required TimeOfDay? selectedTime,
    required Function(TimeOfDay) onTimeSelected,
    required TimePickerThemeData timePickerTheme,
  }) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(timePickerTheme: timePickerTheme),
              child: child!,
            );
          },
        );
        if (time != null) {
          onTimeSelected(time);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          selectedTime != null
              ? selectedTime.format(context)
              : 'Select Time',
        ),
      ),
    );
  }
}
