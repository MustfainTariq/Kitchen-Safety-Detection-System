// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '/pages/alert.dart';
import '/pages/camera.dart';
import '/pages/employee.dart';
import '/pages/report.dart';

class HomePage extends StatefulWidget {
  //method to give to the gesture detector for 'Account page'
  final VoidCallback showAccountPage;
  const HomePage({super.key, required this.showAccountPage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ReportPage(),
    EmployeePage(),
    CameraPage(),
    AlertPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,

        //logo
        title: Image.asset(
          'assets/logo2.png',
          width: 60,
        ),

        //account
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: widget.showAccountPage,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Account',
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
        ],
      ),

      //bottom navbar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ))),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
            unselectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
            showUnselectedLabels: false,
            iconSize: 30,
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            onTap: _navigateBottomBar,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Report',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Employee',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.remove_red_eye),
                label: 'Camera',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Alert',
              ),
            ],
          ),
        ),
      ),

      body: _pages[_selectedIndex],
    );
  }
}
