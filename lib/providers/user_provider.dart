import 'package:flutter/material.dart';
import 'package:project_teknomo/api/firebase_user_api.dart';
import 'package:project_teknomo/classes/me.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//provider (UI goes through here and this calls methods in firebase API)
class UserProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _usersStream;
  UserData? _selectedUser;

  UserProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  Stream<QuerySnapshot> get users => _usersStream;
  UserData get selected => _selectedUser!;

  //gets the user clicked
  changeSelectedUser(UserData item) {
    _selectedUser = item;
  }

  //gets all users
  fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  //calls firebase's edit bio
  void editBio(String bio) async {
    String message = await firebaseService.editBio(Me.myId, bio);
    print(message);
    notifyListeners();
  }

  //calls firebase's send friend request
  void sendFriendRequest() async {
    String message =
        await firebaseService.sendFriendRequest(_selectedUser!.id, Me.myId);
    print(message);
    notifyListeners();
  }

  //calls firebase's unfriend
  void unfriend() async {
    String message = await firebaseService.unfriend(_selectedUser!.id, Me.myId);
    print(message);
    notifyListeners();
  }

  //calls firebase's accept friend
  void acceptFriend(String? id) async {
    String message = await firebaseService.acceptFriend(id, Me.myId);
    print(message);
    notifyListeners();
  }

  //calls firebase's decline friend
  void declineFriend(String? id) async {
    String message = await firebaseService.declineFriend(id, Me.myId);
    print(message);
    notifyListeners();
  }
}
