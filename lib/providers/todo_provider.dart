import 'package:flutter/material.dart';
import 'package:project_teknomo/api/firebase_todo_api.dart';
import 'package:project_teknomo/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//provider (UI goes through here and this calls methods in firebase API)
class TodoListProvider with ChangeNotifier {
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _todosStream;
  Todo? _selectedTodo;

  TodoListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchTodos();
  }

  Stream<QuerySnapshot> get todos => _todosStream;
  Todo get selected => _selectedTodo!;

  //gets the todo clicked
  changeSelectedTodo(Todo item) {
    _selectedTodo = item;
  }

  //gets all todos
  void fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    notifyListeners();
  }

  //calls firebase's add todo
  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson(item));
    print(message);
    notifyListeners();
  }

  //calls firebase's edit todo
  void editTodo(String toEdit, dynamic edited) async {
    String message =
        await firebaseService.editTodo(_selectedTodo!.id, toEdit, edited);
    print(message);
    notifyListeners();
  }

  //calls firebase's delete todo
  void deleteTodo() async {
    String message = await firebaseService.deleteTodo(_selectedTodo!.id);
    print(message);
    notifyListeners();
  }

  //calls firebase's check todo
  void toggleStatus(bool status) async {
    String message = await firebaseService.checkTodo(_selectedTodo!.id, status);
    print(message);
    notifyListeners();
  }
}
