import 'package:flutter/material.dart';

final ThemeData yellowBlackTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  
  // Core Color Scheme
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFFD600), // Vibrant Accent Yellow
    onPrimary: Colors.black, // Text/icons on yellow elements
    primaryContainer: Color(0xFF332B00), // Dark yellow container backings
    onPrimaryContainer: Color(0xFFFFD600),
    
    surface: Color(0xFF121212), // Main screen background
    onSurface: Colors.white, // Primary text color
    
    surfaceContainerHighest: Color(0xFF1E1E1E), // Cards & input fields background
    onSurfaceVariant: Color(0xFFE0E0E0), // Secondary text color
    
    outline: Color(0xFF757575), // Borders and subtle icons
  ),
  
  // Scaffold background color
  scaffoldBackgroundColor: const Color(0xFF121212),

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Color(0xFFFFD600),
    elevation: 0,
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    selectedItemColor: Color(0xFFFFD600),
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),

  // Input / TextField Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    hintStyle: const TextStyle(color: Colors.grey),
    prefixIconColor: const Color(0xFFFFD600),
    suffixIconColor: const Color(0xFFFFD600),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: Color(0xFFFFD600), width: 1.5),
    ),
  ),

  // Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFD600),
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: const Color(0xFFFFD600),
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  
  // Circular Progress Indicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFFFD600),
  ),
);