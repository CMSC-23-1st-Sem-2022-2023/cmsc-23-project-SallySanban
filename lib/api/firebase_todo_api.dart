// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:project_teknomo/api/firebase_auth_api.dart';

// class FirebaseTodoAPI {
//   //comment out when testing
//   static final FirebaseFirestore db = FirebaseFirestore.instance;
//   // final db = FakeFirebaseFirestore();

//   Future<String> addTodo(Map<String, dynamic> todo) async {
//     try {
//       final docRef = await db.collection("todos").add(todo);
//       await db.collection("todos").doc(docRef.id).update({'id': docRef.id});

//       FirebaseAuthAPI.auth.authStateChanges().listen((User? user) async {
//         if (user == null) {
//           print("User is logged out");
//         } else {
//           await db.collection("users").doc(user.uid).update({
//             'todos': FieldValue.arrayUnion([docRef.id]),
//           });
//         }
//       });

//       return "Successfully added todo!";
//     } on FirebaseException catch (e) {
//       return "Failed with error '${e.code}: ${e.message}";
//     }
//   }

//   Stream<QuerySnapshot> getAllTodos() {
//     return db.collection("todos").snapshots();
//   }

//   Future<String> deleteTodo(String? id) async {
//     try {
//       await db.collection("todos").doc(id).delete();

//       return "Successfully deleted todo!";
//     } on FirebaseException catch (e) {
//       return "Failed with error '${e.code}: ${e.message}";
//     }
//   }
// }
