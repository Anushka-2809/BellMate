import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_edit_period_dialog.dart';
import 'period_model.dart';
import 'timetable_provider.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  void _showAddEditDialog(BuildContext context, {Period? period, int? index}) {
    showDialog(
      context: context,
      builder: (context) =>
          AddEditPeriodDialog(period: period, periodIndex: index),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Period'),
        content: const Text('Are you sure you want to delete this period?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TimetableProvider>(context, listen: false)
                  .deletePeriod(index);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
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
          if (timetableProvider.periods.isEmpty) {
            return const Center(
              child: Text('No periods scheduled. Tap + to add one.'),
            );
          }
          return ListView.builder(
            itemCount: timetableProvider.periods.length,
            itemBuilder: (context, index) {
              final period = timetableProvider.periods[index];
              return ListTile(
                title: Text(period.name),
                subtitle: Text(
                    '${period.startTime.format(context)} - ${period.endTime.format(context)}'),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddEditDialog(context, period: period, index: index);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, index);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
