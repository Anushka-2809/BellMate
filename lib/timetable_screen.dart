import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/gradient_button.dart';
import 'package:myapp/period_model.dart';
import 'package:myapp/timetable_provider.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late final ValueNotifier<List<Period>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final _subjectController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Period> _getEventsForDay(DateTime day) {
    final timetableProvider = Provider.of<TimetableProvider>(context, listen: false);
    return timetableProvider.getEventsForDay(day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
      ),
      body: Column(
        children: [
          TableCalendar<Period>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Period>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (value.isEmpty) {
                  return const Center(
                    child: Text(
                      'No entries for this day.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                value.sort((a, b) {
                  final aTime = a.time.hour * 60 + a.time.minute;
                  final bTime = b.time.hour * 60 + b.time.minute;
                  return aTime.compareTo(bTime);
                });

                final Map<int, List<Period>> groupedEvents = {};
                for (final event in value) {
                  if (!groupedEvents.containsKey(event.time.hour)) {
                    groupedEvents[event.time.hour] = [];
                  }
                  groupedEvents[event.time.hour]!.add(event);
                }

                final sortedHours = groupedEvents.keys.toList()..sort();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: sortedHours.length,
                  itemBuilder: (context, index) {
                    final hour = sortedHours[index];
                    final eventsForHour = groupedEvents[hour]!;
                    final hourText = DateFormat('h a').format(DateTime(2023, 1, 1, hour));

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              hourText,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: eventsForHour.map((event) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    title: Text(event.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(event.time.format(context)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () {
                                        Provider.of<TimetableProvider>(context, listen: false)
                                            .deletePeriod(event);
                                        _selectedEvents.value = _getEventsForDay(_selectedDay!);
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    hintText: 'Enter subject',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time: ${_selectedTime.format(context)}'),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: const Text('Select Time'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GradientButton(
                  onPressed: () {
                    if (_subjectController.text.isNotEmpty) {
                      final newPeriod = Period(
                        subject: _subjectController.text,
                        time: _selectedTime,
                        date: _selectedDay!,
                      );
                      Provider.of<TimetableProvider>(context, listen: false)
                          .addPeriod(newPeriod);
                      _subjectController.clear();
                      _selectedEvents.value = _getEventsForDay(_selectedDay!);
                    }
                  },
                  text: 'Add Entry',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
