import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF4E47C5),  // Violet principal
    hintColor: Color(0xFFFE5F55),   // Couleur accent rouge
    scaffoldBackgroundColor: Color(0xFFF6F6F6),  // Fond de l'application

    // Définir les boutons avec un style cohérent
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Color(0xFF4E47C5),  // Couleur du texte
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    ),

    // Style des champs de texte
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Color(0xFF4E47C5)),
      ),
      labelStyle: TextStyle(color: Colors.black),
    ),

    // Text Styles (général)
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.grey[800]),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[600]),
    ),
  );
}
