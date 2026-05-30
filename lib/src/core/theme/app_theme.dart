import 'package:flutter/material.dart';

abstract final class AppColors {
  static const voidBlack = Color(0xFF050711);
  static const deepSpace = Color(0xFF09111F);
  static const neonCyan = Color(0xFF4DF5FF);
  static const neonBlue = Color(0xFF41A7FF);
  static const neonViolet = Color(0xFF9B5CFF);
  static const plasmaPink = Color(0xFFFF4FD8);
  static const starWhite = Color(0xFFEAF7FF);
  static const mutedText = Color(0xFF9FB4C8);
  static const glass = Color(0x3314273D);
}

abstract final class AppTheme {
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.neonBlue,
      brightness: Brightness.dark,
      surface: AppColors.deepSpace,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.voidBlack,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 64,
          height: 0.92,
          fontWeight: FontWeight.w900,
          letterSpacing: -3,
          color: AppColors.starWhite,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          height: 1.05,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: AppColors.starWhite,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.starWhite,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.55,
          color: AppColors.mutedText,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: AppColors.mutedText,
        ),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: AppColors.neonBlue.withValues(alpha: 0.32)),
        backgroundColor: AppColors.neonBlue.withValues(alpha: 0.08),
        labelStyle: const TextStyle(color: AppColors.starWhite),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.neonBlue,
          foregroundColor: AppColors.voidBlack,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.starWhite,
          side: BorderSide(color: AppColors.neonCyan.withValues(alpha: 0.42)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
