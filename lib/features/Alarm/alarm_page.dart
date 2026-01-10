import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/notifications/notification_service.dart';
import '../../shared/storage/alarm_storage.dart';
import 'alarm_model.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<AlarmModel> alarms = [];
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _loadAlarms();
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _loadAlarms() async {
    final stored = await AlarmStorage.load();
    if (!mounted) return;
    alarms.addAll(stored);
    setState(() {});
  }

  Future<void> _persist() async {
    await AlarmStorage.save(alarms);
  }

  Duration _remainingTime(AlarmModel alarm) {
    return alarm.scheduledAt.difference(DateTime.now());
  }

  Future<void> _addAlarm() async {
    final allowed = await NotificationService.requestExactAlarmPermission();
    if (!allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enable exact alarm permission in system settings'),
        ),
      );
      return;
    }

    if (!mounted) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    final now = DateTime.now();
    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final int id = scheduled.millisecondsSinceEpoch ~/ 1000;

    await NotificationService.scheduleAlarm(
      id: id,
      dateTime: scheduled,
      title: '⏰ Alarm',
      body: 'It\'s time!',
    );

    alarms.add(
      AlarmModel(time: picked, id: id, scheduledAt: scheduled, active: true),
    );

    setState(() {});
    await _persist();
  }

  Future<void> _toggleAlarm(int index, bool value) async {
    final alarm = alarms[index];
    alarm.active = value;

    if (value) {
      await NotificationService.scheduleAlarm(
        id: alarm.id,
        dateTime: alarm.scheduledAt,
        title: '⏰ Alarm',
        body: 'It\'s time!',
      );
    } else {
      await NotificationService.cancel(alarm.id);
    }

    setState(() {});
    await _persist();
  }

  Future<void> _deleteAlarm(int index) async {
    await NotificationService.cancel(alarms[index].id);
    alarms.removeAt(index);
    setState(() {});
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAlarm,
        icon: const Icon(Icons.add_alarm),
        label: const Text('Add Alarm'),
      ),
      body: alarms.isEmpty
          ? const Center(child: Text('No alarms set'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                final remaining = _remainingTime(alarm);

                return Dismissible(
                  key: ValueKey(alarm.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteAlarm(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(
                        alarm.time.format(context),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: alarm.active && remaining.inMinutes > 0
                          ? Text(
                              '${remaining.inHours}h ${remaining.inMinutes % 60}m remaining',
                              style: const TextStyle(color: Colors.grey),
                            )
                          : const Text('Inactive'),
                      trailing: Switch(
                        value: alarm.active,
                        onChanged: (v) => _toggleAlarm(index, v),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
