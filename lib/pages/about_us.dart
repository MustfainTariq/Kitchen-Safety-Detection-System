// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //back arrow
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),

                      //logo
                      Image(
                        image: AssetImage('assets/logo_text2.png'),
                        height: 200,
                      ),

                      SizedBox(width: 20),
                    ],
                  ),

                  SizedBox(height: 50),

                  //title
                  Text(
                    'About Raqeeb',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  SizedBox(height: 20),

                  //text
                  Text(
                    'RAQEEB is an aaplication used to monitor and ensure the cleanliness of kitchen staff in kitchens. This application provides an effective solution for maintaining cleanliness standards and food safety, ensuring the delivery of safe food to customers.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      height: 1.5,
                      decoration: TextDecoration.none,
                    ),
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
