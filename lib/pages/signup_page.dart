import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final firstName = TextFormField(
      key: const Key('firstNameFieldSignupPage'),
      controller: firstNameController,
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
      onChanged: ((String? value) {
        value = firstNameController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
      },
    );

    final lastName = TextFormField(
      key: const Key('lastNameFieldSignupPage'),
      controller: lastNameController,
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
      onChanged: ((String? value) {
        value = lastNameController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
      },
    );

    final email = TextFormField(
      key: const Key('emailFieldSignupPage'),
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
      key: const Key('passwordFieldSignupPage'),
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
        } else if (value.length < 6) {
          return 'Weak password';
        }
      },
    );

    final SignupButton = Padding(
      key: const Key('signupButtonSignupPage'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState?.save();

            String? errorMessage = await context.read<AuthProvider>().signUp(
                emailController.text,
                passwordController.text,
                firstNameController.text,
                lastNameController.text);

            if (errorMessage != null) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    key: const Key('errorDialog'),
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
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      key: const Key('backButtonSignupPage'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
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
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              firstName,
              lastName,
              email,
              password,
              SignupButton,
              backButton
            ],
          ),
        ),
      ),
    );
  }
}
