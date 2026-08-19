import 'package:flutter/material.dart';

class AlarmModel {
  final int id;
  final DateTime scheduledAt;
  bool active;

  AlarmModel({required this.id, required this.scheduledAt, this.active = true});

  TimeOfDay get time => TimeOfDay.fromDateTime(scheduledAt);

  Map<String, dynamic> toJson() => {
    'hour': time.hour,
    'minute': time.minute,
    'id': id,
    'scheduledAt': scheduledAt.toIso8601String(),
    'active': active,
  };

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    final scheduled =
        DateTime.tryParse(json['scheduledAt'] as String? ?? '') ??
        DateTime.now();

    return AlarmModel(
      id:
          json['id'] as int? ??
          scheduled.millisecondsSinceEpoch ~/ 1000, // backward-safe
      scheduledAt: scheduled,
      active: json['active'] as bool? ?? false,
    );
  }
}
