import 'package:flutter/material.dart';
import 'package:myapp/add_timetable_screen.dart';
import 'package:myapp/timetable_list_screen.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTimetableScreen()),
                );
              },
              child: const Text('ADD TIMETABLE'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimetableListScreen()),
                );
              },
              child: const Text('TIMETABLE LIST'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // TODO: Implement Filter by Date
              },
              child: const Text('FILTER BY DATE'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // TODO: Implement Filter by Week
              },
              child: const Text('FILTER BY WEEK'),
            ),
          ],
        ),
      ),
    );
  }
}
