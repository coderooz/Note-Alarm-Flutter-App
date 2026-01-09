import 'dart:async'; // specific for Timer
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Alarm {
  TimeOfDay time;
  bool isActive;
  String label; // e.g., "Work", "Gym"

  Alarm({required this.time, this.isActive = true, this.label = "Alarm"});
}

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  // Instead of one variable, we now have a List of Alarm objects
  final List<Alarm> _alarms = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      // We loop through all alarms to check them
      for (var alarm in _alarms) {
        if (alarm.isActive) {
          if (now.hour == alarm.time.hour && now.minute == alarm.time.minute) {
            _triggerAlarm(alarm);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _triggerAlarm(Alarm alarm) {
    setState(() {
      alarm.isActive = false; // Turn off the switch automatically
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("⏰ RRRINNGGG!"),
        content: Text(
          "Time for ${alarm.label} (${alarm.time.format(context)})",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewAlarm() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Add a new Alarm object to our list
        _alarms.add(Alarm(time: picked));

        // Optional: Sort the list by time so early alarms appear first
        _alarms.sort((a, b) {
          // Convert to minutes to compare easily
          final aMinutes = a.time.hour * 60 + a.time.minute;
          final bMinutes = b.time.hour * 60 + b.time.minute;
          return aMinutes.compareTo(bMinutes);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modern apps use a Floating Action Button (FAB) for primary actions
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewAlarm,
        icon: const Icon(Icons.add_alarm),
        label: const Text("Add Alarm"),
      ),
      body: _alarms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm_off,
                    size: 80,
                    color: Colors.indigo.shade100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "No alarms set",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];

                // DISMISSIBLE: Allows the user to swipe the card to delete it
                return Dismissible(
                  key: UniqueKey(), // Unique ID for this specific row
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() {
                      _alarms.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Alarm deleted")),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side: The Time
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alarm.time.format(context),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: alarm.isActive
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              Text(
                                alarm.label,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          // Right side: The Switch
                          Switch(
                            value: alarm.isActive,
                            onChanged: (val) {
                              setState(() {
                                alarm.isActive = val;
                              });
                            },
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
