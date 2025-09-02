import 'package:flutter/material.dart';

class Period {
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Period({required this.name, required this.startTime, required this.endTime});

  // Convert a Period object into a Map object
  Map<String, dynamic> toJson() => {
        'name': name,
        'startTime': '${'${startTime.hour}'.padLeft(2, '0')}:${'${startTime.minute}'.padLeft(2, '0')}',
        'endTime': '${'${endTime.hour}'.padLeft(2, '0')}:${'${endTime.minute}'.padLeft(2, '0')}',
      };

  // Create a Period object from a Map object
  factory Period.fromJson(Map<String, dynamic> json) {
    final startTimeParts = json['startTime'].split(':');
    final endTimeParts = json['endTime'].split(':');

    return Period(
      name: json['name'],
      startTime: TimeOfDay(hour: int.parse(startTimeParts[0]), minute: int.parse(startTimeParts[1])),
      endTime: TimeOfDay(hour: int.parse(endTimeParts[0]), minute: int.parse(endTimeParts[1])),
    );
  }
}
