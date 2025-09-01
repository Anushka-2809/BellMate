import 'package:flutter/material.dart';
import 'package:myapp/add_note_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
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
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: _buildNotesList(cardColor, textColor, subTextColor),
    );
  }

  Widget _buildNotesList(Color cardColor, Color textColor, Color subTextColor) {
    // Dummy data for now
    return ListView(
      children: [
        _buildNoteCard('Meeting Notes', 'Discuss project timeline and deliverables.', cardColor, textColor, subTextColor),
        _buildNoteCard('Shopping List', 'Milk, Bread, Eggs, Cheese.', cardColor, textColor, subTextColor),
        _buildNoteCard('Ideas', 'New feature for the app: collaborative notes.', cardColor, textColor, subTextColor),
      ],
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
