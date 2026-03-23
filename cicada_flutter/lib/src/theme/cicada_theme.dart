import 'package:flutter/material.dart';

class CicadaTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF2E7D32),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
    ),
  );

  // Status colors for forecast badges.
  static const Color statusComplete = Color(0xFF4CAF50);
  static const Color statusDue = Color(0xFFFFA726);
  static const Color statusOverdue = Color(0xFFEF5350);
  static const Color statusImmune = Color(0xFF42A5F5);
  static const Color statusContraindicated = Color(0xFF78909C);
  static const Color statusAgedOut = Color(0xFF9E9E9E);
  static const Color statusNotRecommended = Color(0xFFBDBDBD);
}
