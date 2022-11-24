import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:project_teknomo/me.dart';
import 'package:project_teknomo/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/providers/auth_provider.dart';

//page for friends list
class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> usersStream = context.watch<UserProvider>().users;
    List<DocumentSnapshot> documents = [];

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  context.read<AuthProvider>().signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
              Container(
                padding: EdgeInsets.all(8),
                //search bar [1]
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    value = searchController.text;
                  }),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
              //gets the documents (the users) from
              StreamBuilder(
                stream: usersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error encountered! ${snapshot.error}"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text("No Users Found"),
                    );
                  }

                  //all the users
                  documents = snapshot.data!.docs;

                  //filters the users depending on what was searched [5] [6]
                  if (searchController.text.length > 0) {
                    documents = snapshot.data!.docs
                        .where((DocumentSnapshot documentSnapshot) =>
                            documentSnapshot['userName'] ==
                            searchController.text)
                        .toList();
                  }

                  //shows the users (shows filtered users if there is a search)
                  return ListView.separated(
                    reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemBuilder: ((context, index) {
                      //each user in document (with accessible info)

                      UserData friend = UserData.fromJson(
                          documents[index].data() as Map<String, dynamic>);
                      //user info for you [3]
                      // UserData me = UserData.fromJson(snapshot.data?.docs
                      //     .firstWhere((doc) => doc.id == Me.myId)
                      //     .data() as Map<String, dynamic>);

                      //initializes to 0 for every user
                      int checkIfFriend = 0; //0 if not in friends list
                      int checkIfRequestSent = 0; //0 if not requested
                      //checks if user is already your friend or you have already sent a friend request to this user
                      //whether the add friend/unfriend button appears depends on this
                      // for (var i = 0; i < me.friends!.length; i++) {
                      //   if (me.friends![i] == friend.id) {
                      //     checkIfFriend = 1; //1 if already in friends
                      //   }
                      // }

                      // for (var i = 0; i < me.sentFriendRequests!.length; i++) {
                      //   if (me.sentFriendRequests![i] == friend.id) {
                      //     checkIfRequestSent = 1; //1 if request already sent
                      //   }
                      // }

                      return ListTile(
                        title: Text(friend.userName),
                        leading: const Icon(Icons.account_circle_rounded,
                            size: 50.0),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //shows add friend only if not friend yet, havent sent friend req yet, not you [4]
                            // if (checkIfFriend == 0 &&
                            //     checkIfRequestSent == 0 &&
                            //     friend.id != me.id)
                            IconButton(
                              onPressed: () {
                                context
                                    .read<UserProvider>()
                                    //makes sure the friend clicked on's user is passed to sendFriendRequest
                                    .changeSelectedUser(friend);
                                context //calls sendFriendRequest
                                    .read<UserProvider>()
                                    .sendFriendRequest();
                              },
                              icon: const Icon(Icons.add_circle),
                            ),
                            //shows unfriend only if already friend, not you [4]
                            //if (checkIfFriend == 1 && friend.id != me.id)
                            IconButton(
                              onPressed: () {
                                context
                                    .read<UserProvider>()
                                    //makes sure the friend clicked on's user is passed to unfriend
                                    .changeSelectedUser(friend);
                                context
                                    .read<UserProvider>()
                                    .unfriend(); //calls unfriend
                              },
                              icon: const Icon(Icons.remove_circle),
                            ),
                          ],
                        ),
                        //[2]
                        onTap: () => {
                          context //makes sure friend user is passed when switching pages
                              .read<UserProvider>()
                              .changeSelectedUser(friend),
                          Navigator.pushNamed(context,
                              '/profile'), //goes to profile of clicked user
                        },
                      );
                    }),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
