import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/tasks/task_model.dart';

class TaskStorage {
  static const _key = 'tasks';

  static Future<void> save(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      tasks.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<List<TaskModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key);
    if (data == null) return [];
    return data.map((e) => TaskModel.fromJson(jsonDecode(e))).toList();
  }
}
