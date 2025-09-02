import 'package:flutter/material.dart';
import 'package:myapp/notes_screen.dart';
import 'package:myapp/timetable_screen.dart';

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
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

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
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  TimetableScreen(),
                  NotesScreen(),
                ],
              ),
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
}