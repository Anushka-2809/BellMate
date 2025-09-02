import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/period_model.dart';

class TimetableProvider with ChangeNotifier {
  List<Period> _periods = [];

  TimetableProvider() {
    loadTimetable();
  }

  List<Period> get periods => _periods;

  List<Period> getEventsForDay(DateTime day) {
    return _periods
        .where((period) =>
            period.date.year == day.year &&
            period.date.month == day.month &&
            period.date.day == day.day)
        .toList();
  }

  Future<void> loadTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    final timetableData = prefs.getString('timetable_data');
    if (timetableData != null) {
      final decodedData = json.decode(timetableData) as List;
      _periods = decodedData.map((item) => Period.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = json.encode(_periods.map((p) => p.toJson()).toList());
    prefs.setString('timetable_data', encodedData);
  }

  void addPeriod(Period period) {
    _periods.add(period);
    _saveTimetable();
    notifyListeners();
  }

  void deletePeriod(Period period) {
    _periods.remove(period);
    _saveTimetable();
    notifyListeners();
  }
}
