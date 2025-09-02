import 'package:flutter/material.dart';
import 'package:myapp/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _noteController = TextEditingController();

  void _saveNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final lines = text.split('\n');
    final newNote = Note(
      title: lines.first,
      content: lines.skip(1).join('\n'),
    );

    Navigator.pop(context, newNote);
  }

  void _sendNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final lines = text.split('\n');
    final newNote = Note(
      title: lines.first,
      content: lines.skip(1).join('\n'),
    );


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Note sent successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "New Note",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: "Save Note",
            onPressed: _saveNote,
          ),
          IconButton(
            icon: const Icon(Icons.send),
            tooltip: "Send Note",
            onPressed: _sendNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _noteController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 16, height: 1.5),
          decoration: InputDecoration(
            hintText: "Title\n\nStart writing your note here...",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }
}
