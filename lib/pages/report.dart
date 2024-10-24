// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  //dropdown callback
  String? _dropdownValue;

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //dropdown button / filter
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: 'Filter the reports.',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Daily',
                      child: Text(
                        'Daily',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Weekly',
                      child: Text(
                        'Weekly',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Monthly',
                      child: Text(
                        'Monthly',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Annual',
                      child: Text(
                        'Annual',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                  value: _dropdownValue,
                  onChanged: dropdownCallback,
                  iconSize: 40,
                  iconEnabledColor: Theme.of(context).colorScheme.primary,
                  isExpanded: true,
                ),
              ),

              SizedBox(height: 50),
              //background trademark
              Icon(
                Icons.analytics_outlined,
                size: 150,
                color: Color(0x6642aec0),
              ),
              Text(
                'Nothing to report.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0x6642aec0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
