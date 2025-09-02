import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'period_model.dart';

class TimetableProvider with ChangeNotifier {
  List<Period> _periods = [];

  List<Period> get periods => _periods;

  static const String _timetableKey = 'timetable';

  Future<void> loadPeriods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? timetableString = prefs.getString(_timetableKey);

    if (timetableString != null) {
      final List<dynamic> timetableJson = jsonDecode(timetableString);
      _periods = timetableJson.map((json) => Period.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _savePeriods() async {
    final prefs = await SharedPreferences.getInstance();
    final String timetableString =
        jsonEncode(_periods.map((period) => period.toJson()).toList());
    await prefs.setString(_timetableKey, timetableString);
  }

  Future<void> addPeriod(Period period) async {
    _periods.add(period);
    await _savePeriods();
    notifyListeners();
  }

  Future<void> editPeriod(int index, Period period) async {
    if (index >= 0 && index < _periods.length) {
      _periods[index] = period;
      await _savePeriods();
      notifyListeners();
    }
  }

  Future<void> deletePeriod(int index) async {
    if (index >= 0 && index < _periods.length) {
      _periods.removeAt(index);
      await _savePeriods();
      notifyListeners();
    }
  }
}
