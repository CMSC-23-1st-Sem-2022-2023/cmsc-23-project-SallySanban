import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:project_teknomo/models/todo_model.dart';
import 'package:project_teknomo/pages/pop_up.dart';
import 'package:project_teknomo/providers/user_provider.dart';
import 'package:project_teknomo/providers/todo_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/api/firebase_user_api.dart';
import 'package:project_teknomo/me.dart';

//page of profile of each user (can access each user info because user was passed)
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 115, 112, 112),
              ),
              onPressed: () => Navigator.pop(context),
            );
          },
        ),
        actions: [
          if (context.read<UserProvider>().selected.id == Me.myId)
            IconButton(
              icon: Icon(Icons.create_outlined,
                  color: Color.fromARGB(255, 115, 112, 112)),
              onPressed: () {
                context
                    .read<UserProvider>()
                    .changeSelectedUser(context.read<UserProvider>().selected);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => PopUp(
                    type: 'Bio',
                  ),
                );
              },
            ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: 120.0,
                  color: Colors.pink,
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  "${context.read<UserProvider>().selected.firstName} ${context.read<UserProvider>().selected.lastName}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${context.read<UserProvider>().selected.userName}",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15,
                  ),
                ),
                Text(
                  "${context.read<UserProvider>().selected.id}",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "${context.read<UserProvider>().selected.bio}",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "LOCATION",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${context.read<UserProvider>().selected.location}",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "BIRTHDAY",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${context.read<UserProvider>().selected.birthday['day']}/${context.read<UserProvider>().selected.birthday['month']}/${context.read<UserProvider>().selected.birthday['year']}",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 30)),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: TabBar(
              controller: tabController,
              tabs: <Widget>[
                Tab(
                  text: "Friends",
                ),
                Tab(
                  text: "To Do List",
                ),
              ],
              indicatorColor: Colors.pink,
              labelColor: Colors.black,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                friendsTab(),
                todoTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton(),
    );
  }

  Widget friendsTab() {
    return ListView(
      children: [
        if (context.read<UserProvider>().selected.id == Me.myId &&
            context
                .read<UserProvider>()
                .selected
                .receivedFriendRequests!
                .isNotEmpty)
          FutureBuilder(
            future: loopThroughReceivedRequests(
                context.read<UserProvider>().selected.receivedFriendRequests),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                return snapshot.data!;
              }
            },
          ),
        FutureBuilder(
          future:
              loopThroughFriends(context.read<UserProvider>().selected.friends),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return Text("");
            } else {
              return snapshot.data!;
            }
          },
        ),
      ],
    );
  }

  Widget todoTab() {
    return ListView(
      children: [
        if (context.read<UserProvider>().selected.friends!.contains(Me.myId) ||
            context.read<UserProvider>().selected.id == Me.myId)
          FutureBuilder(
            future: loopThroughTodos(
              context.read<UserProvider>().selected.todos,
            ),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                return snapshot.data!;
              }
            },
          ),
        if (!(context
                .read<UserProvider>()
                .selected
                .friends!
                .contains(Me.myId)) &&
            !(context.read<UserProvider>().selected.id == Me.myId))
          SizedBox(
            height: 280,
            child: Center(
              child: Text("Please add me as a friend to see my to do list!"),
            ),
          )
      ],
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
        await docRefFriend.get().then(
          (DocumentSnapshot doc) async {
            final dataFriend = doc.data() as Map<String, dynamic>;

            list.add(
              Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${dataFriend['firstName']} ${dataFriend['lastName']}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "${dataFriend['userName']}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    leading: Icon(Icons.account_circle_rounded,
                        size: 50.0, color: Colors.pink),
                  ),
                  Divider(
                    height: 30,
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 30,
                    color: Color.fromARGB(255, 200, 200, 200),
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
              Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${dataFriend['firstName']} ${dataFriend['lastName']}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "${dataFriend['userName']}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    leading: Icon(Icons.account_circle_rounded,
                        size: 50.0, color: Colors.pink),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            //makes sure user passed is passed to accept friend
                            context.read<UserProvider>().changeSelectedUser(
                                UserData.fromJson(dataFriend));
                            //calls accept friend
                            context.read<UserProvider>().acceptFriend();
                          },
                          icon:
                              Icon(Icons.check_circle, color: Colors.grey[500]),
                        ),
                        IconButton(
                          onPressed: () {
                            //makes sure user passed is passed to decline friend
                            context.read<UserProvider>().changeSelectedUser(
                                UserData.fromJson(dataFriend));
                            //calls decline friend
                            context.read<UserProvider>().declineFriend();
                          },
                          icon: Icon(Icons.remove_circle,
                              color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 30,
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 30,
                    color: Color.fromARGB(255, 200, 200, 200),
                  ),
                ],
              ),
            );
          },
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Pending Friend Requests",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 115, 112, 112)),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Column(children: list),
          Padding(padding: EdgeInsets.only(top: 20)),
          if (context.read<UserProvider>().selected.friends!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Friends",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 115, 112, 112)),
              ),
            ),
          Padding(padding: EdgeInsets.only(top: 10)),
        ],
      );
    }
  }

  //loops through sent friend requests
  Future<Widget> loopThroughTodos(List? todos) async {
    List<Widget> list = [];

    if (todos == null) {
      return Text("");
    } else {
      for (var i = 0; i < todos.length; i++) {
        final docRefTodo = FirebaseTodoAPI.db.collection("todos").doc(todos[i]);
        await docRefTodo.get().then(
          (DocumentSnapshot doc) async {
            final dataTodo = doc.data() as Map<String, dynamic>;

            list.add(
              ListTile(
                title: Text(dataTodo['title']),
                leading: Checkbox(
                  value: dataTodo['status'],
                  onChanged: (bool? value) {
                    if (context.read<UserProvider>().selected.id == Me.myId)
                      context
                          .read<TodoListProvider>()
                          .changeSelectedTodo(Todo.fromJson(dataTodo));
                    if (context.read<UserProvider>().selected.id == Me.myId)
                      context.read<TodoListProvider>().toggleStatus(value!);
                    if (context.read<UserProvider>().selected.id != Me.myId)
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => PopUp(
                          type: 'Error',
                        ),
                      );
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        context
                            .read<TodoListProvider>()
                            .changeSelectedTodo(Todo.fromJson(dataTodo));
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => PopUp(
                            type: 'Edit',
                          ),
                        );
                      },
                      icon: const Icon(Icons.create_outlined),
                    ),
                    if (context.read<UserProvider>().selected.id == Me.myId)
                      IconButton(
                        onPressed: () {
                          context
                              .read<TodoListProvider>()
                              .changeSelectedTodo(Todo.fromJson(dataTodo));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => PopUp(
                              type: 'Delete',
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      )
                  ],
                ),
              ),
            );
          },
        );
      }
      return Column(children: list);
    }
  }

  Widget floatingActionButton() {
    if (context.read<UserProvider>().selected.id == Me.myId) {
      return FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => PopUp(
              type: 'Add',
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      );
    } else {
      return Container();
    }
  }
}
