// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCamera extends StatefulWidget {
  const AddCamera({super.key});

  @override
  State<AddCamera> createState() => _AddCameraState();
}

class _AddCameraState extends State<AddCamera> {
  final currentUser = FirebaseAuth.instance.currentUser;
  //text controllers
  final _cameraIdController = TextEditingController();
  final _cameraIpController = TextEditingController();
  final _locationController = TextEditingController();
  final _frameRateController = TextEditingController();
  final _resolutionController = TextEditingController();

  //dispose to help the memory management
  @override
  void dispose() {
    _cameraIdController.dispose();
    _cameraIpController.dispose();
    _locationController.dispose();
    _frameRateController.dispose();
    _resolutionController.dispose();
    super.dispose();
  }

  //add method
  Future add() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .collection('cameras')
        .add({
      'Camera ID': int.parse(_cameraIdController.text.trim()),
      'Camera IP': _cameraIpController.text.trim(),
      'Location': _locationController.text.trim(),
      'Frame Rate': _frameRateController.text.trim(),
      'Resolution': _resolutionController.text.trim(),
      'Time Added': Timestamp.now(),
    });

    Navigator.pop(context);
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
          'Add Camera',
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
                SizedBox(height: 50),

                //Camera ID
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _cameraIdController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Camera ID',
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

                //Camera IP
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _cameraIpController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Camera IP',
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

                //Location
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Location',
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

                //frame rate
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _frameRateController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Frame Rate',
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

                //resolution
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _resolutionController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        labelText: 'Resolution',
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
