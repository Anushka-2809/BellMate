import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimetableProvider with ChangeNotifier {
  Map<String, List<Map<String, String>>> _timetable = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  Map<String, List<Map<String, String>>> get timetable => {..._timetable};

  Future<void> loadTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    final timetableData = prefs.getString('timetable');
    if (timetableData != null) {
      final decodedData = json.decode(timetableData) as Map<String, dynamic>;;
      _timetable = decodedData.map((key, value) {
        // Convert each entry in the list to the correct type
        final list = (value as List).map((item) => Map<String, String>.from(item)).toList();
        return MapEntry(key, list);
      });
      notifyListeners();
    }
  }

  Future<void> _saveTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('timetable', json.encode(_timetable));
  }

  void addEntry(String day, String subject, String time) {
    _timetable[day]?.add({'subject': subject, 'time': time});
    _saveTimetable();
    notifyListeners();
  }

  void deleteEntry(String day, int index) {
    _timetable[day]?.removeAt(index);
    _saveTimetable();
    notifyListeners();
  }
}
