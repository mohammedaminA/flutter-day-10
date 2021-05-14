import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/utilities/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
  static String id = 'login_screen';
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                //Do something with the user input.
                  email = value;
              },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                //Do something with the user input.
                  password = value;
              },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(text: 'Login', color: Colors.lightBlueAccent, onTap: () async {
              // some login functionality
              try {
                print(password);
              final currentUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
              if (currentUser != null) {
                  Navigator.pushNamed(context, ChatScreen.id);
              }}
              catch(e) {
                print(e);
              }
            })
          ],
        ),
      ),
    );
  }
}
