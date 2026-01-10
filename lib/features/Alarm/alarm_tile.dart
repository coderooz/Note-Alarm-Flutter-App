import 'package:flutter/material.dart';
import 'alarm_model.dart';

class AlarmTile extends StatelessWidget {
  final AlarmModel alarm;
  final VoidCallback onDelete;
  final VoidCallback onEdit; // 1. Add Edit Callback
  final ValueChanged<bool> onToggle;

  const AlarmTile({
    super.key,
    required this.alarm,
    required this.onDelete,
    required this.onEdit, // Require it here
    required this.onToggle,
  });

  Duration _getRemaining() => alarm.scheduledAt.difference(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final remaining = _getRemaining();

    return Dismissible(
      key: ValueKey(alarm.id),
      // 2. Allow swiping in both directions
      direction: DismissDirection.horizontal,

      // 3. Left-to-Right Swipe (EDIT) - Green Background
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

      // 4. Right-to-Left Swipe (DELETE) - Red Background
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

      // 5. Handle the Logic
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // EDIT ACTION:
          // Call the edit function
          onEdit();
          // Return false so the item does NOT disappear from the list
          return false;
        } else {
          // DELETE ACTION:
          // Return true to confirm we want to remove this item
          return true;
        }
      },

      // This is only called if confirmDismiss returns true (i.e., Delete)
      onDismissed: (_) => onDelete(),

      child: Card(
        child: ListTile(
          title: Text(
            alarm.time.format(context),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          subtitle: alarm.active && remaining.inSeconds > 0
              ? Text('${remaining.inHours}h ${remaining.inMinutes % 60}m left')
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
