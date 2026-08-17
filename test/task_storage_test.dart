import 'package:flutter_test/flutter_test.dart';
import 'package:note_alarm/features/tasks/task_model.dart';
import 'package:note_alarm/shared/storage/task_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TaskStorage', () {
    test('save then load returns the same tasks', () async {
      SharedPreferences.setMockInitialValues({});

      final tasks = [
        TaskModel(id: 1, title: 'Buy milk'),
        TaskModel(id: 2, title: 'Call bank', done: true),
      ];

      await TaskStorage.save(tasks);
      final restored = await TaskStorage.load();

      expect(restored.length, 2);
      expect(restored[0].id, 1);
      expect(restored[0].title, 'Buy milk');
      expect(restored[0].done, false);
      expect(restored[1].id, 2);
      expect(restored[1].done, true);
    });

    test('load returns empty list when nothing stored', () async {
      SharedPreferences.setMockInitialValues({});

      expect(await TaskStorage.load(), isEmpty);
    });
  });
}
