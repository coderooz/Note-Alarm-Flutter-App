import 'dart:async';
import 'package:flutter/material.dart';
import 'alarm_model.dart';

class AlarmTile extends StatefulWidget {
  final AlarmModel alarm;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;
  final Future<bool> Function() onConfirmDelete;

  const AlarmTile({
    super.key,
    required this.alarm,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
    required this.onConfirmDelete,
  });

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.alarm.active) {
      _startTicker();
    }
  }

  @override
  void didUpdateWidget(covariant AlarmTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.alarm.active && _timer == null) {
      _startTicker();
    } else if (!widget.alarm.active && _timer != null) {
      _stopTicker();
    }
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }

  void _startTicker() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void _stopTicker() {
    _timer?.cancel();
    _timer = null;
  }

  Duration _getRemaining() =>
      widget.alarm.scheduledAt.difference(DateTime.now());

  String _formatRemaining(Duration remaining) {
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;

    if (days > 0) return '${days}d ${hours}h left';
    if (hours > 0) return '${hours}h ${minutes}m left';
    return '${minutes}m left';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _getRemaining();

    return Dismissible(
      key: ValueKey(widget.alarm.id),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Row(
          children: [
            Icon(Icons.edit, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onEdit();
          return false;
        }
        return widget.onConfirmDelete();
      },
      onDismissed: (_) => widget.onDelete(),
      child: Card(
        child: ListTile(
          title: Text(
            widget.alarm.time.format(context),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          subtitle: widget.alarm.active && remaining.inSeconds > 0
              ? Text(_formatRemaining(remaining))
              : const Text('Inactive'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(value: widget.alarm.active, onChanged: widget.onToggle),
            ],
          ),
        ),
      ),
    );
  }
}
