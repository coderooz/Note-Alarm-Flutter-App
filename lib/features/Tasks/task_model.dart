class TaskModel {
  final int id;
  final String title;
  bool done;

  TaskModel({required this.id, required this.title, this.done = false});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      done: json['done'] ?? false,
    );
  }
}
