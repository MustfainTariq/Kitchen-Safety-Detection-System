import 'package:flutter/material.dart';
import '/pages/account_page.dart';
import '/pages/bottom_top_bars.dart';

class AuthPage2 extends StatefulWidget {
  const AuthPage2({super.key});

  @override
  State<AuthPage2> createState() => _AuthPage2State();
}

class _AuthPage2State extends State<AuthPage2> {
  //initially show the Home page
  bool showHomePage = true;

  //allows us to toggle between Home and Account pages
  void toggleScreens() {
    setState(() {
      showHomePage = !showHomePage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showHomePage) {
      return HomePage(showAccountPage: toggleScreens);
    } else {
      return AccountPage(showHomePage: toggleScreens);
    }
  }
}
