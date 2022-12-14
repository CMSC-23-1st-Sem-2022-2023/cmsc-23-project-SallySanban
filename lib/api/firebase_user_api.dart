import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

//the following methods edit the database in firebase
class FirebaseUserAPI {
  //comment out when testing
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  //static final db = FakeFirebaseFirestore();

  //sends friend request (ME TO FRIEND)
  Future<String> sendFriendRequest(String? idFriend, String? idSelf) async {
    try {
      //adds FRIEND to MY SENT REQUESTS
      await db.collection("users").doc(idSelf).update({
        'sentFriendRequests': FieldValue.arrayUnion([idFriend])
      });

      //adds ME to FRIEND'S RECEIVED REQUESTS
      await db.collection("users").doc(idFriend).update({
        'receivedFriendRequests': FieldValue.arrayUnion([idSelf])
      });

      return "Successfully sent friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //accepts friend request (ME FROM FRIEND)
  Future<String> acceptFriend(String? idFriend, String? idSelf) async {
    try {
      //adds FRIEND to MY FRIENDS
      //removes FRIEND from MY RECEIVED REQUESTS
      await db.collection("users").doc(idSelf).update({
        'friends': FieldValue.arrayUnion([idFriend]),
        'receivedFriendRequests': FieldValue.arrayRemove([idFriend]),
      });

      //adds ME to FRIEND'S FRIENDS
      //removes ME from FRIEND'S SENT REQUESTS
      await db.collection("users").doc(idFriend).update({
        'friends': FieldValue.arrayUnion([idSelf]),
        'sentFriendRequests': FieldValue.arrayRemove([idSelf]),
      });

      return "Successfully accepted friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //declines friend request (ME FROM FRIEND)
  Future<String> declineFriend(String? idFriend, String? idSelf) async {
    try {
      //removes FRIEND from MY RECEIVED REQUESTS
      await db.collection("users").doc(idSelf).update({
        'receivedFriendRequests': FieldValue.arrayRemove([idFriend]),
      });

      //removes ME from FRIEND'S SENT REQUESTS
      await db.collection("users").doc(idFriend).update({
        'sentFriendRequests': FieldValue.arrayRemove([idSelf]),
      });

      return "Successfully declined friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //unfriends (ME TO FRIEND)
  Future<String> unfriend(String? idFriend, String? idSelf) async {
    try {
      //removes FRIEND from MY FRIENDS
      await db.collection("users").doc(idSelf).update({
        'friends': FieldValue.arrayRemove([idFriend]),
      });

      //removes ME from FRIEND'S FRIENDS
      await db.collection("users").doc(idFriend).update({
        'friends': FieldValue.arrayRemove([idSelf]),
      });

      return "Successfully unfriended!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //edits bio (ME)
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
