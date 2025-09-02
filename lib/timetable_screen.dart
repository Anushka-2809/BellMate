import 'package:flutter/material.dart';
import 'package:myapp/add_timetable_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/timetable.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime? _selectedDate;
  DateTime? _startOfWeek;
  DateTime? _endOfWeek;
  List<Timetable> _timetables = [];

  @override
  void initState() {
    super.initState();
    _loadTimetables();
  }

  Future<void> _loadTimetables() async {
    final prefs = await SharedPreferences.getInstance();
    final String? timetablesString = prefs.getString('timetables');
    if (timetablesString != null) {
      setState(() {
        _timetables = Timetable.decode(timetablesString);
      });
    }
  }

  Future<void> _saveTimetables() async {
    final prefs = await SharedPreferences.getInstance();
    final String timetablesString = Timetable.encode(_timetables);
    await prefs.setString('timetables', timetablesString);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTimetable = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTimetableScreen()),
          );
          if (newTimetable != null) {
            setState(() {
              _timetables.add(newTimetable);
            });
            _saveTimetables();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildFilterBar(isDarkMode),
          const SizedBox(height: 20),
          Expanded(
            child: _timetables.isEmpty
                ? const Center(child: Text('No timetable entries yet.'))
                : _buildTimetableList(cardColor, textColor, subTextColor),
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
        _startOfWeek = picked.subtract(Duration(days: picked.weekday - 1));
        _endOfWeek = _startOfWeek!.add(const Duration(days: 6));
      });
    }
  }

  Widget _buildTimetableList(Color cardColor, Color textColor, Color subTextColor) {
    final filteredList = _timetables.where((entry) {
      if (_selectedDate != null) {
        return entry.date.year == _selectedDate!.year &&
            entry.date.month == _selectedDate!.month &&
            entry.date.day == _selectedDate!.day;
      } else if (_startOfWeek != null && _endOfWeek != null) {
        final entryDate = entry.date;
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
        return _buildTimetableCard(item.subject, item.time, item.className, cardColor, textColor, subTextColor, item.date);
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
