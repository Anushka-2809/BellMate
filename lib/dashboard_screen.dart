import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // 0 for Timetable, 1 for Notes

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey.shade200;
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text('Dashboard', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: textColor),
            onPressed: () {
              // TODO: Implement logout functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _buildToggleButtons(isDarkMode),
            const SizedBox(height: 20),
            _buildFilterTextField(isDarkMode),
            const SizedBox(height: 20),
            Expanded(
              child: _selectedIndex == 0
                  ? _buildTimetableList(cardColor, textColor, subTextColor) // Timetable View
                  : _buildNotesList(cardColor, textColor, subTextColor), // Notes View
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: _selectedIndex == 0 ? (isDarkMode ? Colors.black : Colors.white) : Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => setState(() => _selectedIndex = 0),
              child: Text('Timetable', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            ),
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: _selectedIndex == 1 ? (isDarkMode ? Colors.black : Colors.white) : Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => setState(() => _selectedIndex = 1),
              child: Text('Notes', style: TextStyle(color: _selectedIndex == 1 ? (isDarkMode ? Colors.white : Colors.black) : (isDarkMode ? Colors.white54 : Colors.black54))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTextField(bool isDarkMode) {
    return TextField(
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: 'Filter by week...',
        hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: const Icon(Icons.filter_list, color: Colors.grey),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTimetableList(Color cardColor, Color textColor, Color subTextColor) {
    return ListView(
      children: [
        _buildTimetableCard('Maths', '09:00 - 10:00', 'Class 9th A', cardColor, textColor, subTextColor),
        _buildTimetableCard('Maths', '10:00 - 11:00', 'Class 8th C', cardColor, textColor, subTextColor),
        _buildTimetableCard('English', '12:00 - 13:00', 'Class 9th A', cardColor, textColor, subTextColor),
      ],
    );
  }

  Widget _buildNotesList(Color cardColor, Color textColor, Color subTextColor) {
    return ListView(
      children: [
        _buildNoteCard('Meeting Notes', 'Discuss project timeline and deliverables.', cardColor, textColor, subTextColor),
        _buildNoteCard('Shopping List', 'Milk, Bread, Eggs, Cheese.', cardColor, textColor, subTextColor),
        _buildNoteCard('Ideas', 'New feature for the app: collaborative notes.', cardColor, textColor, subTextColor),
      ],
    );
  }

  Widget _buildTimetableCard(String subject, String time, String className, Color cardColor, Color textColor, Color subTextColor) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(String title, String content, Color cardColor, Color textColor, Color subTextColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(content, style: TextStyle(color: subTextColor, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
