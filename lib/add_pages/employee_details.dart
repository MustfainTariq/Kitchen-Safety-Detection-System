// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/add_pages/edit_employee.dart';

class EmployeeDetails extends StatefulWidget {
  final int employeeId;
  final String firstName;
  final String lastName;
  final int phoneNumber;
  final String email;
  final String organization;
  final String time;

  const EmployeeDetails({
    super.key,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.organization,
    required this.time,
  });

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  //current user
  final currentUser = FirebaseAuth.instance.currentUser;

  //delete employee pop up message
  Future deleteEmployee() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //title
            Text(
              'Delete Employee.',
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
          'Are you sure you want to delete\nEmployee: ${widget.firstName} ${widget.lastName}\nID: ${widget.employeeId}\n\nAll their data will be lost permanently.\nThis action CANNOT be undone.',
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

                  //organization
                  Text(
                    '${widget.organization}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),

                  //edit button
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => EditEmployeePage()));
                  //   },
                  //   child: Container(
                  //     width: 90,
                  //     height: 40,
                  //     decoration: BoxDecoration(
                  //         border: Border.all(
                  //           color: Theme.of(context).colorScheme.secondary,
                  //         ),
                  //         color: Theme.of(context).colorScheme.onPrimary,
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Center(
                  //       child: Text(
                  //         'Edit',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 16,
                  //           color: Theme.of(context).colorScheme.secondary,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  //delete
                  GestureDetector(
                    onTap: () => deleteEmployee(),
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
              child: Row(
                children: [
                  //employee image
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.background,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/logo.png"),
                    ),
                  ),

                  SizedBox(width: 20),

                  //employee details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.firstName} ${widget.lastName}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'ID: ${widget.employeeId}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: Theme.of(context).colorScheme.background,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${widget.email}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            color: Theme.of(context).colorScheme.background,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${widget.phoneNumber}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
