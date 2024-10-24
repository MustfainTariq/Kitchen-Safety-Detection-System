import 'package:flutter/material.dart';
import '/Register/login_page.dart';
import '/Register/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initially show the Log in page
  bool showLoginPage = true;

  //allows us to toggle between Log in and Sign up pages
  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScreens);
    } else {
      return SignupPage(showLoginPage: toggleScreens);
    }
  }
}
