import 'package:flutter/material.dart';

final double borderRadius = 8.0;

final double fontLarge = 24.0;
final double fontMedium = 18.0;
final double fontSmall = 14.0;

final TextStyle titleTextStyle = TextStyle(
  fontSize: fontLarge,
  fontWeight: FontWeight.bold,
);

final TextStyle bodyTextStyle = TextStyle(
  fontSize: fontMedium,
);

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
  cardTheme: CardThemeData(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
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

  // ElevatedButton theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff3497f4),
      foregroundColor: Colors.white,
      textStyle: TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),

  // OutlinedButton theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xff5C6BC0)),
      foregroundColor: const Color(0xff5C6BC0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),
  // Floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff5C6BC0),
    foregroundColor: Colors.white,
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
  ),
);

final ThemeData darkTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor: const Color(0xff111518),
  // Default background color for dark theme
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
  cardTheme: CardThemeData(
    elevation: 2,
    color: Color(0xff1B2127),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
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

  // ElevatedButton theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff3497f4),
      foregroundColor: Colors.white,
      textStyle: TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),

  // OutlinedButton theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xff7C4DFF)),
      foregroundColor: const Color(0xff7C4DFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),
  // Floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    // backgroundColor: Color(0xff7C4DFF),
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xff1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
  ),
);

final ButtonStyle secondaryElevatedButtonStyleLight = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xfff0f2f5),
  foregroundColor: const Color(0xff111518),
  textStyle: TextStyle(fontWeight: FontWeight.bold),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);

final ButtonStyle secondaryElevatedButtonStyleDark = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff283139),
  foregroundColor: const Color(0xffffffff),
  textStyle: TextStyle(fontWeight: FontWeight.bold),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);