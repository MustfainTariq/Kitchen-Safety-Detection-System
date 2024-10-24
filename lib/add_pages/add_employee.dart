// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final currentUser = FirebaseAuth.instance.currentUser;
  //text controllers
  final _employeeIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _organizationController = TextEditingController();

  //dispose to help the memory management
  @override
  void dispose() {
    _employeeIdController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _organizationController.dispose();
    super.dispose();
  }

  //add method
  void add() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .collection('employees')
        .add({
      'Employee ID': int.parse(_employeeIdController.text.trim()),
      'First name': _firstNameController.text.trim(),
      'Last name': _lastNameController.text.trim(),
      'Phone number': int.parse(_phoneNumberController.text.trim()),
      'Email': _emailController.text.trim(),
      'Organization': _organizationController.text.trim(),
      'Time Added': Timestamp.now(),
    });

    Navigator.pop(context);
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundImage: _imageFile == null
                ? AssetImage("assets/logo_b&w_light.png")
                : FileImage(File(_imageFile!.path)) as ImageProvider,
          ),
          Positioned(
              bottom: 20,
              right: 30,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 28,
                ),
              ))
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      color: Theme.of(context).colorScheme.background,
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  icon: Icon(
                    Icons.camera,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Text(
                    "Camera",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  icon: Icon(
                    Icons.image,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Text(
                    "Gallery",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path) as PickedFile?;
      } else {
        print('No image selected.');
      }
    });
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
          'Add Employee',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
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

      //body
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),

                //image
                //imageProfile(),

                SizedBox(height: 30),

                //employee ID
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _employeeIdController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Employee ID',
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

                //phone number
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Phone Number',
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

                //Add button
                SizedBox(
                  width: 300,
                  height: 50,
                  child: GestureDetector(
                    onTap: add,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 25,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
