import 'dart:async';
import 'package:flutter/material.dart';
import 'alarm_model.dart';
import 'alarm_tile.dart';

/// Alarm management screen
class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<AlarmModel> alarms = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAlarmWatcher();
  }

  /// Periodic alarm simulation (foreground only)
  void _startAlarmWatcher() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = TimeOfDay.now();

      for (final alarm in alarms) {
        if (alarm.isActive &&
            alarm.time.hour == now.hour &&
            alarm.time.minute == now.minute) {
          _triggerAlarm(alarm);
        }
      }
    });
  }

  void _triggerAlarm(AlarmModel alarm) {
    setState(() => alarm.isActive = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('⏰ Alarm'),
        content: Text('Time for ${alarm.label}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  Future<void> _addAlarm() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        alarms.add(AlarmModel(time: picked));
        alarms.sort(
          (a, b) => (a.time.hour * 60 + a.time.minute).compareTo(
            b.time.hour * 60 + b.time.minute,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
              itemBuilder: (_, index) {
                return AlarmTile(
                  alarm: alarms[index],
                  onDelete: () => setState(() => alarms.removeAt(index)),
                  onToggle: (value) =>
                      setState(() => alarms[index].isActive = value),
                );
              },
            ),
    );
  }
}
