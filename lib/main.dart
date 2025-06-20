import 'package:flutter/material.dart';
import 'package:project_teknomo/pages/friends_page.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/providers/user_provider.dart';
import 'package:project_teknomo/providers/todo_provider.dart';
import 'package:project_teknomo/providers/auth_provider.dart';
import 'package:project_teknomo/pages/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:project_teknomo/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //comment out when testing
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //initializes providers for app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => UserProvider())),
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
      ],
      child: MyApp(),
    ),
  );
}

//initializes navigation routes for app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleTodo',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/profile': (context) => const ProfilePage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

//goes to signup page if not authenticated, goes to friends page if authenticated
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return const FriendsPage();
    } else {
      return const SignupPage();
    }
  }
}
