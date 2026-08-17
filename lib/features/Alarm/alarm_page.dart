import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../shared/widgets/app_model.dart';
import 'alarm_controller.dart';
import 'alarm_model.dart';
import 'alarm_tile.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final AlarmController _controller = AlarmController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _dialogVisible = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _controller.load();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final ringing = _controller.ringing;
    if (ringing != null && mounted && !_dialogVisible) {
      _showAlarmDialog(ringing);
    }
  }

  Future<void> _addAlarm() async {
    final allowed = await _controller.requestPermissions();
    if (!allowed || !mounted) {
      if (mounted) _showPermissionDeniedSnackBar();
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;

    await _controller.add(picked);
  }

  Future<void> _editAlarm(int index) async {
    final oldAlarm = _controller.alarms[index];

    final picked = await showTimePicker(
      context: context,
      initialTime: oldAlarm.time,
    );
    if (picked == null) return;

    await _controller.edit(index, picked);
  }

  Future<void> _toggle(int index, bool value) =>
      _controller.toggle(index, value);

  Future<void> _delete(int index) => _controller.delete(index);

  Future<bool> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete alarm?'),
        content: const Text('This alarm will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showPermissionDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Alarm notifications are disabled. Enable them in system settings.',
        ),
      ),
    );
  }

  Future<void> _showAlarmDialog(AlarmModel alarm) async {
    _dialogVisible = true;

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/alarm_clock_1.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }

    if (!mounted) return;

    await AppModal.show(
      context: context,
      title: '⏰ Alarm',
      content: Text('It\'s ${alarm.time.format(context)}'),
      dismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            _audioPlayer.stop();
            _controller.dismissRinging();
            Navigator.pop(context);
            _dialogVisible = false;
          },
          child: const Text('Dismiss'),
        ),
        TextButton(
          onPressed: () {
            _audioPlayer.stop();
            _controller.dismissRinging();
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
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final alarms = _controller.alarms;
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
                      onEdit: () => _editAlarm(i),
                      onToggle: (val) => _toggle(i, val),
                      onConfirmDelete: () => _confirmDelete(),
                    );
                  },
                ),
        );
      },
    );
  }
}
