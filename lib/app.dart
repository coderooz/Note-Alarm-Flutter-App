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
