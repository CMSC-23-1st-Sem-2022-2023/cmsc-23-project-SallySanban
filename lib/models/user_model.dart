import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';

//class for user with user information
class User {
  final String? id;
  final String firstName;
  final String lastName;
  final String userName;
  final Map<String, int> birthday;
  final String location;
  final String email;
  final String password;
  String? bio;
  List? friends;
  List? receivedFriendRequests;
  List? sentFriendRequests;
  List? todos;

  //constructor to initialize user
  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.birthday,
    required this.location,
    required this.email,
    required this.password,
    this.bio,
    this.friends,
    this.receivedFriendRequests,
    this.sentFriendRequests,
    this.todos,
  });

  //creates user from json information
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      birthday: json['birthday'],
      location: json['location'],
      email: json['email'],
      password: json['password'],
      bio: json['bio'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequests: json['sentFriendRequests'],
      todos: json['todos'],
    );
  }

  //?
  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  //turns user's information to json information
  Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'userName': user.userName,
      'birthday': user.birthday,
      'location': user.location,
      'email': user.email,
      'password': user.password,
      'bio': user.bio,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
      'todos': user.todos,
    };
  }
}
