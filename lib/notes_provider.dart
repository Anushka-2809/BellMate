import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesProvider with ChangeNotifier {
  List<String> _notes = [];

  List<String> get notes => [..._notes];

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesData = prefs.getString('notes');
    if (notesData != null) {
      _notes = List<String>.from(json.decode(notesData));
      notifyListeners();
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('notes', json.encode(_notes));
  }

  void addNote(String note) {
    _notes.add(note);
    _saveNotes();
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    _saveNotes();
    notifyListeners();
  }
}
