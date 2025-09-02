import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/bell_service.dart';
import 'package:myapp/period_model.dart';

class SetAlarmScreen extends StatefulWidget {
  final Period period;

  const SetAlarmScreen({super.key, required this.period});

  @override
  State<SetAlarmScreen> createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends State<SetAlarmScreen> {
  final BellService _bellService = BellService();

  @override
  void initState() {
    super.initState();
    _bellService.playBellSound();
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.jm();
    final dateFormat = DateFormat.yMMMMEEEEd();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Set'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.alarm_on,
              size: 100,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            Text(
              widget.period.subject,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'on ${dateFormat.format(widget.period.date)}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              'at ${timeFormat.format(DateTime(2023, 1, 1, widget.period.time.hour, widget.period.time.minute))}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
