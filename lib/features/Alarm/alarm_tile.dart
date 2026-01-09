import 'package:flutter/material.dart';
import 'alarm_model.dart';

/// Individual alarm card widget
class AlarmTile extends StatelessWidget {
  final AlarmModel alarm;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const AlarmTile({
    super.key,
    required this.alarm,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        child: ListTile(
          title: Text(
            alarm.time.format(context),
            style: const TextStyle(fontSize: 28),
          ),
          subtitle: Text(alarm.label),
          trailing: Switch(value: alarm.isActive, onChanged: onToggle),
        ),
      ),
    );
  }
}
