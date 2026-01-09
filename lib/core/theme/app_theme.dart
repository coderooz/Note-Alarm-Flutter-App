import 'package:flutter/material.dart';

/// Centralized theme for easy scaling & branding
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
