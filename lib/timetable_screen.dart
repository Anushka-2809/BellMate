import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/period_model.dart';
import 'package:myapp/set_alarm_screen.dart';
import 'package:myapp/timetable_provider.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  Future<void> _showAddEntryDialog() async {
    final subjectController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    DateTime selectedDate = DateTime.now();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(hintText: 'Enter task'),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Date'),
                      subtitle: Text(DateFormat.yMMMd().format(selectedDate)),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Time'),
                      subtitle: Text(selectedTime.format(context)),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null && picked != selectedTime) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () {
                    if (subjectController.text.isNotEmpty) {
                      final newPeriod = Period(
                        subject: subjectController.text,
                        time: selectedTime,
                        date: selectedDate,
                      );
                      Provider.of<TimetableProvider>(context, listen: false)
                          .addPeriod(newPeriod);
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetAlarmScreen(period: newPeriod)));
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
      ),
      body: Consumer<TimetableProvider>(
        builder: (context, timetableProvider, child) {
          final periods = timetableProvider.periods;

          if (periods.isEmpty) {
            return const Center(
              child: Text(
                'No tasks scheduled.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          periods.sort((a, b) {
            int dateComp = a.date.compareTo(b.date);
            if (dateComp != 0) return dateComp;
            final aTime = a.time.hour * 60 + a.time.minute;
            final bTime = b.time.hour * 60 + b.time.minute;
            return aTime.compareTo(bTime);
          });

          final Map<DateTime, List<Period>> groupedPeriods = {};
          for (final period in periods) {
            final dateKey = DateTime(period.date.year, period.date.month, period.date.day);
            if (!groupedPeriods.containsKey(dateKey)) {
              groupedPeriods[dateKey] = [];
            }
            groupedPeriods[dateKey]!.add(period);
          }

          final sortedDates = groupedPeriods.keys.toList()..sort();

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final periodsForDate = groupedPeriods[date]!;
              final dateText = DateFormat.yMMMMEEEEd().format(date);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dateText,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                  ),
                  ...periodsForDate.map((period) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        title: Text(period.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(period.time.format(context)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            timetableProvider.deletePeriod(period);
                          },
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
