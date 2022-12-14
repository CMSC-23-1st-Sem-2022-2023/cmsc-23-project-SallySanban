import 'dart:convert';

//class for todo with todo information
class Todo {
  final String? id;
  String title;
  String description;
  bool status;
  Map<String, dynamic> deadline;
  bool notifications;
  String lastEditedBy;
  String lastEdited;
  String owner;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    required this.notifications,
    required this.lastEditedBy,
    required this.lastEdited,
    required this.owner,
  });

  //creates todo from json information
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      deadline: json['deadline'],
      notifications: json['notifications'],
      lastEditedBy: json['lastEditedBy'],
      lastEdited: json['lastEdited'],
      owner: json['owner'],
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  //turns todo's information to json information
  Map<String, dynamic> toJson(Todo todo) {
    return {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'status': todo.status,
      'deadline': todo.deadline,
      'notifications': todo.notifications,
      'lastEditedBy': todo.lastEditedBy,
      'lastEdited': todo.lastEdited,
      'owner': todo.owner,
    };
  }
}
