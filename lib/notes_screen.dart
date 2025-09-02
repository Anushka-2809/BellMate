import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/add_note_screen.dart';
import 'package:myapp/note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('notes');
    if (notesString != null) {
      setState(() {
        _notes = Note.decode(notesString);
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String notesString = Note.encode(_notes);
    await prefs.setString('notes', notesString);
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
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
          if (newNote != null) {
            setState(() {
              _notes.add(newNote);
            });
            _saveNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes yet.'))
          : _buildNotesList(cardColor, textColor, subTextColor),
    );
  }

  Widget _buildNotesList(Color cardColor, Color textColor, Color subTextColor) {
    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return _buildNoteCard(note.title, note.content, cardColor, textColor, subTextColor);
      },
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
