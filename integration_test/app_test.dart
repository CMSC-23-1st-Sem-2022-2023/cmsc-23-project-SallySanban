import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_teknomo/main.dart' as app;
import 'package:flutter/material.dart';

//HAPPY PATH 1: This test checks that when a user logs in using the correct email and password, the app greets them welcome back
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('Happy Path 1', (tester) async {
      app.main();
      await addDelay(5000); //waits for login to appear
      await tester.pumpAndSettle();

      //these are the widgets to find in the login page
      final emailFieldLoginPage = find.byKey(const Key("emailFieldLoginPage"));
      final passwordFieldLoginPage =
          find.byKey(const Key("passwordFieldLoginPage"));
      final loginButtonLoginPage =
          find.byKey(const Key("loginButtonLoginPage"));

      expect(emailFieldLoginPage, findsOneWidget);
      expect(passwordFieldLoginPage, findsOneWidget);
      expect(loginButtonLoginPage, findsOneWidget);

      //types email and password
      await tester.enterText(emailFieldLoginPage, "1@gmail.com"); //email
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(passwordFieldLoginPage, "Aa1234567*"); //password
      await addDelay(5000);
      await tester.pumpAndSettle();

      //clicks login
      await tester.tap(loginButtonLoginPage);
      await addDelay(5000);
      await tester.pumpAndSettle();

      //waits for Firebase
      await addDelay(20000);

      //finds the welcome back
      final profileDisplay = find.text('Welcome back, SOYEON!');

      expect(profileDisplay, findsOneWidget);
    });

    //HAPPY PATH 2: This test checks that when a user clicks on their own profile, the user's info should be shown,
    //and the floating action button should be seen
    testWidgets('Happy Path 2', (tester) async {
      app.main();
      await addDelay(5000); //waits for login page to appear
      await tester.pumpAndSettle();

      //these are the widgets to find in the login page
      final emailFieldLoginPage = find.byKey(const Key("emailFieldLoginPage"));
      final passwordFieldLoginPage =
          find.byKey(const Key("passwordFieldLoginPage"));
      final loginButtonLoginPage =
          find.byKey(const Key("loginButtonLoginPage"));

      expect(emailFieldLoginPage, findsOneWidget);
      expect(passwordFieldLoginPage, findsOneWidget);
      expect(loginButtonLoginPage, findsOneWidget);

      //types email and password
      await tester.enterText(emailFieldLoginPage, "1@gmail.com"); //email
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(passwordFieldLoginPage, "Aa1234567*"); //password
      await addDelay(5000);
      await tester.pumpAndSettle();

      //clicks login
      await tester.tap(loginButtonLoginPage);
      await addDelay(5000);
      await tester.pumpAndSettle();

      //waits for Firebase
      await addDelay(20000);

      //finds visit your profile
      final profileDisplay = find.text('Visit your profile');

      expect(profileDisplay, findsOneWidget);

      //clicks on profile
      await tester.tap(profileDisplay);
      await addDelay(5000);
      await tester.pumpAndSettle();

      //looks for user info and floating action button
      final nameDisplay = find.text('Soyeon Jeon');
      final usernameDisplay = find.text('SOYEON');
      final idDisplay = find.text("4ObGbnSSi5c7bKjDJpfj5AFqRtx1");
      final locationDisplay = find.text('Seoul, Korea');
      final birthdayDisplay = find.text('6/8/1998');
      final addTodoButton = find.byKey(const Key("addTodoButton"));

      expect(nameDisplay, findsOneWidget);
      expect(usernameDisplay, findsOneWidget);
      expect(idDisplay, findsOneWidget);
      expect(locationDisplay, findsOneWidget);
      expect(birthdayDisplay, findsOneWidget);
      expect(addTodoButton, findsOneWidget);
    });

    //UNHAPPY PATH 1: This test checks that app shows error when trying to change status of someone else's todo
    testWidgets('Unhappy Path 1', (tester) async {
      app.main();
      await addDelay(5000); //waits for login page to appear
      await tester.pumpAndSettle();

      //these are the widgets to find in the login page
      final emailFieldLoginPage = find.byKey(const Key("emailFieldLoginPage"));
      final passwordFieldLoginPage =
          find.byKey(const Key("passwordFieldLoginPage"));
      final loginButtonLoginPage =
          find.byKey(const Key("loginButtonLoginPage"));

      expect(emailFieldLoginPage, findsOneWidget);
      expect(passwordFieldLoginPage, findsOneWidget);
      expect(loginButtonLoginPage, findsOneWidget);

      //types someone else's email and password
      await tester.enterText(emailFieldLoginPage, "5@gmail.com"); //email
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(passwordFieldLoginPage, "Aa1234567*"); //password
      await addDelay(5000);
      await tester.pumpAndSettle();

      //clicks login
      await tester.tap(loginButtonLoginPage);
      await addDelay(5000);
      await tester.pumpAndSettle();

      //waits for Firebase
      await addDelay(20000);

      //finds friend's profile and clicks on friend's profile
      final profileDisplay = find.text('SOYEON');

      expect(profileDisplay, findsOneWidget);

      await tester.tap(profileDisplay);
      await addDelay(5000);
      await tester.pumpAndSettle();

      //finds and clicks on To Do List tab of friend
      await addDelay(20000); //waits for Firebase
      final todoTab = find.text("To Do List");

      expect(todoTab, findsOneWidget);

      await tester.tap(todoTab);
      await tester.pumpAndSettle();

      //waits for Firebase
      await addDelay(20000);

      //finds and clicks the checkbox on friend's task
      final taskCheckbox = find.byKey(const Key("taskCheckbox"));

      expect(taskCheckbox, findsOneWidget);

      await tester.tap(taskCheckbox);
      await addDelay(5000);
      await tester.pumpAndSettle();

      //finds error
      final error = find.text("You cannot change the status of this task!");

      expect(error, findsOneWidget);
    });

    //UNHAPPY PATH 2: This test checks that app shows error when invalid password is typed
    testWidgets('Unhappy Path 2', (tester) async {
      app.main();
      await addDelay(5000); //waits for login page to appear
      await tester.pumpAndSettle();

      //finds sign up tab and clicks it
      final signUpTab = find.text("Sign Up");

      expect(signUpTab, findsOneWidget);

      await tester.tap(signUpTab);
      await addDelay(5000);
      await tester.pumpAndSettle();

      //these are the widgets to find in the sign up page
      final firstNameFieldSignupPage =
          find.byKey(const Key("firstNameFieldSignupPage"));
      final lastNameFieldSignupPage =
          find.byKey(const Key("lastNameFieldSignupPage"));
      final userNameFieldSignupPage =
          find.byKey(const Key("userNameFieldSignupPage"));
      final dayFieldSignupPage = find.byKey(const Key("dayFieldSignupPage"));
      final monthFieldSignupPage =
          find.byKey(const Key("monthFieldSignupPage"));
      final yearFieldSignupPage = find.byKey(const Key("yearFieldSignupPage"));
      final locationFieldSignupPage =
          find.byKey(const Key("locationFieldSignupPage"));
      final emailFieldSignupPage =
          find.byKey(const Key("emailFieldSignupPage"));
      final passwordFieldSignupPage =
          find.byKey(const Key("passwordFieldSignupPage"));
      final signUpButton = find.byKey(const Key("signupButtonSignupPage"));

      expect(firstNameFieldSignupPage, findsOneWidget);
      expect(lastNameFieldSignupPage, findsOneWidget);
      expect(userNameFieldSignupPage, findsOneWidget);
      expect(dayFieldSignupPage, findsOneWidget);
      expect(monthFieldSignupPage, findsOneWidget);
      expect(yearFieldSignupPage, findsOneWidget);
      expect(locationFieldSignupPage, findsOneWidget);
      expect(emailFieldSignupPage, findsOneWidget);
      expect(passwordFieldSignupPage, findsOneWidget);
      expect(signUpButton, findsOneWidget);

      //types sign up information
      await tester.enterText(firstNameFieldSignupPage, "Johanna"); //first name
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(lastNameFieldSignupPage, "Eikou"); //last name
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(userNameFieldSignupPage, "SallySanban"); //username
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(dayFieldSignupPage, "16"); //birthday
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(monthFieldSignupPage, "12"); //birth month
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(yearFieldSignupPage, "2001"); //birth year
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(locationFieldSignupPage, "QC"); //location
      await addDelay(5000);
      await tester.pumpAndSettle();
      await tester.enterText(emailFieldSignupPage, "test@gmail.com"); //email
      await addDelay(5000);
      await tester.pumpAndSettle();

      //possible errors to find
      final notEnoughCharsError = find.text("Weak password");
      final needSpecialCharError =
          find.text("Must contain at least one special character");
      final needNumberError = find.text("Must contain at least one number");
      final needLowercaseError =
          find.text("Must contain at least one lowercase letter");
      final needUppercaseError =
          find.text("Must contain at least one uppercase letter");

      //types in various wrong passwords
      await tester.enterText(
          passwordFieldSignupPage, "Aa12345"); //not enough characters
      await addDelay(5000);
      await tester.pumpAndSettle();

      //clicks sign up button to show error and looks for error
      await tester.tap(signUpButton);
      await addDelay(5000);
      await tester.pumpAndSettle();

      expect(notEnoughCharsError, findsOneWidget);

      await tester.enterText(
          passwordFieldSignupPage, "Aa123456"); //no special char
      await addDelay(5000);
      await tester.pumpAndSettle();

      //clicks sign up button to show error and looks for error
      await tester.tap(signUpButton);
      await addDelay(5000);
      await tester.pumpAndSettle();

      expect(needSpecialCharError, findsOneWidget);

      await tester.enterText(passwordFieldSignupPage, "Aaaaaaa*"); //no number
      await addDelay(5000);
      await tester.pumpAndSettle();

      //clicks sign up button to show error and looks for error
      await tester.tap(signUpButton);
      await addDelay(5000);
      await tester.pumpAndSettle();

      expect(needNumberError, findsOneWidget);

      await tester.enterText(
          passwordFieldSignupPage, "AAAA123*"); //no lowercase
      await addDelay(5000);
      await tester.pumpAndSettle();

      //clicks sign up button to show error and looks for error
      await tester.tap(signUpButton);
      await addDelay(5000);
      await tester.pumpAndSettle();

      expect(needLowercaseError, findsOneWidget);

      await tester.enterText(
          passwordFieldSignupPage, "aaaa123*"); //no uppercase
      await addDelay(5000);
      await tester.pumpAndSettle();

      //clicks sign up button to show error and looks for error
      await tester.tap(signUpButton);
      await addDelay(5000);
      await tester.pumpAndSettle();

      expect(needUppercaseError, findsOneWidget);
    });
  });
}

//adds delay
Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}
