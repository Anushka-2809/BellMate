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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Title (optional)',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: const Icon(Icons.title),
                              filled: true,
                              fillColor: Theme.of(context).cardColor.withOpacity(0.9),
                            ),
                            onChanged: (value) {},
                            onSubmitted: (_) {},
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _noteController,
                            decoration: InputDecoration(
                              hintText: 'Write your note...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: const Icon(Icons.note_add_outlined),
                              filled: true,
                              fillColor: Theme.of(context).cardColor.withOpacity(0.9),
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              final body = _noteController.text.trim();
                              if (body.isNotEmpty) {
                                notesProvider.addNote(title: 'Note', body: body);
                                _noteController.clear();
                              }
                            },
                            minLines: 1,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Send'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final body = _noteController.text.trim();
                      if (body.isNotEmpty) {
                        notesProvider.addNote(title: 'Note', body: body);
                        _noteController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
