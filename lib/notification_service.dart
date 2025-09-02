import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/bell_service.dart';
import 'package:myapp/timetable_provider.dart';
import 'package:myapp/period_model.dart';

class NotificationService {
  final TimetableProvider _timetableProvider;
  final BellService _bellService;
  Timer? _timer;
  Timer? _oneShotTimer;
  final Set<String> _triggeredKeys = <String>{};

  NotificationService(this._timetableProvider, this._bellService) {
    _timetableProvider.addListener(_scheduleNotifications);
    _scheduleNotifications();
  }

  void _scheduleNotifications() {
    // Cancel existing timers
    _timer?.cancel();
    _oneShotTimer?.cancel();

    // Periodic safety check (every 10 seconds) to catch edge cases or app resume
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final now = DateTime.now();
      final List<Period> periods = _timetableProvider.periods;

      for (final period in periods) {
        final scheduled = DateTime(
          period.date.year,
          period.date.month,
          period.date.day,
          period.time.hour,
          period.time.minute,
        );

        // Only trigger at the exact minute, once
        final key = '${scheduled.toIso8601String()}::${period.subject}';
        final bool sameMinute = now.year == scheduled.year &&
            now.month == scheduled.month &&
            now.day == scheduled.day &&
            now.hour == scheduled.hour &&
            now.minute == scheduled.minute;

        if (sameMinute && !_triggeredKeys.contains(key)) {
          _triggeredKeys.add(key);
          _bellService.playBellSound();
          break;
        }
      }
    });

    // One-shot precise timer for the next upcoming period
    final now = DateTime.now();
    final upcoming = _timetableProvider.periods
        .map((p) => DateTime(p.date.year, p.date.month, p.date.day, p.time.hour, p.time.minute))
        .where((dt) => dt.isAfter(now))
        .toList()
      ..sort();

    if (upcoming.isNotEmpty) {
      final nextTime = upcoming.first;
      final duration = nextTime.difference(now);
      if (duration.inSeconds > 0) {
        _oneShotTimer = Timer(duration, () {
          final key = '${nextTime.toIso8601String()}::one-shot';
          if (!_triggeredKeys.contains(key)) {
            _triggeredKeys.add(key);
            _bellService.playBellSound();
          }
        });
      }
    }
  }

  void dispose() {
    _timer?.cancel();
    _oneShotTimer?.cancel();
    _timetableProvider.removeListener(_scheduleNotifications);
  }
}
