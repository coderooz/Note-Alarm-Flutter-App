import 'package:flutter/material.dart';
import 'alarm_model.dart';
import '../../core/notifications/notification_service.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<AlarmModel> _alarms = [];

  Future<void> _addAlarm() async {
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

    // If selected time already passed, schedule for tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final id = scheduled.millisecondsSinceEpoch ~/ 1000;

    await NotificationService.scheduleAlarm(
      id: id,
      dateTime: scheduled,
      title: '⏰ Alarm',
      body: 'It\'s time!',
    );

    setState(() {
      _alarms.add(AlarmModel(time: picked, notificationId: id));

      _alarms.sort((a, b) {
        final aMin = a.time.hour * 60 + a.time.minute;
        final bMin = b.time.hour * 60 + b.time.minute;
        return aMin.compareTo(bMin);
      });
    });
  }

  Future<void> _deleteAlarm(int index) async {
    await NotificationService.cancel(_alarms[index].notificationId);
    setState(() => _alarms.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAlarm,
        icon: const Icon(Icons.add_alarm),
        label: const Text('Add Alarm'),
      ),
      body: _alarms.isEmpty
          ? const Center(child: Text('No alarms set'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];

                return Dismissible(
                  key: ValueKey(alarm.notificationId),
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        alarm.time.format(context),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.notifications_active),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
