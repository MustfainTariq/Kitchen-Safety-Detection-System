// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CameraDetails extends StatefulWidget {
  final int cameraId;
  final String cameraIp;
  final String location;
  final String frameRate;
  final String resolution;
  final String time;

  const CameraDetails({
    super.key,
    required this.cameraId,
    required this.cameraIp,
    required this.location,
    required this.frameRate,
    required this.resolution,
    required this.time,
  });

  @override
  State<CameraDetails> createState() => _CameraDetailsState();
}

class _CameraDetailsState extends State<CameraDetails> {
  //current user
  final currentUser = FirebaseAuth.instance.currentUser;

  //delete camera pop up message
  Future deleteCamera() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //title
            Text(
              'Delete Camera.',
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
          'Are you sure you want to delete\nCamera IP: ${widget.cameraIp}\nCamera ID: ${widget.cameraId}\n\nAll its data will be lost permanently.\nThis action CANNOT be undone.',
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
              //close the dialog
              Navigator.pop(context);

              //delete the camera
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
                    .doc(doc.reference.id)
                    .delete();

                break;
              }
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //buttons
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //time added
                  Text(
                    '${widget.time}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),

                  //edit button
                  // Container(
                  //   width: 90,
                  //   height: 40,
                  //   decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: Theme.of(context).colorScheme.secondary,
                  //       ),
                  //       color: Theme.of(context).colorScheme.onPrimary,
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: Center(
                  //     child: Text(
                  //       'Edit',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 16,
                  //         color: Theme.of(context).colorScheme.secondary,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  //delete
                  GestureDetector(
                    onTap: () => deleteCamera(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffef3e36),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Color(0xffef3e36),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  //detail
                  Row(
                    children: [
                      Text(
                        'Camera ID:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 25),
                      Text(
                        '${widget.cameraId}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  //detail
                  Row(
                    children: [
                      Text(
                        'Camera IP:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 25),
                      Text(
                        '${widget.cameraIp}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  //detail
                  Row(
                    children: [
                      Text(
                        'Location:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 40),
                      Text(
                        '${widget.location}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  //detail
                  Row(
                    children: [
                      Text(
                        'Frame Rate:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        '${widget.frameRate}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  //detail
                  Row(
                    children: [
                      Text(
                        'Resolution:',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 25),
                      Text(
                        '${widget.resolution}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
