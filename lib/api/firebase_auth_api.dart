import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_teknomo/classes/me.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FirebaseAuthAPI {
  //comment out when testing
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  // final db = FakeFirebaseFirestore();
  // final auth = MockFirebaseAuth(
  //   mockUser: MockUser(
  //     isAnonymous: false,
  //     uid: 'someuid',
  //     email: 'charlie@paddyspub.com',
  //     displayName: 'Charlie',
  //   ),
  // );

  //gets user logged in
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  //signs in user
  Future<String?> signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'There is no user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password.';
      } else if (e.code == 'invalid-email') {
        return 'The email provided is invalid.';
      }
    }
  }

  //signs up user
  Future<String?> signUp(
      String email,
      String password,
      String firstName,
      String lastName,
      String userName,
      String day,
      String month,
      String year,
      String location) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, firstName, lastName,
            userName, day, month, year, location);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account using this email already exists.';
      } else if (e.code == 'invalid-email') {
        return 'The email provided is invalid.';
      }
    } catch (e) {
      print(e);
    }
  }

  //signs out user
  void signOut() async {
    auth.signOut();
  }

  //saves signed up user to database
  void saveUserToFirestore(
      String? uid,
      String email,
      String firstName,
      String lastName,
      String userName,
      String day,
      String month,
      String year,
      String location) async {
    try {
      await db.collection("users").doc(uid).set({
        "id": uid,
        "email": email,
        "name": firstName + " " + lastName,
        "userName": userName,
        "birthday": {'day': day, 'month': month, 'year': year},
        "location": location,
        "bio": "Click the pencil on the upper right to edit your bio!",
        "friends": [],
        "receivedFriendRequests": [],
        "sentFriendRequests": [],
        "todos": []
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
