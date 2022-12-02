import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_teknomo/api/firebase_auth_api.dart';
import 'package:project_teknomo/classes/me.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj;

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;

      if (newUser == null) {
        print("Not signed in");
      } else {
        Me.myId = Me.myId = newUser.uid;
      }

      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      notifyListeners();
    }, onError: (e) {
      // provide a more useful error
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;

  bool get isAuthenticated {
    return user != null;
  }

  Future<String?> signIn(String email, String password) async {
    return await authService.signIn(email, password);
  }

  void signOut() {
    authService.signOut();
  }

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
    return await authService.signUp(email, password, firstName, lastName,
        userName, day, month, year, location);
  }
}
