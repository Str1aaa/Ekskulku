import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF3D5AF1);
  static const Color primaryColorLight = Color(0xFF5E76F3);
  static const Color primaryColorDark = Color(0xFF2A3FA0);
  
  // Secondary colors
  static const Color secondaryColor = Color(0xFFF0BC2E);
  static const Color secondaryColorLight = Color(0xFFF2CB5E);
  static const Color secondaryColorDark = Color(0xFFC29200);
  
  // Background colors
  static const Color scaffoldBackgroundColor = Color(0xFFF9F9FB);
  static const Color cardColor = Colors.white;
  
  // Text colors
  static const Color textColorPrimary = Color(0xFF212121);
  static const Color textColorSecondary = Color(0xFF757575);
  static const Color textColorHint = Color(0xFFBDBDBD);
  
  // Error colors
  static const Color errorColor = Color(0xFFE53935);
  
  // Success colors  
  static const Color successColor = Color(0xFF43A047);
  
  // Input decoration theme
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: errorColor),
    ),
    errorStyle: const TextStyle(color: errorColor),
  );
  
  // Button themes
  static ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      ),
    ),
  );
  
  static OutlinedButtonThemeData outlinedButtonThemeData = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor),
      minimumSize: const Size(double.infinity, 56.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      ),
    ),
  );
  
  // Text theme
  static TextTheme textTheme = const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: textColorPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: textColorPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: textColorPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: textColorPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: textColorPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: textColorSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: primaryColor,
    ),
  );
  
  // Theme data
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    cardColor: cardColor,
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonThemeData,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
} 