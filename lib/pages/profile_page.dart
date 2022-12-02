import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/models/user_model.dart';
import 'package:project_teknomo/models/todo_model.dart';
import 'package:project_teknomo/providers/user_provider.dart';
import 'package:project_teknomo/providers/todo_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_teknomo/api/firebase_user_api.dart';
import 'package:project_teknomo/classes/me.dart';
import 'package:project_teknomo/classes/dropdown.dart';

//page of profile of each user (can access each user info because user was passed)
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final _formKeyEditBio = GlobalKey<FormState>();
  TextEditingController bioController = TextEditingController();

  final _formKeyAdd = GlobalKey<FormState>();
  TextEditingController titleAddController = TextEditingController();
  TextEditingController descriptionAddController = TextEditingController();
  TextEditingController dayAddController = TextEditingController();
  TextEditingController monthAddController = TextEditingController();
  TextEditingController yearAddController = TextEditingController();

  final _formKeyEdit = GlobalKey<FormState>();
  TextEditingController titleEditController = TextEditingController();
  TextEditingController descriptionEditController = TextEditingController();
  TextEditingController dayEditController = TextEditingController();
  TextEditingController monthEditController = TextEditingController();
  TextEditingController yearEditController = TextEditingController();

  static final List<String> _dropdownOptions = ["Yes", "No"];

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Image(
            image: AssetImage('images/appbar.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        backgroundColor: Colors.transparent,
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
              onPressed: () async {
                context
                    .read<UserProvider>()
                    .changeSelectedUser(context.read<UserProvider>().selected);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Edit Bio"),
                    content: Container(
                      child: Form(
                        key: _formKeyEditBio,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: TextFormField(
                                controller: bioController,
                                decoration: const InputDecoration(
                                  hintText: "Enter new bio",
                                ),
                                maxLines: null,
                                onChanged: ((String? value) {
                                  value = bioController.text;
                                }),
                                validator: (value) {
                                  if (value!.length > 150) {
                                    return 'Must be less than 150 characters';
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          if (_formKeyEditBio.currentState!.validate()) {
                            _formKeyEditBio.currentState?.save();
                            context
                                .read<UserProvider>()
                                .editBio(bioController.text);

                            bioController.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("OK"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.pink,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          bioController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/profile.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.4), BlendMode.dstATop),
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
        if (context.read<UserProvider>().selected.friends!.isNotEmpty)
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
        if (context.read<UserProvider>().selected.friends!.isEmpty)
          SizedBox(
            height: 280,
            child: Center(
              child: Text("No friends yet!"),
            ),
          )
      ],
    );
  }

  Widget todoTab() {
    return ListView(
      children: [
        if ((context.read<UserProvider>().selected.friends!.contains(Me.myId) ||
                context.read<UserProvider>().selected.id == Me.myId) &&
            context.read<UserProvider>().selected.todos!.isNotEmpty)
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
          ),
        if (context.read<UserProvider>().selected.todos!.isEmpty)
          SizedBox(
            height: 280,
            child: Center(
              child: Text("No todos yet!"),
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

            UserData friend = UserData.fromJson(dataFriend);

            list.add(
              Column(
                children: [
                  ListTile(
                    title: Text(
                      "${friend.firstName} ${friend.lastName}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    subtitle: Text(
                      "${friend.userName}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    leading: Icon(Icons.account_circle_rounded,
                        size: 50.0, color: Colors.pink),
                    onTap: () {
                      context //makes sure friend user is passed when switching pages
                          .read<UserProvider>()
                          .changeSelectedUser(friend);
                      Navigator.pushNamed(context, '/profile');
                    },
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

            UserData friend = UserData.fromJson(dataFriend);

            list.add(
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  elevation: 1.0,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "${friend.firstName} ${friend.lastName}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        subtitle: Text(
                          "${friend.userName}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        leading: Icon(Icons.account_circle_rounded,
                            size: 50.0, color: Colors.pink),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                //makes sure user passed is passed to accept friend
                                context
                                    .read<UserProvider>()
                                    .changeSelectedUser(friend);
                                //calls accept friend
                                context.read<UserProvider>().acceptFriend();
                              },
                              icon: Icon(Icons.check_circle,
                                  color: Colors.grey[500]),
                            ),
                            IconButton(
                              onPressed: () {
                                //makes sure user passed is passed to decline friend
                                context
                                    .read<UserProvider>()
                                    .changeSelectedUser(friend);
                                //calls decline friend
                                context.read<UserProvider>().declineFriend();
                              },
                              icon: Icon(Icons.remove_circle,
                                  color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        onTap: (() {
                          context //makes sure friend user is passed when switching pages
                              .read<UserProvider>()
                              .changeSelectedUser(friend);
                          Navigator.pushNamed(context, '/profile');
                        }),
                      ),
                    ],
                  ),
                ),
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
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  elevation: 2.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                          ),
                          Text(
                            "Due ${dataTodo['deadline']['day']}/${dataTodo['deadline']['month']}/${dataTodo['deadline']['year']}",
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text(dataTodo['title']),
                        subtitle: Text(
                          dataTodo['description'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                        ),
                        leading: Checkbox(
                          value: dataTodo['status'],
                          onChanged: (bool? value) {
                            if (context.read<UserProvider>().selected.id ==
                                Me.myId)
                              context
                                  .read<TodoListProvider>()
                                  .changeSelectedTodo(Todo.fromJson(dataTodo));
                            if (context.read<UserProvider>().selected.id ==
                                Me.myId)
                              context
                                  .read<TodoListProvider>()
                                  .toggleStatus(value!);
                            if (context.read<UserProvider>().selected.id !=
                                Me.myId)
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  content: Text(
                                    "You cannot change the status of this task!",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.pink,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                    .changeSelectedTodo(
                                        Todo.fromJson(dataTodo));
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text("Edit Task"),
                                    content: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        child: Form(
                                          key: _formKeyEdit,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: TextFormField(
                                                  controller:
                                                      titleEditController,
                                                  decoration: InputDecoration(
                                                    hintText: "Task",
                                                  ),
                                                  onChanged: ((String? value) {
                                                    value = titleEditController
                                                        .text;
                                                  }),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Required';
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10)),
                                              Center(
                                                child: TextFormField(
                                                  controller:
                                                      descriptionEditController,
                                                  decoration: InputDecoration(
                                                    hintText: "Description",
                                                  ),
                                                  maxLines: null,
                                                  onChanged: ((String? value) {
                                                    value =
                                                        descriptionEditController
                                                            .text;
                                                  }),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Required';
                                                    } else if (value.length >
                                                        50) {
                                                      return 'Must be less than 50 characters';
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20)),
                                              Text(
                                                "Deadline",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 115, 112, 112),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  new Flexible(
                                                    child: TextFormField(
                                                      controller:
                                                          dayEditController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Day",
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged:
                                                          ((String? value) {
                                                        value =
                                                            dayEditController
                                                                .text;
                                                      }),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Required';
                                                        } else if (int.parse(
                                                                    value) <
                                                                1 ||
                                                            int.parse(value) >
                                                                31) {
                                                          return 'Invalid';
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  new Flexible(
                                                    child: TextFormField(
                                                      controller:
                                                          monthEditController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Month",
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged:
                                                          ((String? value) {
                                                        value =
                                                            monthEditController
                                                                .text;
                                                      }),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Required';
                                                        } else if (int.parse(
                                                                    value) <
                                                                1 ||
                                                            int.parse(value) >
                                                                12) {
                                                          return 'Invalid';
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  new Flexible(
                                                    child: TextFormField(
                                                      controller:
                                                          yearEditController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Year",
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged:
                                                          ((String? value) {
                                                        value =
                                                            yearEditController
                                                                .text;
                                                      }),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Required';
                                                        } else if (value
                                                                .length !=
                                                            4) {
                                                          return 'Invalid';
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20)),
                                              Text(
                                                "Allow notifications?",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 115, 112, 112),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: _dropdownOptions
                                                          .first,
                                                      onChanged:
                                                          (String? value) {
                                                        if (value == "Yes") {
                                                          Dropdown.dropdownValue =
                                                              true;
                                                        } else {
                                                          Dropdown.dropdownValue =
                                                              false;
                                                        }
                                                      },
                                                      items: _dropdownOptions
                                                          .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                        (String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 200),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          if (_formKeyEdit.currentState!
                                              .validate()) {
                                            _formKeyEdit.currentState?.save();
                                            DateTime date = DateTime.now();
                                            String actualTimestamp =
                                                date.day.toString() +
                                                    "/" +
                                                    date.month.toString() +
                                                    "/" +
                                                    date.year.toString() +
                                                    " " +
                                                    date.hour.toString() +
                                                    ":" +
                                                    date.minute.toString();

                                            final docRefSelf = FirebaseTodoAPI
                                                .db
                                                .collection("users")
                                                .doc(Me.myId);
                                            await docRefSelf.get().then(
                                              (DocumentSnapshot doc) async {
                                                final dataSelf = doc.data()
                                                    as Map<String, dynamic>;

                                                print(dataSelf['userName']);

                                                context
                                                    .read<TodoListProvider>()
                                                    .editTodo(
                                                        "title",
                                                        titleEditController
                                                            .text);

                                                context
                                                    .read<TodoListProvider>()
                                                    .editTodo(
                                                        "description",
                                                        descriptionEditController
                                                            .text);

                                                context
                                                    .read<TodoListProvider>()
                                                    .editTodo("deadline", {
                                                  'day': dayEditController.text,
                                                  'month':
                                                      monthEditController.text,
                                                  'year':
                                                      yearEditController.text
                                                });

                                                context
                                                    .read<TodoListProvider>()
                                                    .editTodo("notifications",
                                                        Dropdown.dropdownValue);

                                                context
                                                    .read<TodoListProvider>()
                                                    .editTodo("lastEdited",
                                                        actualTimestamp);

                                                context
                                                    .read<TodoListProvider>()
                                                    .editTodo("lastEditedBy",
                                                        dataSelf['userName']);

                                                Navigator.of(context).pop();
                                              },
                                            );
                                          }
                                        },
                                        child: Text("OK"),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.pink,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel"),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.pink,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.create_outlined),
                            ),
                            if (context.read<UserProvider>().selected.id ==
                                Me.myId)
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<TodoListProvider>()
                                      .changeSelectedTodo(
                                          Todo.fromJson(dataTodo));
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text("Delete Task"),
                                      content: Text(
                                        "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<TodoListProvider>()
                                                .deleteTodo();

                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.pink,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel"),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.pink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete_outlined),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "last edited ${dataTodo['lastEdited']} by ${dataTodo['lastEditedBy']}",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(right: 15)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 15)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
    return Column(children: list);
  }

  Widget floatingActionButton() {
    if (context.read<UserProvider>().selected.id == Me.myId) {
      return FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Add Task"),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: Form(
                    key: _formKeyAdd,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: TextFormField(
                            controller: titleAddController,
                            decoration: InputDecoration(
                              hintText: "Task",
                            ),
                            onChanged: ((String? value) {
                              value = titleAddController.text;
                            }),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Center(
                          child: TextFormField(
                            controller: descriptionAddController,
                            decoration: InputDecoration(
                              hintText: "Description",
                            ),
                            maxLines: null,
                            onChanged: ((String? value) {
                              value = descriptionAddController.text;
                            }),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              } else if (value.length > 50) {
                                return 'Must be less than 50 characters';
                              }
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20)),
                        Text(
                          "Deadline",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 115, 112, 112),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Flexible(
                              child: TextFormField(
                                controller: dayAddController,
                                decoration: InputDecoration(
                                  hintText: "Day",
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: ((String? value) {
                                  value = dayAddController.text;
                                }),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  } else if (int.parse(value) < 1 ||
                                      int.parse(value) > 31) {
                                    return 'Invalid';
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            new Flexible(
                              child: TextFormField(
                                controller: monthAddController,
                                decoration: InputDecoration(
                                  hintText: "Month",
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: ((String? value) {
                                  value = monthAddController.text;
                                }),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  } else if (int.parse(value) < 1 ||
                                      int.parse(value) > 12) {
                                    return 'Invalid';
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            new Flexible(
                              child: TextFormField(
                                controller: yearAddController,
                                decoration: InputDecoration(
                                  hintText: "Year",
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: ((String? value) {
                                  value = yearAddController.text;
                                }),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  } else if (value.length != 4) {
                                    return 'Invalid';
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20)),
                        Text(
                          "Allow notifications?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 115, 112, 112),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _dropdownOptions.first,
                                onChanged: (String? value) {
                                  if (value == "Yes") {
                                    Dropdown.dropdownValue = true;
                                  } else {
                                    Dropdown.dropdownValue = false;
                                  }
                                },
                                items: _dropdownOptions
                                    .map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 200),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (_formKeyAdd.currentState!.validate()) {
                      _formKeyAdd.currentState?.save();
                      DateTime date = DateTime.now();
                      String actualTimestamp = date.day.toString() +
                          "/" +
                          date.month.toString() +
                          "/" +
                          date.year.toString() +
                          " " +
                          date.hour.toString() +
                          ":" +
                          date.minute.toString();

                      final docRefSelf =
                          FirebaseTodoAPI.db.collection("users").doc(Me.myId);
                      await docRefSelf.get().then(
                        (DocumentSnapshot doc) async {
                          final dataSelf = doc.data() as Map<String, dynamic>;

                          print(dataSelf['userName']);

                          Todo todo = Todo(
                            title: titleAddController.text,
                            description: descriptionAddController.text,
                            status: false,
                            deadline: {
                              'day': dayAddController.text,
                              'month': monthAddController.text,
                              'year': yearAddController.text
                            },
                            notifications: Dropdown.dropdownValue,
                            lastEdited: actualTimestamp,
                            lastEditedBy: dataSelf['userName'],
                          );

                          context.read<TodoListProvider>().addTodo(todo);

                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                  child: Text("OK"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.pink,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.pink,
                  ),
                ),
              ],
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
