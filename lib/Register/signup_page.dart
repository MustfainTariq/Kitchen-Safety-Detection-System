// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/services/auth_services.dart';

class SignupPage extends StatefulWidget {
  //method to give to the gesture detector for 'Log in page'
  final VoidCallback showLoginPage;

  //require the VoidCallback bellow
  const SignupPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  //text controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _organizationController = TextEditingController();

  //dispose to help the memory management
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _organizationController.dispose();
    super.dispose();
  }

  //sign up method
  // Updated signUp method with error handling and field validation
  Future signUp() async {
    // Check if any field is empty
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
     _passwordController.text.trim() != _confirmPasswordController.text.trim()) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Passwords do not match.')),
    );
    return;
    }


    // Attempt to sign up the user
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.email).set({
        'Username': _emailController.text.split('@')[0],
        'First name': _firstNameController.text.trim(),
        'Last name': _lastNameController.text.trim(),
        'Age': int.tryParse(_ageController.text.trim()) ?? 0,
        'Email': _emailController.text.trim(),
        'Organization': _organizationController.text.trim(),
      });

      // Navigate to the home screen after successful signup
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      var message = 'An error occurred, please check your credentials and try again';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign up.')));
    }
  }


  // Future addUserDetails(String username, String fName, String lName, int age,
  //     String email, String organization, UserCredential userCredential) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'username': username,
  //     'first name': fName,
  //     'last name': lName,
  //     'age': age,
  //     'email': email,
  //     'organization': organization,
  //   });
  // }

  //confirm the password
  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
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
          onTap: widget.showLoginPage,
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,

      //body
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),

                Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),

                SizedBox(height: 15),

                //first name
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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

                SizedBox(height: 15),

                //last name
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Last Name',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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

                SizedBox(height: 15),

                //age
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Age',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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

                SizedBox(height: 15),

                //email
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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

                SizedBox(height: 15),

                //password
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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

                SizedBox(height: 15),

                //confirm password
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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

                SizedBox(height: 15),

                //organization
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _organizationController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Organization',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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

                SizedBox(height: 40),

                //Sign up button
                SizedBox(
                  width: 300,
                  height: 50,
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // // --- or ---
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       width: 120,
                //       decoration: BoxDecoration(
                //           border: Border(
                //               bottom: BorderSide(
                //         color: Theme.of(context).colorScheme.secondary,
                //         width: 2,
                //       ))),
                //     ),
                //     SizedBox(width: 15),
                //     Text(
                //       'Or',
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: Theme.of(context).colorScheme.secondary,
                //       ),
                //     ),
                //     SizedBox(width: 15),
                //     Container(
                //       width: 120,
                //       decoration: BoxDecoration(
                //           border: Border(
                //               bottom: BorderSide(
                //         color: Theme.of(context).colorScheme.secondary,
                //         width: 2,
                //       ))),
                //     ),
                //   ],
                // ),

                // SizedBox(height: 15),

                // //continue with google button
                // SizedBox(
                //   width: 300,
                //   height: 50,
                //   child: GestureDetector(
                //     onTap: () => AuthService().signInWithGoogle(),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         //color: Theme.of(context).colorScheme.onPrimary,
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(
                //           color: Theme.of(context).colorScheme.secondary,
                //         ),
                //       ),
                //       child: Center(
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(
                //               'Continue with',
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //                 color: Theme.of(context).colorScheme.secondary,
                //               ),
                //             ),
                //             SizedBox(width: 10),
                //             Image.asset(
                //               'assets/google_logo.png',
                //               width: 30,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
