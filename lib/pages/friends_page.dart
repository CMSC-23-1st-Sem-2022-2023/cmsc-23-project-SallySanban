import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:project_teknomo/classes/me.dart';
import 'package:project_teknomo/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/providers/auth_provider.dart';
import 'package:project_teknomo/pages/search_page.dart';

//page for all users list
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
        elevation: 0,
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
        flexibleSpace: SafeArea(
          child: Image(
            image: AssetImage('images/appbar.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          IconButton(
              icon:
                  Icon(Icons.search, color: Color.fromARGB(255, 115, 112, 112)),
              onPressed: () async {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              })
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: usersStream,
            builder: (context, snapshot) {
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

              documents = snapshot.data!.docs;

              if (searchController.text.length > 0) {
                documents = snapshot.data!.docs
                    .where((DocumentSnapshot documentSnapshot) {
                  String input = searchController.text.toLowerCase();
                  String result = documentSnapshot['userName'].toLowerCase();

                  return result.contains(input);
                }).toList();
              }

              UserData self = UserData.fromJson(snapshot.data?.docs
                  .firstWhere((doc) => doc.id == Me.myId)
                  .data() as Map<String, dynamic>);

              return Column(
                children: [
                  GestureDetector(
                    onTap: () => {
                      context.read<UserProvider>().changeSelectedUser(self),
                      Navigator.pushNamed(context, '/profile'),
                    },
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/profile.jpg"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.white.withOpacity(0.4),
                                  BlendMode.dstATop),
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle_rounded,
                                size: 80.0,
                                color: Colors.pink,
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text(
                                "Welcome back, ${self.userName}!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 115, 112, 112),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                "Visit your profile",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[500],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      Text(
                        "Grow your network!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: ((context, index) {
                      UserData friend = UserData.fromJson(
                          documents[index].data() as Map<String, dynamic>);

                      int checkIfFriend = 0; //0 if not in friends list
                      int checkIfRequestSent = 0; //0 if not requested
                      int checkIfRequestReceived = 0; //0 if not received

                      //checks if user is already your friend
                      //whether the add friend/unfriend button appears depends on this
                      for (var i = 0; i < self.friends!.length; i++) {
                        if (self.friends![i] == friend.id) {
                          checkIfFriend = 1; //1 if already in friends
                        }
                      }

                      //checks if you have sent a request to this user
                      for (var i = 0;
                          i < self.sentFriendRequests!.length;
                          i++) {
                        if (self.sentFriendRequests![i] == friend.id) {
                          checkIfRequestSent = 1; //1 if request already sent
                        }
                      }

                      //checks if user has sent a request to you
                      for (var i = 0;
                          i < self.receivedFriendRequests!.length;
                          i++) {
                        if (self.receivedFriendRequests![i] == friend.id) {
                          checkIfRequestReceived =
                              1; //1 if request already received
                        }
                      }

                      if (friend.id != Me.myId)
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
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
                                      context
                                          .read<UserProvider>()
                                          .sendFriendRequest();
                                    },
                                    icon: Icon(Icons.add_circle,
                                        color: Colors.grey[500]),
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
                            //[2]
                            onTap: () => {
                              context
                                  .read<UserProvider>()
                                  .changeSelectedUser(friend),
                              Navigator.pushNamed(context, '/profile'),
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
      ),
    );
  }
}
