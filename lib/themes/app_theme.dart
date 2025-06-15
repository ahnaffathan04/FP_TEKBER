// lib/themes/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF0A0E1A), // Darker blue background
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
      // Apply Poppins to AppBar title if needed, or let textTheme handle it
      // titleTextStyle: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      // Set Poppins as the default font family for all text styles
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
      titleMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      // You might want to define other text styles as well
      displayLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      displayMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      displaySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      headlineMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      headlineSmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      titleSmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      labelLarge: TextStyle(color: Colors.black, fontFamily: 'Poppins'), // For buttons
      bodySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      labelSmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF00D4FF),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D4FF),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold), // Apply to button text
      ),
    ),
  );
}