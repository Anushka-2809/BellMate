import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/period_model.dart';
import 'package:myapp/set_alarm_screen.dart';
import 'package:myapp/timetable_provider.dart';
import 'package:myapp/notification_service.dart';
import 'package:myapp/bell_service.dart';
import 'package:myapp/notification_service.dart';
import 'package:myapp/bell_service.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late final NotificationService _notificationService;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final timetableProvider = Provider.of<TimetableProvider>(context, listen: false);
    final bellService = BellService();
    _notificationService = NotificationService(timetableProvider, bellService);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timetableProvider.loadTimetable();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notificationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context);
    final allPeriods = timetableProvider.periods;

    return Scaffold(
      body: allPeriods.isEmpty
          ? const Center(child: Text('No alarms scheduled.'))
          : ListView.builder(
              itemCount: allPeriods.length,
              itemBuilder: (context, index) {
                final period = allPeriods[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.alarm)),
                    title: Text(period.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${DateFormat.yMMMd().format(period.date)} at ${period.time.format(context)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: Colors.green),
                          tooltip: 'Preview Alarm',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SetAlarmScreen(period: period),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            timetableProvider.deletePeriod(period);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(
                        hintText: 'Enter task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor.withOpacity(0.95),
                      ),
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
                          initialEntryMode: TimePickerEntryMode.input,
                          helpText: 'Select Time (HH:MM)',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add'),
                  onPressed: () {
                    final subject = subjectController.text.trim();
                    if (subject.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a task name.')),
                      );
                      return;
                    }
                    final newPeriod = Period(
                      subject: subject,
                      date: selectedDate,
                      time: selectedTime,
                    );
                    Provider.of<TimetableProvider>(context, listen: false).addPeriod(newPeriod);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Scheduled "$subject" for ${selectedTime.format(context)}')),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
