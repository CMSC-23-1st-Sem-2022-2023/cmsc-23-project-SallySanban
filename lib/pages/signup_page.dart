import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_teknomo/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignUp = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailSignupController = TextEditingController();
  TextEditingController passwordSignupController = TextEditingController();
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    final userName = TextFormField(
      key: const Key('userNameFieldSignupPage'),
      controller: userNameController,
      decoration: const InputDecoration(
        hintText: "Username",
      ),
      onChanged: ((String? value) {
        value = userNameController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        } else if (value.contains(" ")) {
          return 'Alphanumeric and underscore only';
        }
      },
    );

    final day = TextFormField(
      key: const Key('dayFieldSignupPage'),
      controller: dayController,
      decoration: const InputDecoration(
        hintText: "Day",
      ),
      onChanged: ((String? value) {
        value = dayController.text;
      }),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        } else if (int.parse(value) < 1 || int.parse(value) > 31) {
          return 'Invalid';
        }
      },
    );

    final month = TextFormField(
      key: const Key('monthFieldSignupPage'),
      controller: monthController,
      decoration: const InputDecoration(
        hintText: "Month",
      ),
      onChanged: ((String? value) {
        value = monthController.text;
      }),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        } else if (int.parse(value) < 1 || int.parse(value) > 12) {
          return 'Invalid';
        }
      },
    );

    final year = TextFormField(
      key: const Key('yearFieldSignupPage'),
      controller: yearController,
      decoration: const InputDecoration(
        hintText: "Year",
      ),
      onChanged: ((String? value) {
        value = yearController.text;
      }),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        } else if (value.length != 4) {
          return 'Invalid';
        }
      },
    );

    final location = TextFormField(
      key: const Key('locationFieldSignupPage'),
      controller: locationController,
      decoration: const InputDecoration(
        hintText: "Location",
      ),
      onChanged: ((String? value) {
        value = locationController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
      },
    );

    final emailSignup = TextFormField(
      key: const Key('emailFieldSignupPage'),
      controller: emailSignupController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      onChanged: ((String? value) {
        value = emailSignupController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
      },
    );

    final passwordSignup = TextFormField(
      key: const Key('passwordFieldSignupPage'),
      controller: passwordSignupController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      onChanged: ((String? value) {
        value = passwordSignupController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        } else if (value.length < 8) {
          return 'Weak password';
        } else if (!(value.contains(RegExp(r'[0-9]')))) {
          //contains at least one number
          return 'Must contain at least one number';
        } else if (!(value.contains(RegExp(r'[A-Z]')))) {
          //contains at least one uppercase letter
          return 'Must contain at least one uppercase letter';
        } else if (!(value.contains(RegExp(r'[a-z]')))) {
          //contains at least one lowercase letter
          return 'Must contain at least one lowercase letter';
        } else if (!(value.contains(
            RegExp(r'[ !"#\$%&\(\)\*\+,\-\./:;>=<\?@\{\}\[\]\^\_`\|~]')))) {
          //contains at least one special character
          return 'Must contain at least one special character';
        }
      },
    );

    final emailLogin = TextFormField(
      key: const Key('emailFieldLoginPage'),
      controller: emailLoginController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      onChanged: ((String? value) {
        value = emailLoginController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
      },
    );

    final passwordLogin = TextFormField(
      key: const Key('passwordFieldLoginPage'),
      controller: passwordLoginController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      onChanged: ((String? value) {
        value = passwordLoginController.text;
      }),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
      },
    );

    final SignupButton = Padding(
        key: const Key('signupButtonSignupPage'),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
          onPressed: () async {
            if (_formKeySignUp.currentState!.validate()) {
              _formKeySignUp.currentState?.save();

              String? errorMessage = await context.read<AuthProvider>().signUp(
                  emailSignupController.text,
                  passwordSignupController.text,
                  firstNameController.text,
                  lastNameController.text,
                  userNameController.text,
                  dayController.text,
                  monthController.text,
                  yearController.text,
                  locationController.text);

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
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.pink,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
          child: const Text('Sign up', style: TextStyle(color: Colors.white)),
        ));

    final loginButton = Padding(
      key: const Key('loginButtonLoginPage'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
        onPressed: () async {
          if (_formKeyLogin.currentState!.validate()) {
            _formKeyLogin.currentState?.save();
            String? errorMessage = await context.read<AuthProvider>().signIn(
                emailLoginController.text, passwordLoginController.text);

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
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.pink,
                          ),
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

    Widget switchButton(String type) {
      if (type == "sign up") {
        return Form(
          key: _formKeySignUp,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              children: [
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(child: firstName),
                    SizedBox(
                      width: 20.0,
                    ),
                    new Flexible(child: lastName),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                userName,
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Text(
                  "Birthday",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 115, 112, 112),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(child: day),
                    SizedBox(
                      width: 20.0,
                    ),
                    new Flexible(child: month),
                    SizedBox(
                      width: 20.0,
                    ),
                    new Flexible(child: year),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                location,
                Padding(padding: EdgeInsets.only(bottom: 10)),
                emailSignup,
                Padding(padding: EdgeInsets.only(bottom: 10)),
                passwordSignup,
                Padding(padding: EdgeInsets.only(bottom: 50)),
                SignupButton,
              ],
            ),
          ),
        );
      } else {
        return Form(
          key: _formKeyLogin,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              children: <Widget>[
                emailLogin,
                Padding(padding: EdgeInsets.only(bottom: 10)),
                passwordLogin,
                Padding(padding: EdgeInsets.only(bottom: 60)),
                loginButton,
              ],
            ),
          ),
        );
      }
    }

    return Stack(
      children: <Widget>[
        Image(
          image: AssetImage('images/theme.png'),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.only(right: 25, left: 25, top: 120, bottom: 120),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(0.2),
                    child: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      flexibleSpace: TabBar(
                        tabs: <Widget>[
                          Tab(
                            text: "Login",
                          ),
                          Tab(
                            text: "Sign Up",
                          ),
                        ],
                        indicatorColor: Colors.pink,
                        labelColor: Colors.black,
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      switchButton("login"),
                      switchButton("sign up"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
