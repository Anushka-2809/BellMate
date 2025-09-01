import 'package:flutter/material.dart';

class TimetableListScreen extends StatelessWidget {
  const TimetableListScreen({super.key});

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
        title: Text('Timetable List', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            _buildTimetableCard('Maths', '09:00 - 10:00', 'Class 9th A', cardColor, textColor, subTextColor),
            _buildTimetableCard('Maths', '10:00 - 11:00', 'Class 8th C', cardColor, textColor, subTextColor),
            _buildTimetableCard('English', '12:00 - 13:00', 'Class 9th A', cardColor, textColor, subTextColor),
            _buildTimetableCard('Science', '14:00 - 15:00', 'Class 10th B', cardColor, textColor, subTextColor),
            _buildTimetableCard('History', '15:00 - 16:00', 'Class 7th D', cardColor, textColor, subTextColor),
          ],
        ),
      ),
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
}
