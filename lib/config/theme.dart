import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF00C2A8);
  static const Color primaryDark = Color(0xFF00A090);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF999999);
  static const Color salary = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF5B8DEF);
  static const Color warning = Color(0xFFFFB74D);

  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        useMaterial3: true,
      );
}
