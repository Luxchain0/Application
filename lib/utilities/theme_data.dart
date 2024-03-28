import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    primaryColor: Colors.white,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shadowColor: Colors.black12,

    ),
    scaffoldBackgroundColor: Colors.white,
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      shadowColor: Colors.black26,
      iconTheme: MaterialStatePropertyAll(IconThemeData(
        size: 40
      ))
      )
  );
}
