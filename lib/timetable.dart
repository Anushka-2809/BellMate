
import 'dart:convert';

class Timetable {
  String subject;
  String time;
  String className;
  DateTime date;

  Timetable({
    required this.subject,
    required this.time,
    required this.className,
    required this.date,
  });

  factory Timetable.fromMap(Map<String, dynamic> map) {
    return Timetable(
      subject: map['subject'],
      time: map['time'],
      className: map['className'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'time': time,
      'className': className,
      'date': date.toIso8601String(),
    };
  }

  static String encode(List<Timetable> timetables) => json.encode(
        timetables
            .map<Map<String, dynamic>>((timetable) => timetable.toMap())
            .toList(),
      );

  static List<Timetable> decode(String timetables) =>
      (json.decode(timetables) as List<dynamic>)
          .map<Timetable>((item) => Timetable.fromMap(item))
          .toList();
}
