import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0f0a51);
  static const Color primaryButton = Color.fromRGBO(15, 10, 81, 1);
  static const Color secondary = Colors.purple;
  static const Color orange = Color(0xFFf19c79);
  static const Color accent = Color(0xFF98d2eb);
  static const Color accentStrong = Color(0xFF448AFF);
  static const Color background = Color(0xFFF1F5F9);
  static const Color surfaceLight = Color(0xFFeccbd9);
  static const Color surfaceCard = Color(0xFFd4e09b);
  static const Color textPrimary = Color(0xFF0f0a51);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textOnDark = Color(0xFFF1F5F9);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.primary,
        tertiary: AppColors.accent,
        onTertiary: AppColors.primary,

        surface: AppColors.surfaceLight,
        onSurface: AppColors.primary,

        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.accent,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
