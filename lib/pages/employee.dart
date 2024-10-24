// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/add_pages/add_employee.dart';
import '/add_pages/employee_details.dart';
import '/time_stamp.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  //get current user
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: Border(
            bottom: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        )),

        //add button
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddEmployee()));
              },
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 25,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      //body
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 50),
              // //background trademark
              // Icon(
              //   Icons.people_outline,
              //   size: 150,
              //   color: Color(0x6642aec0),
              // ),
              // Text(
              //   'No employees.',
              //   style: TextStyle(
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0x6642aec0),
              //   ),
              // ),
              // SizedBox(height: 15),
              // Text(
              //   'Add an employee by pressing\nthe (+ Add) button.',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     height: 1.5,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              // ),

              //added employees
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.email)
                    .collection('employees')
                    .orderBy('Time Added', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      //get the employee
                      final employeeData = doc.data() as Map<String, dynamic>;

                      //return the employee
                      return EmployeeDetails(
                        employeeId: employeeData['Employee ID'],
                        firstName: employeeData['First name'],
                        lastName: employeeData['Last name'],
                        phoneNumber: employeeData['Phone number'],
                        email: employeeData['Email'],
                        organization: employeeData['Organization'],
                        time: formatDate(employeeData['Time Added']),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
