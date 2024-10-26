import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[200]!.withOpacity(0.7),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.2),
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.blueAccent.shade100.withOpacity(0.8),
      secondary: Colors.blueGrey.withOpacity(0.6),
      surface: Colors.white.withOpacity(0.2),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.black54,
    ),
    cardTheme: CardTheme(
      color: Colors.white.withOpacity(0.3),
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dialogBackgroundColor: Colors.white.withOpacity(0.4),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black54),
      titleMedium: TextStyle(
          color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.black87.withOpacity(0.6)),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black87.withOpacity(0.6),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black.withOpacity(0.3),
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blueAccent.shade700.withOpacity(0.8),
      secondary: Colors.blueGrey.withOpacity(0.7),
      surface: Colors.black.withOpacity(0.3),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white54,
    ),
    cardTheme: CardTheme(
      color: Colors.black.withOpacity(0.4),
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dialogBackgroundColor: Colors.black.withOpacity(0.4),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white70),
      titleMedium: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.white70.withOpacity(0.6)),
    ),
  );
}
