import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteItem {
  final String title;
  final String body;
  final DateTime createdAt;

  NoteItem({required this.title, required this.body, required this.createdAt});

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
      };

  factory NoteItem.fromJson(Map<String, dynamic> json) => NoteItem(
        title: json['title'] ?? '',
        body: json['body'] ?? (json['note'] ?? ''),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}

class NotesProvider with ChangeNotifier {
  List<NoteItem> _notes = [];

  List<NoteItem> get notes => [..._notes];

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesData = prefs.getString('notes');
    if (notesData != null) {
      final decoded = json.decode(notesData);
      if (decoded is List) {
        // Try new schema first
        _notes = decoded
            .map((e) => e is Map<String, dynamic>
                ? NoteItem.fromJson(e)
                : NoteItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else if (decoded is Map && decoded['items'] is List) {
        _notes = (decoded['items'] as List)
            .map((e) => NoteItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      notifyListeners();
      return;
    }

    // Backward compatibility for old simple string list
    final legacyNotes = prefs.getString('notes_legacy');
    if (legacyNotes != null) {
      final legacyList = List<String>.from(json.decode(legacyNotes));
      _notes = legacyList
          .map((s) => NoteItem(title: s.split('\n').first, body: s, createdAt: DateTime.now()))
          .toList();
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_notes.map((n) => n.toJson()).toList());
    await prefs.setString('notes', encoded);
  }

  void addNote({required String title, required String body}) {
    _notes.add(NoteItem(title: title, body: body, createdAt: DateTime.now()));
    _saveNotes();
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    _saveNotes();
    notifyListeners();
  }
}
