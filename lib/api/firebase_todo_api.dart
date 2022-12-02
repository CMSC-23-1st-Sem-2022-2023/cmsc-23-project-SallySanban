import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_teknomo/api/firebase_auth_api.dart';
import 'package:project_teknomo/classes/me.dart';

class FirebaseTodoAPI {
  //comment out when testing
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  // final db = FakeFirebaseFirestore();

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

  Future<String> editTodo(String? id, String toEdit, dynamic edited) async {
    try {
      await db.collection("todos").doc(id).update({"${toEdit}": edited});

      return "Successfully edited task!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> checkTodo(String? id, bool status) async {
    try {
      await db.collection("todos").doc(id).update({"status": status});

      return "Successfully edited status of task!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllTodos() {
    return db.collection("todos").snapshots();
  }
}
