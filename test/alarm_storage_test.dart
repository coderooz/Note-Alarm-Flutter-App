import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_alarm/features/alarm/alarm_model.dart';
import 'package:note_alarm/shared/storage/alarm_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AlarmStorage', () {
    test('save then load returns the same alarms', () async {
      SharedPreferences.setMockInitialValues({});

      final alarms = [
        AlarmModel(
          id: 1,
          scheduledAt: DateTime(2026, 8, 17, 7, 0),
          active: true,
        ),
        AlarmModel(
          id: 2,
          scheduledAt: DateTime(2026, 8, 18, 21, 30),
          active: false,
        ),
      ];

      await AlarmStorage.save(alarms);
      final restored = await AlarmStorage.load();

      expect(restored.length, 2);
      expect(restored[0].id, 1);
      expect(restored[0].time, const TimeOfDay(hour: 7, minute: 0));
      expect(restored[0].active, true);
      expect(restored[1].id, 2);
      expect(restored[1].active, false);
    });

    test('load returns empty list when nothing stored', () async {
      SharedPreferences.setMockInitialValues({});

      expect(await AlarmStorage.load(), isEmpty);
    });
  });
}
