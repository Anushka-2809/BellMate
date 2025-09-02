import 'package:flutter/material.dart';
import 'package:myapp/add_timetable_screen.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime? _selectedDate;
  DateTime? _startOfWeek;
  DateTime? _endOfWeek;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTimetableScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildFilterBar(isDarkMode),
          const SizedBox(height: 20),
          Expanded(
            child: _buildTimetableList(cardColor, textColor, subTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: () => _selectDate(context), child: const Text("Filter by Date")),
        ElevatedButton(onPressed: () => _selectWeek(context), child: const Text("Filter by Week")),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _startOfWeek = null;
        _endOfWeek = null;
      });
    }
  }

  Future<void> _selectWeek(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startOfWeek ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = null;
        // Assuming Monday is the start of the week
        _startOfWeek = picked.subtract(Duration(days: picked.weekday - 1));
        _endOfWeek = _startOfWeek!.add(const Duration(days: 6));
      });
    }
  }

  Widget _buildTimetableList(Color cardColor, Color textColor, Color subTextColor) {
    // Dummy data for now
    final List<Map<String, dynamic>> timetableData = [
      {
        'subject': 'Maths',
        'time': '09:00 - 10:00',
        'className': 'Class 9th A',
        'date': DateTime.now(),
      },
      {
        'subject': 'Maths',
        'time': '10:00 - 11:00',
        'className': 'Class 8th C',
        'date': DateTime.now().add(const Duration(days: 1)),
      },
      {
        'subject': 'English',
        'time': '12:00 - 13:00',
        'className': 'Class 9th A',
        'date': DateTime.now(),
      },
       {
        'subject': 'Science',
        'time': '14:00 - 15:00',
        'className': 'Class 10th B',
        'date': DateTime.now().add(const Duration(days: 3)),
      },
      {
        'subject': 'History',
        'time': '11:00 - 12:00',
        'className': 'Class 7th A',
        'date': DateTime.now().subtract(const Duration(days: 2)),
      },
    ];

    final filteredList = timetableData.where((entry) {
      if (_selectedDate != null) {
        return entry['date'].year == _selectedDate!.year &&
            entry['date'].month == _selectedDate!.month &&
            entry['date'].day == _selectedDate!.day;
      } else if (_startOfWeek != null && _endOfWeek != null) {
        final entryDate = entry['date'];
        // The end of the day is right before midnight of the next day.
        final endOfWeekInclusive = _endOfWeek!.add(const Duration(days: 1));
        return (entryDate.isAtSameMomentAs(_startOfWeek!) || entryDate.isAfter(_startOfWeek!)) &&
               entryDate.isBefore(endOfWeekInclusive);
      }
      return true; // Show all if no filter is selected
    }).toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return _buildTimetableCard(item['subject'], item['time'], item['className'], cardColor, textColor, subTextColor, item['date']);
      },
    );
  }

  Widget _buildTimetableCard(String subject, String time, String className, Color cardColor, Color textColor, Color subTextColor, DateTime date) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, color: subTextColor, size: 16),
                const SizedBox(width: 8),
                Text(time, style: TextStyle(color: subTextColor, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 5),
            Text(className, style: TextStyle(color: subTextColor, fontSize: 14)),
             const SizedBox(height: 5),
            Text(DateFormat.yMMMd().format(date), style: TextStyle(color: subTextColor, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
