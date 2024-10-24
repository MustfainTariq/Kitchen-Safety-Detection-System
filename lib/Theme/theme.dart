// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xfff1efdc),
  colorScheme: ColorScheme.light(
    background: Color(0xfff1efdc),
    primary: Color(0xff42aec0),
    onPrimary: Color(0xfffcd603),
    secondary: Color(0xff073c58),
    onBackground: Color(0xff073c58),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xff073c58),
  colorScheme: ColorScheme.dark(
    background: Color(0xff073c58),
    primary: Color(0xff42aec0),
    onPrimary: Color(0xff42aec0),
    secondary: Color(0xfff1efdc),
    onBackground: Color(0xff073c58),
  ),
);

ThemeData textTheme = ThemeData(textTheme: TextTheme());
