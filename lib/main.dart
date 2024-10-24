// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reda/pages/local_notifications.dart';

import 'intro_page/onboarding_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';
import 'Theme/theme_provider.dart';

void main() async {
  //Gives access to the native code
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),

  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: MainPage(),
      home: OnBoardingScreen(),
      routes: {
        'MainPage': (context) => MainPage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

