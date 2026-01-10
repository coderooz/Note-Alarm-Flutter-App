import 'package:flutter/material.dart';

class AlarmModel {
  final TimeOfDay time;
  final int id;
  final DateTime scheduledAt;
  bool active;

  AlarmModel({
    required this.time,
    required this.id,
    required this.scheduledAt,
    this.active = true,
  });

  Map<String, dynamic> toJson() => {
    'hour': time.hour,
    'minute': time.minute,
    'id': id,
    'scheduledAt': scheduledAt.toIso8601String(),
    'active': active,
  };

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    final scheduled = DateTime.parse(json['scheduledAt']);

    return AlarmModel(
      time: TimeOfDay(hour: json['hour'] ?? 0, minute: json['minute'] ?? 0),
      id:
          json['id'] ??
          scheduled.millisecondsSinceEpoch ~/ 1000, // backward-safe
      scheduledAt: scheduled,
      active: json['active'] ?? false,
    );
  }
}
