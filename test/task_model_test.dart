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

    test('compareForDisplay sorts done tasks last and is stable', () {
      final a = TaskModel(id: 1, title: 'A', done: false);
      final b = TaskModel(id: 2, title: 'B', done: false);
      final c = TaskModel(id: 3, title: 'C', done: true);
      final d = TaskModel(id: 4, title: 'D', done: true);

      final tasks = [c, b, d, a];
      tasks.sort(TaskModel.compareForDisplay);

      expect(tasks.map((t) => t.id).toList(), [2, 1, 3, 4]);
    });

    test('compareForDisplay is transitive for equal-state tasks', () {
      final done = [TaskModel(id: 1, title: 'X', done: true)];
      final notDone = [TaskModel(id: 2, title: 'Y', done: false)];

      expect(TaskModel.compareForDisplay(done[0], done[0]), 0);
      expect(TaskModel.compareForDisplay(notDone[0], notDone[0]), 0);
      expect(TaskModel.compareForDisplay(notDone[0], done[0]), -1);
      expect(TaskModel.compareForDisplay(done[0], notDone[0]), 1);
    });
  });
}
