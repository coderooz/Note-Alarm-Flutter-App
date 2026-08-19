import 'package:flutter_test/flutter_test.dart';
import 'package:note_alarm/features/alarm/alarm_controller.dart';
import 'package:note_alarm/features/alarm/alarm_model.dart';
import 'package:note_alarm/shared/storage/alarm_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AlarmController', () {
    test('load returns empty alarms when nothing stored', () async {
      SharedPreferences.setMockInitialValues({});

      final controller = AlarmController();
      await controller.load();

      expect(controller.alarms, isEmpty);
      expect(controller.ringing, isNull);
    });

    test('load populates alarms from storage', () async {
      SharedPreferences.setMockInitialValues({});
      final future = DateTime.now().add(const Duration(days: 1));
      final stored = [
        AlarmModel(id: 1, scheduledAt: future, active: true),
        AlarmModel(id: 2, scheduledAt: future, active: false),
      ];
      await AlarmStorage.save(stored);

      final controller = AlarmController();
      await controller.load();

      expect(controller.alarms.length, 2);
      expect(controller.alarms[0].id, 1);
      expect(controller.alarms[0].active, true);
      expect(controller.alarms[1].id, 2);
      expect(controller.alarms[1].active, false);
    });

    test('dismissRinging on an empty queue is a no-op', () async {
      SharedPreferences.setMockInitialValues({});
      final controller = AlarmController();
      await controller.load();

      expect(controller.ringing, isNull);
      controller.dismissRinging();
      expect(controller.ringing, isNull);
    });
  });
}
