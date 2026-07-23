import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: EcoColors.primary,
        onPrimary: Colors.white,
        primaryContainer: EcoColors.primaryContainer,
        onPrimaryContainer: EcoColors.onPrimaryContainer,
        secondary: EcoColors.secondary,
        secondaryContainer: EcoColors.secondaryContainer,
        tertiary: EcoColors.tertiary,
        tertiaryContainer: EcoColors.tertiaryContainer,
        surface: EcoColors.surfaceLight,
        onSurface: EcoColors.onSurfaceLight,
        error: EcoColors.error,
        errorContainer: EcoColors.errorContainer,
      ),
      scaffoldBackgroundColor: EcoColors.backgroundLight,
      textTheme: TextTheme(
        displayLarge: EcoTypography.displayLarge,
        displayMedium: EcoTypography.displayMedium,
        displaySmall: EcoTypography.displaySmall,
        headlineLarge: EcoTypography.headlineLarge,
        headlineMedium: EcoTypography.headlineMedium,
        headlineSmall: EcoTypography.headlineSmall,
        titleLarge: EcoTypography.titleLarge,
        titleMedium: EcoTypography.titleMedium,
        titleSmall: EcoTypography.titleSmall,
        bodyLarge: EcoTypography.bodyLarge,
        bodyMedium: EcoTypography.bodyMedium,
        bodySmall: EcoTypography.bodySmall,
        labelLarge: EcoTypography.labelLarge,
        labelMedium: EcoTypography.labelMedium,
        labelSmall: EcoTypography.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: EcoColors.backgroundLight,
        foregroundColor: EcoColors.onBackgroundLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: EcoTypography.titleLarge.copyWith(
          color: EcoColors.onBackgroundLight,
        ),
      ),
      cardTheme: CardTheme(
        color: EcoColors.surfaceLight,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EcoColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: EcoTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: EcoColors.primary,
          minimumSize: const Size(64, 48),
          side: const BorderSide(color: EcoColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: EcoTypography.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EcoColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EcoColors.outlineLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EcoColors.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EcoColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: EcoColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: EcoColors.backgroundLight,
        selectedItemColor: EcoColors.primary,
        unselectedItemColor: Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        elevation: 2,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: EcoColors.primaryLight,
        onPrimary: EcoColors.backgroundDark,
        primaryContainer: EcoColors.onPrimaryContainer,
        onPrimaryContainer: EcoColors.primaryContainer,
        secondary: EcoColors.secondary,
        secondaryContainer: EcoColors.secondaryContainer,
        tertiary: EcoColors.tertiary,
        tertiaryContainer: EcoColors.tertiaryContainer,
        surface: EcoColors.surfaceDark,
        onSurface: EcoColors.onSurfaceDark,
        error: EcoColors.error,
        errorContainer: EcoColors.errorContainer,
      ),
      scaffoldBackgroundColor: EcoColors.backgroundDark,
      textTheme: TextTheme(
        displayLarge: EcoTypography.displayLarge.copyWith(color: EcoColors.onBackgroundDark),
        displayMedium: EcoTypography.displayMedium.copyWith(color: EcoColors.onBackgroundDark),
        displaySmall: EcoTypography.displaySmall.copyWith(color: EcoColors.onBackgroundDark),
        headlineLarge: EcoTypography.headlineLarge.copyWith(color: EcoColors.onBackgroundDark),
        headlineMedium: EcoTypography.headlineMedium.copyWith(color: EcoColors.onBackgroundDark),
        headlineSmall: EcoTypography.headlineSmall.copyWith(color: EcoColors.onBackgroundDark),
        titleLarge: EcoTypography.titleLarge.copyWith(color: EcoColors.onBackgroundDark),
        titleMedium: EcoTypography.titleMedium.copyWith(color: EcoColors.onSurfaceDark),
        titleSmall: EcoTypography.titleSmall.copyWith(color: EcoColors.onSurfaceDark),
        bodyLarge: EcoTypography.bodyLarge.copyWith(color: EcoColors.onSurfaceDark),
        bodyMedium: EcoTypography.bodyMedium.copyWith(color: EcoColors.onSurfaceDark),
        bodySmall: EcoTypography.bodySmall.copyWith(color: EcoColors.onSurfaceDark),
        labelLarge: EcoTypography.labelLarge.copyWith(color: EcoColors.onSurfaceDark),
        labelMedium: EcoTypography.labelMedium.copyWith(color: EcoColors.onSurfaceDark),
        labelSmall: EcoTypography.labelSmall.copyWith(color: EcoColors.onSurfaceDark),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: EcoColors.backgroundDark,
        foregroundColor: EcoColors.onBackgroundDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: EcoTypography.titleLarge.copyWith(
          color: EcoColors.onBackgroundDark,
        ),
      ),
      cardTheme: CardTheme(
        color: EcoColors.surfaceDark,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: EcoColors.surfaceDark,
        selectedItemColor: EcoColors.primaryLight,
        unselectedItemColor: Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 2,
      ),
    );
  }
}
