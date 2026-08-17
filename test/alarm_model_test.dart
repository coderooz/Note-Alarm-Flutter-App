import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_alarm/features/alarm/alarm_model.dart';

void main() {
  group('AlarmModel', () {
    test('toJson/fromJson round-trip preserves all fields', () {
      final scheduled = DateTime(2026, 8, 17, 7, 30);
      final alarm = AlarmModel(id: 123, scheduledAt: scheduled, active: true);

      final restored = AlarmModel.fromJson(alarm.toJson());

      expect(restored.id, 123);
      expect(restored.scheduledAt, scheduled);
      expect(restored.active, true);
      expect(restored.time, const TimeOfDay(hour: 7, minute: 30));
    });

    test('time getter derives from scheduledAt', () {
      final alarm = AlarmModel(
        id: 1,
        scheduledAt: DateTime(2026, 8, 17, 23, 45),
      );

      expect(alarm.time, const TimeOfDay(hour: 23, minute: 45));
    });

    test('fromJson is null-safe and falls back to defaults', () {
      final restored = AlarmModel.fromJson(const {});

      expect(restored.active, false);
      expect(restored.id, greaterThan(0));
      expect(
        restored.scheduledAt.isBefore(
          DateTime.now().add(const Duration(minutes: 1)),
        ),
        true,
      );
    });

    test('fromJson tolerates a missing scheduledAt', () {
      final restored = AlarmModel.fromJson(const {'id': 5, 'active': true});

      expect(restored.id, 5);
      expect(restored.active, true);
    });
  });
}
