import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/api/firebase_user_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:project_teknomo/classes/me.dart';
import 'package:project_teknomo/providers/user_provider.dart';

//page for search bar
class MySearchDelegate extends SearchDelegate {
  List<DocumentSnapshot> suggestions = [];

  //back arrow
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  //clear icon
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        ),
      ];

  @override
  Widget buildResults(BuildContext context) => Container();

  //shows all users if no search and filters users (by username/name) if with search
  //also shows add friend/unfriend button when applicable
  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseUserAPI.db.collection("users").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text("No Users Found"),
          );
        }

        suggestions = snapshot.data!.docs;

        if (query.length > 0) {
          suggestions =
              snapshot.data!.docs.where((DocumentSnapshot documentSnapshot) {
            String input = query.toLowerCase();
            String usernameResult = documentSnapshot['userName'].toLowerCase();
            String nameResult = documentSnapshot['name'].toLowerCase();

            return usernameResult.contains(input) || nameResult.contains(input);
          }).toList();
        }

        return ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: suggestions.length,
          itemBuilder: ((context, index) {
            UserData friend = UserData.fromJson(
                suggestions[index].data() as Map<String, dynamic>);

            UserData self = UserData.fromJson(snapshot.data?.docs
                .firstWhere((doc) => doc.id == Me.myId)
                .data() as Map<String, dynamic>);

            int checkIfFriend = 0;
            int checkIfRequestSent = 0;
            int checkIfRequestReceived = 0;

            for (var i = 0; i < self.friends!.length; i++) {
              if (self.friends![i] == friend.id) {
                checkIfFriend = 1;
              }
            }

            for (var i = 0; i < self.sentFriendRequests!.length; i++) {
              if (self.sentFriendRequests![i] == friend.id) {
                checkIfRequestSent = 1;
              }
            }

            for (var i = 0; i < self.receivedFriendRequests!.length; i++) {
              if (self.receivedFriendRequests![i] == friend.id) {
                checkIfRequestReceived = 1;
              }
            }

            if (friend.id != Me.myId)
              return Padding(
                padding: EdgeInsets.only(top: 10),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${friend.name}",
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "${friend.userName}",
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  leading: const Icon(Icons.account_circle_rounded,
                      size: 50.0, color: Colors.pink),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (checkIfFriend == 0 &&
                          checkIfRequestSent == 0 &&
                          checkIfRequestReceived == 0 &&
                          friend.id != self.id)
                        IconButton(
                          onPressed: () {
                            context
                                .read<UserProvider>()
                                .changeSelectedUser(friend);
                            context.read<UserProvider>().sendFriendRequest();
                          },
                          icon: Icon(Icons.add_circle, color: Colors.grey[500]),
                        ),
                      if (checkIfFriend == 1 && friend.id != self.id)
                        IconButton(
                          onPressed: () {
                            context
                                .read<UserProvider>()
                                .changeSelectedUser(friend);
                            context.read<UserProvider>().unfriend();
                          },
                          icon: Icon(Icons.remove_circle,
                              color: Colors.grey[500]),
                        ),
                    ],
                  ),
                  onTap: () => {
                    context.read<UserProvider>().changeSelectedUser(friend),
                    Navigator.pushNamed(context, '/profile'),
                  },
                ),
              );
            return Container();
          }),
        );
      },
    );
  }
}
