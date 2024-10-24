// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //text controller
  final _emailController = TextEditingController();

  //dispose for memory
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  //reset password method
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Image.asset(
          'assets/logo2.png',
          height: 70,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,

      //body
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),

              //forgot password?
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),

              SizedBox(height: 20),

              //sub text
              SizedBox(
                width: 300,
                child: Text(
                  'Enter your email below to receive a reset link for your password.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),

              SizedBox(height: 20),

              //email
              SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
                              width: 2))),
                ),
              ),

              SizedBox(height: 20),

              //reset password button
              SizedBox(
                width: 300,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  child: MaterialButton(
                    onPressed: resetPassword,
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
