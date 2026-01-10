import 'package:flutter/material.dart';

import '../../shared/storage/task_storage.dart';
import 'task_model.dart';
import 'task_tile.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<TaskModel> tasks = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final stored = await TaskStorage.load();
    if (!mounted) return;
    tasks.addAll(stored);
    setState(() {});
  }

  Future<void> _saveTasks() async {
    await TaskStorage.save(tasks);
  }

  void _addTask() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    tasks.add(
      TaskModel(id: DateTime.now().millisecondsSinceEpoch, title: text),
    );

    controller.clear();
    Navigator.pop(context);
    setState(() {});
    _saveTasks();
  }

  void _toggleTask(int index) {
    tasks[index].done = !tasks[index].done;
    tasks.sort((a, b) => a.done ? 1 : -1);
    setState(() {});
    _saveTasks();
  }

  void _deleteTask(int index) {
    tasks.removeAt(index);
    setState(() {});
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openTaskSheet,
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
                  onDelete: () => _deleteTask(index),
                );
              },
            ),
    );
  }

  void _openTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
}
