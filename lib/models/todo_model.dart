import 'dart:convert';

class Todo {
  final String? id;
  String title;
  String description;
  bool status;
  Map<String, String> deadline;
  bool notifications;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    required this.notifications,
  });

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      deadline: json['deadline'],
      notifications: json['notifications'],
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'status': todo.status,
      'deadline': todo.deadline,
      'notifications': todo.notifications,
    };
  }
}
