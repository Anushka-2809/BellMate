import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/notes_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load notes when the screen is initialized
    Provider.of<NotesProvider>(context, listen: false).loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notesProvider.notes.length,
              itemBuilder: (context, index) {
                final note = notesProvider.notes[index];
                return ListTile(
                  title: Text(note),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      notesProvider.deleteNote(index);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new note',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_noteController.text.isNotEmpty) {
                      notesProvider.addNote(_noteController.text);
                      _noteController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
