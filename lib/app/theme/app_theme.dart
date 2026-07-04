import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vision_vault_mobile/app/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryNavy,
        secondary: AppColors.accentTeal,
        surface: AppColors.surfaceLight,
        error: AppColors.errorRed,
        onSecondary: Colors.white,
        onSurface: AppColors.textDark,
      ),
      scaffoldBackgroundColor: AppColors.surfaceLight,
      textTheme:
          GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        bodyLarge: GoogleFonts.inter(color: AppColors.textDark),
        bodyMedium: GoogleFonts.inter(color: AppColors.textDark),
        displayLarge: GoogleFonts.inter(
            color: AppColors.textDark, fontWeight: FontWeight.bold,),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentCyan,
        secondary: AppColors.accentTeal,
        surface: AppColors.surfaceDark,
        error: AppColors.errorRed,
        onPrimary: AppColors.primaryObsidian,
        onSecondary: AppColors.primaryObsidian,
        onSurface: AppColors.textLight,
      ),
      scaffoldBackgroundColor: AppColors.primaryObsidian,
      textTheme:
          GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyLarge: GoogleFonts.inter(color: AppColors.textLight),
        bodyMedium: GoogleFonts.inter(color: AppColors.textLight),
        displayLarge: GoogleFonts.inter(
            color: AppColors.textLight, fontWeight: FontWeight.bold,),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentCyan,
          foregroundColor: AppColors.primaryObsidian,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }
}
