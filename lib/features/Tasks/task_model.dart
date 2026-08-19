class TaskModel {
  final int id;
  final String title;
  bool done;

  TaskModel({required this.id, required this.title, this.done = false});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      title: json['title'] as String? ?? '',
      done: json['done'] as bool? ?? false,
    );
  }

  /// Stable comparator: incomplete tasks first, complete tasks last.
  /// Returns 0 for same-state tasks to preserve insertion order.
  static int compareForDisplay(TaskModel a, TaskModel b) {
    if (a.done != b.done) return a.done ? 1 : -1;
    return 0;
  }
}
