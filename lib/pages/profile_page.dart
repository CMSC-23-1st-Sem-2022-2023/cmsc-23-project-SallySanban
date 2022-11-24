import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:project_teknomo/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/api/firebase_user_api.dart';

//page of profile of each user (can access each user info because user was passed)
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${context.read<UserProvider>().selected.firstName} ${context.read<UserProvider>().selected.lastName}'s Profile"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Icon(Icons.account_circle_rounded, size: 80.0),
          Text(
            "${context.read<UserProvider>().selected.firstName} ${context.read<UserProvider>().selected.lastName}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          Text(
            "${context.read<UserProvider>().selected.userName}",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Colors.grey[500],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            "Friends",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          //accesses list of friends of the user passed
          FutureBuilder(
            future: loopThroughFriends(
                context.read<UserProvider>().selected.friends),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                return snapshot.data!;
              }
            },
          ),
          Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Colors.grey[500],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            "Pending Friend Requests",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          //accesses list of received friend requests of the user passed
          FutureBuilder(
            future: loopThroughReceivedRequests(
              context.read<UserProvider>().selected.receivedFriendRequests,
            ),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                return snapshot.data!;
              }
            },
          ),
          Divider(
            height: 20,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            color: Colors.grey[500],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            "Sent Friend Requests",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          //accesses list of sent friend requests of the user passed
          FutureBuilder(
            future: loopThroughSentRequests(
              context.read<UserProvider>().selected.sentFriendRequests,
            ),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                return snapshot.data!;
              }
            },
          ),
        ],
      ),
    );
  }

  //loops through friends
  Future<Widget> loopThroughFriends(List? friends) async {
    List<Widget> list = [];

    if (friends == null) {
      return Text("");
    } else {
      for (var i = 0; i < friends.length; i++) {
        final docRefFriend =
            FirebaseTodoAPI.db.collection("users").doc(friends[i]);
        await docRefFriend.get().then((DocumentSnapshot doc) async {
          final dataFriend = doc.data() as Map<String, dynamic>;

          list.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "${dataFriend['firstName']} ${dataFriend['lastName']}",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
            ),
          ]));
        });
      }
      return Column(children: list);
    }
  }

  //loops through received friend requests
  Future<Widget> loopThroughReceivedRequests(List? friendRequests) async {
    List<Widget> list = [];

    if (friendRequests == null) {
      return Text("");
    } else {
      for (var i = 0; i < friendRequests.length; i++) {
        final docRefFriend =
            FirebaseTodoAPI.db.collection("users").doc(friendRequests[i]);
        await docRefFriend.get().then(
          (DocumentSnapshot doc) async {
            final dataFriend = doc.data() as Map<String, dynamic>;

            list.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${dataFriend['firstName']} ${dataFriend['lastName']}",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                  ),
                  IconButton(
                    onPressed: () {
                      //makes sure user passed is passed to accept friend
                      context.read<UserProvider>().changeSelectedUser(
                          context.read<UserProvider>().selected);
                      //calls accept friend
                      context.read<UserProvider>().acceptFriend();
                    },
                    icon: Icon(Icons.check_circle),
                  ),
                  IconButton(
                    onPressed: () {
                      //makes sure user passed is passed to decline friend
                      context.read<UserProvider>().changeSelectedUser(
                          context.read<UserProvider>().selected);
                      //calls decline friend
                      context.read<UserProvider>().declineFriend();
                    },
                    icon: Icon(Icons.remove_circle),
                  ),
                ],
              ),
            );
          },
        );
      }
      return Column(children: list);
    }
  }

  //loops through sent friend requests
  Future<Widget> loopThroughSentRequests(List? friendRequests) async {
    List<Widget> list = [];

    if (friendRequests == null) {
      return Text("");
    } else {
      for (var i = 0; i < friendRequests.length; i++) {
        final docRefFriend =
            FirebaseTodoAPI.db.collection("users").doc(friendRequests[i]);
        await docRefFriend.get().then(
          (DocumentSnapshot doc) async {
            final dataFriend = doc.data() as Map<String, dynamic>;

            list.add(
              Text(
                "${dataFriend['firstName']} ${dataFriend['lastName']}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          },
        );
      }
      return Column(children: list);
    }
  }
}
