import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../core/notifications/notification_service.dart';
import '../../shared/storage/alarm_storage.dart';
import 'alarm_model.dart';
import 'alarm_tile.dart';
import '../../shared/widgets/app_model.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<AlarmModel> alarms = [];

  Timer? _ticker;
  bool _dialogVisible = false;

  // Initialize the audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadAlarms();
    // Update UI every 30 seconds to check alarm times and refresh "remaining time"
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => _tick());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _audioPlayer.dispose(); // Dispose of the player to release resources
    super.dispose();
  }

  Future<void> _loadAlarms() async {
    final stored = await AlarmStorage.load();
    alarms.addAll(stored);
    _tick(); // Check immediately upon load
  }

  Future<void> _persist() async {
    await AlarmStorage.save(alarms);
  }

  void _tick() {
    final now = DateTime.now();
    bool changed = false;

    for (final alarm in alarms) {
      if (alarm.active && now.isAfter(alarm.scheduledAt)) {
        alarm.active = false;
        changed = true;

        if (mounted && !_dialogVisible) {
          _showAlarmDialog(alarm);
        }
      }
    }

    if (changed) _persist();
    if (mounted) setState(() {});
  }

  Future<void> _addAlarm() async {
    final allowed = await NotificationService.requestExactAlarmPermission();
    if (!allowed || !mounted) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;

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

    final id = scheduled.millisecondsSinceEpoch ~/ 1000;

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

  Future<void> _editAlarm(int index) async {
    final oldAlarm = alarms[index];

    // 1. Show Time Picker initialized with the EXISTING time
    final picked = await showTimePicker(
      context: context,
      initialTime: oldAlarm.time,
    );

    // If user cancelled, do nothing
    if (picked == null) return;

    // 2. Calculate new schedule
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

    // 3. Create new ID based on new time
    final newId = scheduled.millisecondsSinceEpoch ~/ 1000;

    // 4. Cancel the OLD notification
    await NotificationService.cancel(oldAlarm.id);

    // 5. Schedule the NEW notification
    await NotificationService.scheduleAlarm(
      id: newId,
      dateTime: scheduled,
      title: '⏰ Alarm',
      body: 'It\'s time!',
    );

    // 6. Update the list
    setState(() {
      alarms[index] = AlarmModel(
        time: picked,
        id: newId,
        scheduledAt: scheduled,
        active: true,
      );
    });

    await _persist();
  }

  Future<void> _toggle(int index, bool value) async {
    var alarm = alarms[index];

    if (value) {
      var scheduled = alarm.scheduledAt;

      // Reschedule for tomorrow if the time has already passed today
      if (scheduled.isBefore(DateTime.now())) {
        scheduled = scheduled.add(const Duration(days: 1));
        alarm = alarms[index] = AlarmModel(
          time: alarm.time,
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

    setState(() {});
    await _persist();
  }

  Future<void> _delete(int index) async {
    await NotificationService.cancel(alarms[index].id);
    alarms.removeAt(index);
    setState(() {});
    await _persist();
  }

  Future<void> _showAlarmDialog(AlarmModel alarm) async {
    _dialogVisible = true;

    // 1. Play the sound in a loop
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/alarm_clock_1.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }

    if (!mounted) return;

    // 2. Show the modal
    await AppModal.show(
      context: context,
      title: '⏰ Alarm',
      content: Text('It\'s ${alarm.time.format(context)}'),
      dismissible: false, // Forces user to interact
      actions: [
        TextButton(
          onPressed: () {
            // Stop sound
            _audioPlayer.stop();

            Navigator.pop(context);
            _dialogVisible = false;
          },
          child: const Text('Dismiss'),
        ),
        TextButton(
          onPressed: () {
            // Stop sound
            _audioPlayer.stop();

            // TODO: Implement actual snooze logic (e.g., reschedule for +5 mins)
            Navigator.pop(context);
            _dialogVisible = false;
          },
          child: const Text('Snooze (5 min)'),
        ),
      ],
    );
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
              itemBuilder: (_, i) {
                return AlarmTile(
                  key: ValueKey(alarms[i].id),
                  alarm: alarms[i],
                  onDelete: () => _delete(i),
                  onEdit: () => _editAlarm(i), // Pass the edit function here
                  onToggle: (val) => _toggle(i, val),
                );
              },
            ),
    );
  }
}
