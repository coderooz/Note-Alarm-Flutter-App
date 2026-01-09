import 'package:flutter/material.dart';

/// Alarm entity model
class AlarmModel {
  TimeOfDay time;
  String label;
  bool isActive;

  AlarmModel({required this.time, this.label = 'Alarm', this.isActive = true});
}
