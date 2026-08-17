import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/notifications/notification_service.dart';
import '../../shared/storage/alarm_storage.dart';
import 'alarm_model.dart';

class AlarmController extends ChangeNotifier {
  final List<AlarmModel> _alarms = [];
  Timer? _ticker;
  AlarmModel? _ringing;

  List<AlarmModel> get alarms => List.unmodifiable(_alarms);

  /// The alarm that has fired and is awaiting dismissal, if any.
  AlarmModel? get ringing => _ringing;

  Future<void> load() async {
    _alarms.addAll(await AlarmStorage.load());
    _startTicker();
    _checkAlarms();
    notifyListeners();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkAlarms(),
    );
  }

  void _checkAlarms() {
    final now = DateTime.now();
    bool changed = false;

    for (final alarm in _alarms) {
      if (alarm.active && now.isAfter(alarm.scheduledAt)) {
        alarm.active = false;
        changed = true;

        NotificationService.cancel(alarm.id);
        _ringing ??= alarm;
      }
    }

    if (changed) {
      AlarmStorage.save(_alarms);
      notifyListeners();
    }
  }

  /// Requests exact-alarm and notification permissions in one step.
  Future<bool> requestPermissions() async {
    final exactAllowed =
        await NotificationService.requestExactAlarmPermission();
    if (!exactAllowed) return false;
    return NotificationService.requestNotificationPermission();
  }

  Future<void> add(TimeOfDay picked) async {
    final scheduled = _nextSchedule(picked);
    final id = scheduled.millisecondsSinceEpoch ~/ 1000;

    await NotificationService.scheduleAlarm(
      id: id,
      dateTime: scheduled,
      title: '⏰ Alarm',
      body: 'It\'s time!',
    );

    _alarms.add(AlarmModel(id: id, scheduledAt: scheduled, active: true));
    await AlarmStorage.save(_alarms);
    notifyListeners();
  }

  Future<void> edit(int index, TimeOfDay picked) async {
    final oldAlarm = _alarms[index];
    final scheduled = _nextSchedule(picked);
    final newId = scheduled.millisecondsSinceEpoch ~/ 1000;

    await NotificationService.cancel(oldAlarm.id);
    await NotificationService.scheduleAlarm(
      id: newId,
      dateTime: scheduled,
      title: '⏰ Alarm',
      body: 'It\'s time!',
    );

    _alarms[index] = AlarmModel(
      id: newId,
      scheduledAt: scheduled,
      active: true,
    );
    await AlarmStorage.save(_alarms);
    notifyListeners();
  }

  Future<void> toggle(int index, bool value) async {
    var alarm = _alarms[index];

    if (value) {
      var scheduled = alarm.scheduledAt;
      if (scheduled.isBefore(DateTime.now())) {
        scheduled = scheduled.add(const Duration(days: 1));
        alarm = _alarms[index] = AlarmModel(
          id: scheduled.millisecondsSinceEpoch ~/ 1000,
          scheduledAt: scheduled,
          active: true,
        );
      }

      await NotificationService.scheduleAlarm(
        id: alarm.id,
        dateTime: alarm.scheduledAt,
        title: '⏰ Alarm',
        body: 'It\'s time!',
      );
      alarm.active = true;
    } else {
      await NotificationService.cancel(alarm.id);
      alarm.active = false;
    }

    await AlarmStorage.save(_alarms);
    notifyListeners();
  }

  Future<void> delete(int index) async {
    await NotificationService.cancel(_alarms[index].id);
    _alarms.removeAt(index);
    await AlarmStorage.save(_alarms);
    notifyListeners();
  }

  void dismissRinging() {
    _ringing = null;
    notifyListeners();
  }

  /// Returns the next occurrence of [picked] today, or tomorrow if past.
  DateTime _nextSchedule(TimeOfDay picked) {
    final now = DateTime.now();
    var scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
