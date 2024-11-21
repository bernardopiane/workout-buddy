import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData.light(
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor:
      const Color(0xffF8F9FA), // Default background color for light theme
  primaryColor: const Color(0xff5C6BC0),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff5C6BC0),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Card theme
  cardTheme: const CardTheme(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff5C6BC0),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  ),

  // Text theme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
    headlineSmall: TextStyle(color: Colors.black87),
    headlineMedium: TextStyle(color: Colors.black87),
    headlineLarge: TextStyle(color: Colors.black87),
  ),

  // Icon theme
  iconTheme: const IconThemeData(
    color: Color(0xff5C6BC0),
  ),

  // Floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff5C6BC0),
    foregroundColor: Colors.white,
  ),

  // Input decoration theme
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  ),
);

final ThemeData darkTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor:
      const Color(0xff121212), // Default background color for dark theme
  primaryColor: const Color(0xff7C4DFF),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff1E1E1E),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Card theme
  cardTheme: const CardTheme(
    elevation: 2,
    color: Color(0xff1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff7C4DFF),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  ),

  // Text theme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    headlineSmall: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
  ),

  // Icon theme
  iconTheme: const IconThemeData(
    color: Color(0xff7C4DFF),
  ),

  // Floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    // backgroundColor: Color(0xff7C4DFF),
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
  ),

  // Input decoration theme
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xff1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  ),
);
