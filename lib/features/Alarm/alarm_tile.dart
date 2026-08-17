import 'package:flutter/material.dart';
import 'alarm_model.dart';

class AlarmTile extends StatelessWidget {
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

  Duration _getRemaining() => alarm.scheduledAt.difference(DateTime.now());

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
      key: ValueKey(alarm.id),
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
          onEdit();
          return false;
        }
        return onConfirmDelete();
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        child: ListTile(
          title: Text(
            alarm.time.format(context),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          subtitle: alarm.active && remaining.inSeconds > 0
              ? Text(_formatRemaining(remaining))
              : const Text('Inactive'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Switch(value: alarm.active, onChanged: onToggle)],
          ),
        ),
      ),
    );
  }
}
