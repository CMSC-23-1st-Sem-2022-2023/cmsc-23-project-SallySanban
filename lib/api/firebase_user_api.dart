import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/models/user_model.dart';

//the following methods edit the database in firebase
class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  //method for sending friend request
  Future<String> sendFriendRequest(String? idFriend, String? idSelf) async {
    try {
      //gets the name of the friend using friend's ID [2]
      final docRefFriend = db.collection("users").doc(idFriend);
      await docRefFriend.get().then((DocumentSnapshot doc) async {
        final dataFriend = doc.data() as Map<String, dynamic>;

        //sends friend request from you to friend (by appending list)
        await db.collection("users").doc(idSelf).update({
          'sentFriendRequests': FieldValue.arrayUnion([dataFriend["id"]]) //[1]
        });

        //gets your name using your ID
        final docRefSelf = db.collection("users").doc(idSelf);
        await docRefSelf.get().then((DocumentSnapshot doc) async {
          final dataSelf = doc.data() as Map<String, dynamic>;

          //receives friend request from you to friend (by appending list)
          await db.collection("users").doc(idFriend).update({
            'receivedFriendRequests': FieldValue.arrayUnion([dataSelf["id"]])
          });
        });
      });

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //method for sending friend request
  Future<String> acceptFriend(String? idFriend, String? idSelf) async {
    try {
      print(idSelf);
      print(idFriend);
      //gets the name of the friend using friend's ID
      final docRefFriend = db.collection("users").doc(idFriend);
      await docRefFriend.get().then((DocumentSnapshot doc) async {
        final dataFriend = doc.data() as Map<String, dynamic>;

        //includes friend in list of friends, removes friend from sent friend requests
        await db.collection("users").doc(idSelf).update({
          'friends': FieldValue.arrayUnion([dataFriend["id"]]),
          'sentFriendRequests':
              FieldValue.arrayRemove([dataFriend["id"]]), //[1]
        });

        //gets your name using your ID
        final docRefSelf = db.collection("users").doc(idSelf);
        await docRefSelf.get().then((DocumentSnapshot doc) async {
          final dataSelf = doc.data() as Map<String, dynamic>;

          //includes you in friend's list of friends, removes you from received friend requests
          await db.collection("users").doc(idFriend).update({
            'friends': FieldValue.arrayUnion([dataSelf["id"]]),
            'receivedFriendRequests': FieldValue.arrayRemove([dataSelf["id"]]),
          });
        });
      });

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> declineFriend(String? idFriend, String? idSelf) async {
    try {
      //gets the name of the friend using friend's ID
      final docRefFriend = db.collection("users").doc(idFriend);
      await docRefFriend.get().then((DocumentSnapshot doc) async {
        final dataFriend = doc.data() as Map<String, dynamic>;

        //removes friend from sent friend requests
        await db.collection("users").doc(idSelf).update({
          'sentFriendRequests': FieldValue.arrayRemove([dataFriend["id"]]),
        });

        //gets your name using your ID
        final docRefSelf = db.collection("users").doc(idSelf);
        await docRefSelf.get().then((DocumentSnapshot doc) async {
          final dataSelf = doc.data() as Map<String, dynamic>;

          //removes you from received friend requests
          await db.collection("users").doc(idFriend).update({
            'receivedFriendRequests': FieldValue.arrayRemove([dataSelf["id"]]),
          });
        });
      });

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> unfriend(String? idFriend, String? idSelf) async {
    try {
      //gets the name of the friend using friend's ID
      final docRefFriend = db.collection("users").doc(idFriend);
      await docRefFriend.get().then((DocumentSnapshot doc) async {
        final dataFriend = doc.data() as Map<String, dynamic>;

        //removes friend from your friend list
        await db.collection("users").doc(idSelf).update({
          'friends': FieldValue.arrayRemove([dataFriend["id"]]),
        });

        //gets your name using your ID
        final docRefSelf = db.collection("users").doc(idSelf);
        await docRefSelf.get().then((DocumentSnapshot doc) async {
          final dataSelf = doc.data() as Map<String, dynamic>;

          //removes you from friend's friend list
          await db.collection("users").doc(idFriend).update({
            'friends': FieldValue.arrayRemove([dataSelf["id"]]),
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
