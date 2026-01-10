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
    return AlarmModel(
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      id: json['id'],
      scheduledAt: DateTime.parse(json['scheduledAt']),
      active: json['active'],
    );
  }
}
