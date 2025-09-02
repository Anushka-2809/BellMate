
import 'dart:convert';

class Note {
  String title;
  String content;

  Note({required this.title, required this.content});

  // Factory constructor to create a Note from a map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
    );
  }

  // Method to convert a Note to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }

  // Static method to encode a list of notes to a JSON string
  static String encode(List<Note> notes) => json.encode(
        notes
            .map<Map<String, dynamic>>((note) => note.toMap())
            .toList(),
      );

  // Static method to decode a JSON string to a list of notes
  static List<Note> decode(String notes) =>
      (json.decode(notes) as List<dynamic>)
          .map<Note>((item) => Note.fromMap(item))
          .toList();
}
