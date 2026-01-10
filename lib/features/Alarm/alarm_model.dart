import 'package:flutter/material.dart';

/// Alarm entity model (notification-backed)
class AlarmModel {
  final TimeOfDay time;
  final int notificationId;

  AlarmModel({required this.time, required this.notificationId});
}
