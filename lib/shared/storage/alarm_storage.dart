import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/alarm/alarm_model.dart';

class AlarmStorage {
  static const _key = 'alarms';

  static Future<void> save(List<AlarmModel> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      alarms.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<List<AlarmModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key);
    if (data == null) return [];

    return data.map((e) => AlarmModel.fromJson(jsonDecode(e))).toList();
  }
}
