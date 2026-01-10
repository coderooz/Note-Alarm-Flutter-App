import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/alarm/alarm_page.dart';
import 'features/tasks/task_page.dart';

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

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  final pages = const [AlarmScreen(), TaskScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(index == 0 ? 'Alarms' : 'Tasks')),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.alarm), label: 'Alarms'),
          NavigationDestination(icon: Icon(Icons.task_alt), label: 'Tasks'),
        ],
      ),
    );
  }
}
