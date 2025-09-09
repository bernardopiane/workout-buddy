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
  scaffoldBackgroundColor: const Color(0xFFF8F9FA),
  primaryColor: const Color(0xFF5C6BC0),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF5C6BC0),
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
    color: Color(0xFF5C6BC0),
  ),

  // ElevatedButton theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3497F4),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),

  // OutlinedButton theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xFF5C6BC0)),
      foregroundColor: const Color(0xFF5C6BC0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),

  // Floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF5C6BC0),
    foregroundColor: Colors.white,
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: const BorderSide(color: Color(0xFF5C6BC0), width: 2),
    ),
  ),
);

final ThemeData darkTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor: const Color(0xFF111518),
  primaryColor: const Color(0xFF7C4DFF),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
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
    color: const Color(0xFF1B2127),
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
    color: Color(0xFF7C4DFF),
  ),

  // ElevatedButton theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3497F4),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),

  // OutlinedButton theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xFF7C4DFF)),
      foregroundColor: const Color(0xFF7C4DFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  ),

  // Floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF7C4DFF),
    foregroundColor: Colors.white,
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: const BorderSide(color: Color(0xFF7C4DFF), width: 2),
    ),
  ),
);

final ButtonStyle secondaryElevatedButtonStyleLight = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFFE8EAF6),
  foregroundColor: const Color(0xFF1A1A1A),
  textStyle: const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.1,
  ),
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  minimumSize: const Size(64, 48),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);

final ButtonStyle secondaryElevatedButtonStyleDark = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF2A2A2C),
  foregroundColor: const Color(0xFFF2F2F7),
  textStyle: const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.1,
  ),
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  minimumSize: const Size(64, 48),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);