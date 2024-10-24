import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Register/auth_page.dart';
import 'pages/home_account_toggle.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const AuthPage2();
          } else {
            return const AuthPage(); //checks if we should show the Log in page or the Register page
          }
        },
      ),
    );
  }
}
