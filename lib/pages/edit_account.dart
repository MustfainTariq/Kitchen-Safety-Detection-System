// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/text_box.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  //current user
  final currentUser = FirebaseAuth.instance.currentUser;

  //all users
  final userCollection = FirebaseFirestore.instance.collection('users');

  //edit button method
  Future<void> editField(String field, TextInputType textInputType) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //title
            Text(
              'Edit ' + field,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
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

        //text field
        content: TextField(
          autofocus: true,
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),

        //action buttons
        actions: [
          //save button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(newValue),
            child: Container(
              width: 90,
              height: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    //update in firestore
    if (newValue.trim().length > 0) {
      await userCollection.doc(currentUser!.email).update({field: newValue});
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
        title: Text(
          'Edit Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
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
                  SizedBox(height: 20),

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
                            //first name
                            MyTextBox(
                              text: userData['First name'],
                              sectionName: 'First name',
                              onPressed: () =>
                                  editField('First name', TextInputType.name),
                            ),

                            SizedBox(height: 20),

                            //last name
                            MyTextBox(
                              text: userData['Last name'],
                              sectionName: 'Last name',
                              onPressed: () =>
                                  editField('Last name', TextInputType.name),
                            ),

                            SizedBox(height: 20),

                            //age
                            MyTextBox(
                              text: userData['Age'].toString(),
                              sectionName: 'Age',
                              onPressed: () =>
                                  editField('Age', TextInputType.number),
                            ),

                            SizedBox(height: 20),

                            //email
                            MyTextBox(
                              text: userData['Email'],
                              sectionName: 'Email',
                              onPressed: () => editField(
                                  'Email', TextInputType.emailAddress),
                            ),

                            SizedBox(height: 20),

                            //organization
                            MyTextBox(
                              text: userData['Organization'],
                              sectionName: 'Organization',
                              onPressed: () =>
                                  editField('Organization', TextInputType.text),
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

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
