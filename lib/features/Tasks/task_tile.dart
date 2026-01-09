import 'package:flutter/material.dart';
import 'task_model.dart';

/// Single task row widget
class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) => onDelete(),
      background: Container(color: Colors.red),
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: task.isDone,
            shape: const CircleBorder(),
            onChanged: (_) => onToggle(),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          onTap: onToggle,
        ),
      ),
    );
  }
}
