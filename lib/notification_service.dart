import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/bell_service.dart';
import 'package:myapp/timetable_provider.dart';
import 'package:myapp/period_model.dart';

class NotificationService {
  final TimetableProvider _timetableProvider;
  final BellService _bellService;
  Timer? _timer;

  NotificationService(this._timetableProvider, this._bellService) {
    _timetableProvider.addListener(_scheduleNotifications);
    _scheduleNotifications();
  }

  void _scheduleNotifications() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      final List<Period> periods = _timetableProvider.periods;

      for (final period in periods) {
        if (period.date.year == now.year &&
            period.date.month == now.month &&
            period.date.day == now.day &&
            period.time.hour == now.hour &&
            period.time.minute == now.minute) {
          _bellService.playBellSound();
          break;
        }
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _timetableProvider.removeListener(_scheduleNotifications);
  }
}
