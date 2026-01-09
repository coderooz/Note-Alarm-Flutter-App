import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class TodoTask {
  String name;
  bool isCompleted;

  TodoTask({required this.name, this.isCompleted = false});
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoTask> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(TodoTask(name: _taskController.text.trim()));
        _taskController.clear();
      });
      Navigator.pop(context); // Close the modal
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;

      _tasks.sort((a, b) {
        if (a.isCompleted == b.isCompleted) return 0;
        return a.isCompleted ? 1 : -1;
      });
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "New Task",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _taskController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddModal,
        icon: const Icon(Icons.add_task),
        label: const Text("New Task"),
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.indigo.shade100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "All caught up!",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteTask(index),
                  child: Card(
                    elevation: task.isCompleted ? 0 : 3, // Flat if done
                    margin: const EdgeInsets.only(bottom: 12),
                    color: task.isCompleted
                        ? Colors
                              .grey
                              .shade100 // Grey background if done
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      // THE CHECKBOX LOGIC
                      leading: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: task.isCompleted,
                          activeColor: Colors.indigo,
                          shape: const CircleBorder(),
                          onChanged: (_) => _toggleTask(index),
                        ),
                      ),
                      title: Text(
                        task.name,
                        style: TextStyle(
                          fontSize: 18,
                          // Strikethrough logic
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isCompleted
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      // Tap anywhere on the row to toggle
                      onTap: () => _toggleTask(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
