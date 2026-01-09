import 'package:flutter/material.dart';
import "features/Alarm/alarm_page.dart";
import "features/Tasks/task_page.dart";

class NoteAlarm extends StatelessWidget {
  const NoteAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note & Alarm',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const AlarmScreen(), const TodoScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Alarm Clock' : 'To-Do List'),
        backgroundColor: Colors.indigo.shade200,
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarms'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'To-Do',
          ),
        ],
      ),
    );
  }
}
