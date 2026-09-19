import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextTheme light = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 24, // تم التصحيح من 324 إلى 24
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  );

  static const TextTheme dark = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 24, // تم التصحيح من 324 إلى 24
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  );
}