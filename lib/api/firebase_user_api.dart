import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/models/user_model.dart';

//the following methods edit the database in firebase
class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  //method for sending friend request (I sent to FRIEND)
  Future<String> sendFriendRequest(String? idFriend, String? idSelf) async {
    try {
      await db.collection("users").doc(idSelf).update({
        'sentFriendRequests': FieldValue.arrayUnion([idFriend])
      });

      await db.collection("users").doc(idFriend).update({
        'receivedFriendRequests': FieldValue.arrayUnion([idSelf])
      });

      return "Successfully sent friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //method for accepting friend request
  Future<String> acceptFriend(String? idFriend, String? idSelf) async {
    try {
      await db.collection("users").doc(idSelf).update({
        'friends': FieldValue.arrayUnion([idFriend]),
        'receivedFriendRequests': FieldValue.arrayRemove([idFriend]),
      });

      await db.collection("users").doc(idFriend).update({
        'friends': FieldValue.arrayUnion([idSelf]),
        'sentFriendRequests': FieldValue.arrayRemove([idSelf]),
      });

      return "Successfully accepted friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> declineFriend(String? idFriend, String? idSelf) async {
    try {
      await db.collection("users").doc(idSelf).update({
        'receivedFriendRequests': FieldValue.arrayRemove([idFriend]),
      });

      await db.collection("users").doc(idFriend).update({
        'sentFriendRequests': FieldValue.arrayRemove([idSelf]),
      });

      return "Successfully declined friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> unfriend(String? idFriend, String? idSelf) async {
    try {
      await db.collection("users").doc(idSelf).update({
        'friends': FieldValue.arrayRemove([idFriend]),
      });

      await db.collection("users").doc(idFriend).update({
        'friends': FieldValue.arrayRemove([idSelf]),
      });

      return "Successfully unfriended!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editBio(String? id, String bio) async {
    try {
      await db.collection("users").doc(id).update({"bio": bio});

      return "Successfully edited bio!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //gets all users
  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }
}
