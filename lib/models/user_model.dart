import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

//class for user with user information
class UserData {
  final String? id;
  final String firstName;
  final String lastName;
  final String userName;
  final Map<String, dynamic> birthday;
  final String location;
  final String email;
  String? bio;
  List? friends;
  List? receivedFriendRequests;
  List? sentFriendRequests;
  List? todos;

  //constructor to initialize user
  UserData({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.birthday,
    required this.location,
    required this.email,
    this.bio,
    this.friends,
    this.receivedFriendRequests,
    this.sentFriendRequests,
    this.todos,
  });

  //creates user from json information
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      birthday: json['birthday'],
      location: json['location'],
      email: json['email'],
      bio: json['bio'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequests: json['sentFriendRequests'],
      todos: json['todos'],
    );
  }

  //?
  static List<UserData> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<UserData>((dynamic d) => UserData.fromJson(d)).toList();
  }

  //turns user's information to json information
  Map<String, dynamic> toJson(UserData user) {
    return {
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'userName': user.userName,
      'birthday': user.birthday,
      'location': user.location,
      'email': user.email,
      'bio': user.bio,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
      'todos': user.todos,
    };
  }
}
