import 'package:flutter/material.dart';
import 'task_model.dart';
import 'task_tile.dart';

/// Task / To-Do management screen
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<TaskModel> tasks = [];
  final controller = TextEditingController();

  void _addTask() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      tasks.add(TaskModel(title: controller.text.trim()));
      controller.clear();
    });

    Navigator.pop(context);
  }

  void _openTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'New task'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _addTask, child: const Text('Add Task')),
          ],
        ),
      ),
    );
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
      tasks.sort((a, b) => a.isDone ? 1 : -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openTaskModal,
        icon: const Icon(Icons.add_task),
        label: const Text('New Task'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                return TaskTile(
                  task: tasks[index],
                  onToggle: () => _toggleTask(index),
                  onDelete: () => setState(() => tasks.removeAt(index)),
                );
              },
            ),
    );
  }
}
