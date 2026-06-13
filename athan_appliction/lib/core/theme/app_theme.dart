import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryColor,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondaryColor,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface: AppColors.surfaceColor,
        onSurface: AppColors.onSurface,
        error: AppColors.errorColor,
        onError: AppColors.onError,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.surfaceColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: AppColors.onPrimaryDark,
        primaryContainer: AppColors.primaryContainerDark,
        onPrimaryContainer: AppColors.onPrimaryContainerDark,
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.onSecondaryDark,
        secondaryContainer: AppColors.secondaryContainerDark,
        onSecondaryContainer: AppColors.onSecondaryContainerDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
        error: AppColors.errorDark,
        onError: AppColors.onErrorDark,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.onSurfaceDark,
        displayColor: AppColors.onSurfaceDark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.onSurfaceDark,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.surfaceDark,
      ),
    );
  }
}
