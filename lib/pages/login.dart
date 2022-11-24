import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/providers/auth_provider.dart';
import 'package:project_teknomo/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final email = TextFormField(
      key: const Key('emailFieldLoginPage'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      onChanged: ((String? value) {
        value = emailController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
      },
    );

    final password = TextFormField(
      key: const Key('passwordFieldLoginPage'),
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      onChanged: ((String? value) {
        value = passwordController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
      },
    );

    final loginButton = Padding(
      key: const Key('loginButtonLoginPage'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();
            String? errorMessage = await context
                .read<AuthProvider>()
                .signIn(emailController.text, passwordController.text);

            if (errorMessage != null) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      "${errorMessage}",
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      Center(
                        child: TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final signUpButton = Padding(
      key: const Key('signupButtonLoginPage'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              email,
              password,
              loginButton,
              signUpButton,
            ],
          ),
        ),
      ),
    );
  }
}
