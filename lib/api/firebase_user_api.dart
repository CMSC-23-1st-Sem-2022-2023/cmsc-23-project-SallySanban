import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/models/user_model.dart';

//the following methods edit the database in firebase
class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  //method for sending friend request
  Future<String> sendFriendRequest(String? id) async {
    try {
      //gets the name of the friend using friend's ID [2]
      final docRefFriend = db.collection("users").doc(id);
      await docRefFriend.get().then((DocumentSnapshot doc) async {
        final dataFriend = doc.data() as Map<String, dynamic>;

        //sends friend request from you to friend (by appending list)
        await db.collection("users").doc("Self").update({
          'sentFriendRequests':
              FieldValue.arrayUnion([dataFriend["displayName"]]) //[1]
        });

        //gets your name using your ID
        final docRefSelf = db.collection("users").doc("Self");
        await docRefSelf.get().then((DocumentSnapshot doc) async {
          final dataSelf = doc.data() as Map<String, dynamic>;

          //receives friend request from you to friend (by appending list)
          await db.collection("users").doc(id).update({
            'receivedFriendRequests':
                FieldValue.arrayUnion([dataSelf["displayName"]])
          });
        });
      });

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //method for sending friend request
  Future<String> acceptFriend(String? id) async {
    try {
      //gets the name of the friend using friend's ID
      final docRefFriend = db.collection("users").doc(id);
      await docRefFriend.get().then((DocumentSnapshot doc) async {
        final dataFriend = doc.data() as Map<String, dynamic>;

        //includes friend in list of friends, removes friend from sent friend requests
        await db.collection("users").doc("Self").update({
          'friends': FieldValue.arrayUnion([dataFriend["displayName"]]),
          'sentFriendRequests':
              FieldValue.arrayRemove([dataFriend["displayName"]]), //[1]
        });

        //gets your name using your ID
        final docRefSelf = db.collection("users").doc("Self");
        await docRefSelf.get().then((DocumentSnapshot doc) async {
          final dataSelf = doc.data() as Map<String, dynamic>;

          //includes you in friend's list of friends, removes you from received friend requests
          await db.collection("users").doc(id).update({
            'friends': FieldValue.arrayUnion([dataSelf["displayName"]]),
            'receivedFriendRequests':
                FieldValue.arrayRemove([dataSelf["displayName"]]),
          });
        });
      });

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> declineFriend(String? id) async {
    try {
      //gets the name of the friend using friend's ID
      final docRefFriend = db.collection("users").doc(id);
      await docRefFriend.get().then((DocumentSnapshot doc) async {
        final dataFriend = doc.data() as Map<String, dynamic>;

        //removes friend from sent friend requests
        await db.collection("users").doc("Self").update({
          'sentFriendRequests':
              FieldValue.arrayRemove([dataFriend["displayName"]]),
        });

        //gets your name using your ID
        final docRefSelf = db.collection("users").doc("Self");
        await docRefSelf.get().then((DocumentSnapshot doc) async {
          final dataSelf = doc.data() as Map<String, dynamic>;

          //removes you from received friend requests
          await db.collection("users").doc(id).update({
            'receivedFriendRequests':
                FieldValue.arrayRemove([dataSelf["displayName"]]),
          });
        });
      });

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> unfriend(String? id) async {
    try {
      //gets the name of the friend using friend's ID
      final docRefFriend = db.collection("users").doc(id);
      await docRefFriend.get().then((DocumentSnapshot doc) async {
        final dataFriend = doc.data() as Map<String, dynamic>;

        //removes friend from your friend list
        await db.collection("users").doc("Self").update({
          'friends': FieldValue.arrayRemove([dataFriend["displayName"]]),
        });

        //gets your name using your ID
        final docRefSelf = db.collection("users").doc("Self");
        await docRefSelf.get().then((DocumentSnapshot doc) async {
          final dataSelf = doc.data() as Map<String, dynamic>;

          //removes you from friend's friend list
          await db.collection("users").doc(id).update({
            'friends': FieldValue.arrayRemove([dataSelf["displayName"]]),
          });
        });
      });

      return "Successfully removed todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //gets all users
  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }
}
