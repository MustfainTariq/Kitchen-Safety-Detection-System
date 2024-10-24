// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/pages/edit_account.dart';

class AccountPage extends StatefulWidget {
  //method to give to the gesture detector for 'home page'
  final VoidCallback showHomePage;
  AccountPage({super.key, required this.showHomePage});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  //current user
  final currentUser = FirebaseAuth.instance.currentUser;

  //all users
  final userCollection = FirebaseFirestore.instance.collection('users');

  //delete account pop up message
  Future deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //title
            Text(
              'Delete Account.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffef3e36),
              ),
            ),

            //close icon
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
        content: Text(
          'Are you sure you want to delete your account?\n\nAll your data will be lost permanently.\nThis action CANNOT be undone.',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

        //action buttons
        actions: [
          //delete button
          GestureDetector(
            onTap: () async {
              //delete the employees
              final employeeDocs = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.email)
                  .collection('employees')
                  .get();

              for (var doc in employeeDocs.docs) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.email)
                    .collection('employees')
                    .doc(doc.id)
                    .delete();
              }

              //delete the cameras
              final cameraDocs = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.email)
                  .collection('cameras')
                  .get();

              for (var doc in cameraDocs.docs) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.email)
                    .collection('cameras')
                    .doc(doc.id)
                    .delete();
              }

              //delete user from Firestore
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.email)
                  .delete()
                  .then((value) => print('Account Deleted'))
                  .catchError(
                      (error) => print('Failed to delete account: $error'));

              //delete user from Auth
              FirebaseAuth.instance.currentUser!.delete().catchError(
                  (error) => print('Failed to delete auth acount: $error'));

              //close the dialog
              Navigator.pop(context);

              //sign out
              FirebaseAuth.instance.signOut();
            },
            child: Container(
              width: 90,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffef3e36),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xffef3e36),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

        leading: GestureDetector(
          onTap: widget.showHomePage,
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),

        //title
        title: Text(
          'Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),

        //account
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditAccountPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.edit,
                    size: 25,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //my text box
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser!.email!)
                        .snapshots(),
                    builder: (context, snapshot) {
                      //get user data
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;

                        return Column(
                          children: [
                            Row(
                              children: [
                                //user image
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage("assets/logo.png"),
                                ),

                                SizedBox(width: 20),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //first + last name
                                    Text(
                                      userData['First name'] +
                                          ' ' +
                                          userData['Last name'],
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    //email
                                    Text(
                                      userData['Email'],
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            SizedBox(height: 20),

                            //line divider
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1,
                              ))),
                              width: 600,
                            ),

                            SizedBox(height: 35),

                            //age
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    userData['Age'].toString(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30),

                            //organization
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_sharp,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    userData['Organization'],
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error ${snapshot.error}'),
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),

                  SizedBox(height: 30),

                  //light & dark mode
                  GestureDetector(
                    onTap: () {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Icon(
                            Icons.brightness_4,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Dark / Light Mode',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 35),

                  //sign out
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                    height: 50,
                    width: 350,
                    child: MaterialButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text(
                        'Sign out',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  //delete account
                  Container(
                    decoration: BoxDecoration(
                        //color: Color(0xffef3e36),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xffef3e36),
                          width: 2,
                        )),
                    height: 50,
                    width: 350,
                    child: MaterialButton(
                      onPressed: () {
                        deleteAccount();
                      },
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Color(0xffef3e36),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
