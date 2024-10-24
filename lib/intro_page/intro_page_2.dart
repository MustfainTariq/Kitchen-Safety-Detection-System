import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1), // Responsive padding
          child: Center(
            child: Column(
              children: [
                // Animation with a fallback placeholder
                SizedBox(height: 20), // Provides spacing between elements
                Text(
                  'RAQEEB will keep watch and make sure all the employees adhere to the proper PPE.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.045, // Responsive font size
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
