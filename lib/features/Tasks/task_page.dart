import 'package:flutter/material.dart';

import '../../shared/storage/task_storage.dart';
import '../../shared/widgets/empty_state.dart';
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  Future<bool> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: const Text('This task will be removed.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openTaskSheet,
        icon: const Icon(Icons.add_task),
        label: const Text('New Task'),
      ),
      body: tasks.isEmpty
          ? const EmptyState(icon: Icons.task_alt, message: 'No tasks yet')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                return TaskTile(
                  task: tasks[index],
                  onToggle: () => _toggleTask(index),
                  onConfirmDelete: _confirmDelete,
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
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
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
