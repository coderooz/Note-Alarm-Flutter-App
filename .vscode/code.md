- `main.dart` 
```dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const NoteAlarmApp());
}

```

- `app.dart` 
```dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/alarm/alarm_page.dart';
import 'features/tasks/task_page.dart';

/// Root widget of the Note-Alarm application
class NoteAlarmApp extends StatelessWidget {
  const NoteAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note-Alarm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeShell(),
    );
  }
}

/// Bottom-navigation shell
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentIndex = 0;

  final pages = const [AlarmScreen(), TaskScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(currentIndex == 0 ? 'Alarms' : 'Tasks')),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.alarm), label: 'Alarms'),
          NavigationDestination(icon: Icon(Icons.task_alt), label: 'Tasks'),
        ],
      ),
    );
  }
}
```

- `lib/code/notifications/notification_service.dart` 
```dart
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications + timezone
  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);
  }

  /// Android 12+ requires user approval for exact alarms
  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return false;

    final canSchedule = await androidPlugin.canScheduleExactNotifications();

    if (canSchedule == true) return true;

    // Opens system permission screen
    await androidPlugin.requestExactAlarmsPermission();
    return false;
  }

  /// Schedule exact alarm (works when app is closed)
  static Future<void> scheduleAlarm({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          channelDescription: 'Exact alarm alerts',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm_clock_1'),
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}

```

- `lib/code/theme/app_theme.dart` 
```dart
import 'package:flutter/material.dart';

/// Centralized theme for easy scaling & branding
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
```

- `lib/features/alarm/alarm_model.dart` 
```dart
import 'package:flutter/material.dart';

class AlarmModel {
  final TimeOfDay time;
  final int notificationId;
  final DateTime scheduledAt;
  bool isActive;

  AlarmModel({
    required this.time,
    required this.notificationId,
    required this.scheduledAt,
    this.isActive = true,
  });

  // 🔽 Serialization for persistence
  Map<String, dynamic> toJson() => {
    'hour': time.hour,
    'minute': time.minute,
    'notificationId': notificationId,
    'scheduledAt': scheduledAt.toIso8601String(),
    'isActive': isActive,
  };

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      notificationId: json['notificationId'],
      scheduledAt: DateTime.parse(json['scheduledAt']),
      isActive: json['isActive'],
    );
  }
}

```

- `lib/features/alarm/alarm_page.dart` 
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'alarm_model.dart';
import '../../core/notifications/notification_service.dart';
import '../../shared/storage/alarm_storage.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<AlarmModel> _alarms = [];
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    _loadAlarms();

    // Updates countdown every minute
    _ticker = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  Future<void> _loadAlarms() async {
    final loaded = await AlarmStorage.load();
    setState(() => _alarms.addAll(loaded));
  }

  Future<void> _persist() async {
    await AlarmStorage.save(_alarms);
  }

  Duration _remainingTime(AlarmModel alarm) {
    return alarm.scheduledAt.difference(DateTime.now());
  }

  Future<void> _addAlarm() async {
    final allowed = await NotificationService.requestExactAlarmPermission();

    if (!allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enable exact alarms permission in system settings'),
        ),
      );
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    final now = DateTime.now();
    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final id = scheduled.millisecondsSinceEpoch ~/ 1000;

    await NotificationService.scheduleAlarm(
      id: id,
      dateTime: scheduled,
      title: '⏰ Alarm',
      body: 'It\'s time!',
    );

    setState(() {
      _alarms.add(
        AlarmModel(time: picked, notificationId: id, scheduledAt: scheduled),
      );
    });

    await _persist();
  }

  Future<void> _toggleAlarm(int index, bool value) async {
    final alarm = _alarms[index];
    alarm.isActive = value;

    if (!value) {
      await NotificationService.cancel(alarm.notificationId);
    } else {
      await NotificationService.scheduleAlarm(
        id: alarm.notificationId,
        dateTime: alarm.scheduledAt,
        title: '⏰ Alarm',
        body: 'It\'s time!',
      );
    }

    setState(() {});
    await _persist();
  }

  Future<void> _deleteAlarm(int index) async {
    await NotificationService.cancel(_alarms[index].notificationId);
    setState(() => _alarms.removeAt(index));
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAlarm,
        icon: const Icon(Icons.add_alarm),
        label: const Text('Add Alarm'),
      ),
      body: _alarms.isEmpty
          ? const Center(child: Text('No alarms set'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                final remaining = _remainingTime(alarm);

                return Dismissible(
                  key: ValueKey(alarm.notificationId),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteAlarm(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        alarm.time.format(context),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: alarm.isActive && remaining.inMinutes > 0
                          ? Text(
                              '${remaining.inHours}h ${remaining.inMinutes % 60}m remaining',
                              style: const TextStyle(color: Colors.grey),
                            )
                          : const Text('Inactive'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            alarm.isActive
                                ? Icons.notifications_active
                                : Icons.notifications_none,
                            color: alarm.isActive ? Colors.indigo : Colors.grey,
                          ),
                          Switch(
                            value: alarm.isActive,
                            onChanged: (v) => _toggleAlarm(index, v),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
```

- `lib/features/tasks/task_model.dart` 
```dart
import 'package:flutter/material.dart';

/// Task entity model
class TaskModel {
  String title;
  final int taskId;
  final DateTime scheduledAt;
  bool isDone;

  TaskModel({
    required this.title, 
    required this.taskId, 
    required this.scheduledAt, 
    this.isDone = false
    });

  Map<String, dynamic> toJson()=>{
    'taskId': taskId,
    'scheduledAt' : scheduledAt.toIso8601String(),
    'isDone': isDone, 
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'],
      taskId: json['taskId'], 
      scheduledAt: DateTime.parse(json['scheduledAt']), 
      isDone: json['isDone']
    );
  }
}

```

- `lib/features/tasks/task_page.dart` 
```dart
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

```

- `lib/features/tasks/task_tile.dart` 
```dart
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
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
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

```

- `lib/shared/util/constants.ts` 
```dart
// empty
```

- `lib/shared/widgets/app_button.dart` 
```dart
// empty
```

- `lib/shared/storage/task_storage.dart`
```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/tasks/task_model.dart'

class TaskStorage {
  static const _key = 'tasks';
  static Future<void> save(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = tasks.map((e)=> jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }


  static Future<List<TaskModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key);
    if (data == null) return [];

    return data.map((e) => TaskModel.fromJson(jsonDecode(e))).toList();
  }
}
```

- `lib/shared/storage/alarm_storage.dart`
```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/alarm/alarm_model.dart';

class AlarmStorage {
  static const _key = 'alarms';

  static Future<void> save(List<AlarmModel> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = alarms.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  static Future<List<AlarmModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key);
    if (data == null) return [];

    return data.map((e) => AlarmModel.fromJson(jsonDecode(e))).toList();
  }
}
```

- `pubspec.ymal` 
```ymal
name: note_alarm
description: "A new Flutter project."
publish_to: 'none' # Remove this line if you wish to publish to pub.dev
version: 1.0.0+1

environment:
  sdk: ^3.10.4

dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^19.5.0
  timezone: ^0.10.1
  cupertino_icons: ^1.0.8
  audioplayers: ^6.0.0
  flutter_background_service: ^5.1.0
  shared_preferences: ^2.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  intl: ^0.20.2
  flutter_lints: ^6.0.0
  flutter_launcher_icons: ^0.14.4

flutter:
  uses-material-design: true
  assets:
    - assets/sounds/
    - assets/images/
  
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/icon.png"
  min_sdk_android: 21
```