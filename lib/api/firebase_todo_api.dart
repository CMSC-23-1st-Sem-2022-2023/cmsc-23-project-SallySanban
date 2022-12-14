import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_teknomo/api/firebase_auth_api.dart';
import 'package:project_teknomo/classes/me.dart';

class FirebaseTodoAPI {
  //comment out when testing
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  //static final db = FakeFirebaseFirestore();

  //adds todo in todos collection and in todos list of owner
  Future<String> addTodo(Map<String, dynamic> todo) async {
    try {
      final docRef = await db.collection("todos").add(todo);
      await db.collection("todos").doc(docRef.id).update({'id': docRef.id});

      await db.collection("users").doc(Me.myId).update({
        'todos': FieldValue.arrayUnion([docRef.id]),
      });

      return "Successfully added task!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //deletes todo in todos collection and todos list of owner
  Future<String> deleteTodo(String? id) async {
    try {
      await db.collection("todos").doc(id).delete();

      await db.collection("users").doc(Me.myId).update({
        'todos': FieldValue.arrayRemove([id]),
      });

      return "Successfully deleted task!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //edits todo in todos collection
  Future<String> editTodo(String? id, String toEdit, dynamic edited) async {
    try {
      await db.collection("todos").doc(id).update({"${toEdit}": edited});

      return "Successfully edited task!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //changes status of todo in todos collection
  Future<String> checkTodo(String? id, bool status) async {
    try {
      await db.collection("todos").doc(id).update({"status": status});

      return "Successfully edited status of task!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //gets all the todos from database
  Stream<QuerySnapshot> getAllTodos() {
    return db.collection("todos").snapshots();
  }
}
