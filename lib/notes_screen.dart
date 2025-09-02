import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/notes_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _titleController = TextEditingController();
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
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: notesProvider.notes.isEmpty
                ? Center(
                    child: Text(
                      'No notes yet. Add your first note!',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: notesProvider.notes.length,
                    itemBuilder: (context, index) {
                      final note = notesProvider.notes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(note.body, style: const TextStyle(fontSize: 16)),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              notesProvider.deleteNote(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Note title',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.title),
                          filled: true,
                          fillColor: Theme.of(context).cardColor.withOpacity(0.9),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          hintText: 'Enter your note',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.note_add_outlined),
                          filled: true,
                          fillColor: Theme.of(context).cardColor.withOpacity(0.9),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          final title = _titleController.text.trim();
                          final body = _noteController.text.trim();
                          if (title.isNotEmpty || body.isNotEmpty) {
                            notesProvider.addNote(title: title.isEmpty ? 'Untitled' : title, body: body);
                            _titleController.clear();
                            _noteController.clear();
                          }
                        },
                        minLines: 1,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final title = _titleController.text.trim();
                    final body = _noteController.text.trim();
                    if (title.isNotEmpty || body.isNotEmpty) {
                      notesProvider.addNote(title: title.isEmpty ? 'Untitled' : title, body: body);
                      _titleController.clear();
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
