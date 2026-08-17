import 'package:flutter_test/flutter_test.dart';
import 'package:note_alarm/features/tasks/task_model.dart';

void main() {
  group('TaskModel', () {
    test('toJson/fromJson round-trip preserves all fields', () {
      final task = TaskModel(id: 42, title: 'Buy milk', done: true);

      final restored = TaskModel.fromJson(task.toJson());

      expect(restored.id, 42);
      expect(restored.title, 'Buy milk');
      expect(restored.done, true);
    });

    test('fromJson is null-safe and falls back to defaults', () {
      final restored = TaskModel.fromJson(const {});

      expect(restored.title, '');
      expect(restored.done, false);
      expect(restored.id, greaterThan(0));
    });

    test('fromJson tolerates missing done', () {
      final restored = TaskModel.fromJson(const {'id': 7, 'title': 'Task'});

      expect(restored.id, 7);
      expect(restored.title, 'Task');
      expect(restored.done, false);
    });
  });
}
