import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:project_teknomo/classes/me.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> usersStream = context.watch<UserProvider>().users;
    List<DocumentSnapshot> documents = [];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Color.fromARGB(255, 115, 112, 112),
              ),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            );
          },
        ),
        title: Text('Users',
            style: TextStyle(color: Color.fromARGB(255, 115, 112, 112))),
        flexibleSpace: SafeArea(
          child: Image(
            image: AssetImage('images/theme.png'),
            fit: BoxFit.cover,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
              Container(
                padding: EdgeInsets.all(15),
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
                        .where((DocumentSnapshot documentSnapshot) {
                      String input = searchController.text.toLowerCase();
                      String result =
                          documentSnapshot['userName'].toLowerCase();

                      return result.contains(input);
                    }).toList();
                  }

                  //user info for you [3]
                  UserData self = UserData.fromJson(snapshot.data?.docs
                      .firstWhere((doc) => doc.id == Me.myId)
                      .data() as Map<String, dynamic>);

                  //shows the users (shows filtered users if there is a search)
                  return Column(
                    children: [
                      Text(
                        "Welcome back, ${self.userName}!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 25),
                        child: GestureDetector(
                          onTap: () => {
                            context //makes sure friend user is passed when switching pages
                                .read<UserProvider>()
                                .changeSelectedUser(self),
                            Navigator.pushNamed(context,
                                '/profile'), //goes to profile of clicked user
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/profile.jpg"),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.white.withOpacity(0.5),
                                    BlendMode.dstATop),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[500]!.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 0,
                                  offset: Offset(
                                      0.0, 1.0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                ListTile(
                                  title: Text(
                                    "${self.firstName} ${self.lastName}",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  subtitle: Text(
                                    "${self.userName}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  leading: Icon(Icons.account_circle_rounded,
                                      size: 50.0, color: Colors.pink),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: ((context, index) {
                          //each user in document (with accessible info)
                          //print(snapshot.data?.docs[index].data().toString()); THIS PRINT SAVED MY LIFE
                          UserData friend = UserData.fromJson(
                              documents[index].data() as Map<String, dynamic>);

                          //initializes to 0 for every user
                          int checkIfFriend = 0; //0 if not in friends list
                          int checkIfRequestSent = 0; //0 if not requested
                          int checkIfRequestReceived = 0;
                          //checks if user is already your friend or you have already sent a friend request to this user
                          //whether the add friend/unfriend button appears depends on this
                          for (var i = 0; i < self.friends!.length; i++) {
                            if (self.friends![i] == friend.id) {
                              checkIfFriend = 1; //1 if already in friends
                            }
                          }

                          for (var i = 0;
                              i < self.sentFriendRequests!.length;
                              i++) {
                            if (self.sentFriendRequests![i] == friend.id) {
                              checkIfRequestSent =
                                  1; //1 if request already sent
                            }
                          }

                          for (var i = 0;
                              i < self.receivedFriendRequests!.length;
                              i++) {
                            if (self.receivedFriendRequests![i] == friend.id) {
                              checkIfRequestReceived = 1;
                            }
                          }

                          // print(friend.userName);
                          // print(checkIfFriend);
                          // print(checkIfRequestSent);

                          // if (friend.id == Me.myId) {
                          //   print("YES");
                          // } else {
                          //   print(Me.myId);
                          // }
                          if (friend.id != Me.myId)
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${friend.firstName} ${friend.lastName}",
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
                                leading: const Icon(
                                    Icons.account_circle_rounded,
                                    size: 50.0,
                                    color: Colors.pink),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    //shows add friend only if not friend yet, havent sent friend req yet, not you [4]
                                    if (checkIfFriend == 0 &&
                                        checkIfRequestSent == 0 &&
                                        checkIfRequestReceived == 0 &&
                                        friend.id != self.id)
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
                                        icon: Icon(Icons.add_circle,
                                            color: Colors.grey[500]),
                                      ),
                                    //shows unfriend only if already friend, not you [4]
                                    if (checkIfFriend == 1 &&
                                        friend.id != self.id)
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
                                        icon: Icon(Icons.remove_circle,
                                            color: Colors.grey[500]),
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
                              ),
                            );
                          return Container();
                        }),
                      ),
                    ],
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
