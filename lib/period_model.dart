import 'package:flutter/material.dart';

class Period {
  final String subject;
  final TimeOfDay time;
  final DateTime date;

  Period({required this.subject, required this.time, required this.date});

  // For JSON serialization/deserialization
  Map<String, dynamic> toJson() => {
        'subject': subject,
        'time': '${time.hour}:${time.minute}',
        'date': date.toIso8601String(),
      };

  factory Period.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['time'] as String).split(':');
    return Period(
      subject: json['subject'],
      time: TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      date: DateTime.parse(json['date']),
    );
  }
}
