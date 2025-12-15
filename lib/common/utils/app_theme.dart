import 'package:flutter/material.dart';

class AppColors {
  static const Color skyBlueLight = Color(0xFF98d2eb);
  static const Color deepTwilight = Color(0xFF0f0a51);
  static const Color vanillaCustard = Color(0xFFd4e09b);
  static const Color tangerineDream = Color(0xFFf19c79);
  static const Color petalFrost = Color(0xFFeccbd9);
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);

  static const Color error = Color(0xFFEF4444);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.deepTwilight,
        onPrimary: Colors.white,
        secondary: AppColors.tangerineDream,
        onSecondary: AppColors.deepTwilight,
        tertiary: AppColors.skyBlueLight,
        onTertiary: AppColors.deepTwilight,

        surface: AppColors.petalFrost,
        onSurface: AppColors.deepTwilight,

        error: Colors.redAccent,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFFDFDFD),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepTwilight,
        foregroundColor: Colors.white,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.tangerineDream,
        foregroundColor: AppColors.deepTwilight,
      ),

      cardTheme: const CardThemeData(color: AppColors.vanillaCustard),
    );
  }
}
