import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    scaffoldBackgroundColor: Colors.grey.shade50,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
