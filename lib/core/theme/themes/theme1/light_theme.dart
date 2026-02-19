// themes/theme1/light_theme.dart
import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme1Colors {
  static const primary = Color(0xFF1565C0);
  static const secondary = Color(0xFF4FC3F7);
  static const background = Color(0xFFF5FAFF);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textTertiary = Color(0xFF94A3B8);

  // Financial colors
  static const income = Color(0xFF059669);
  static const expense = Color(0xFFDC2626);
  static const neutral = Color(0xFF6B7280);
}

final ThemeData theme1Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme1Colors.primary,
  scaffoldBackgroundColor: Theme1Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme1Colors.primary,
    secondary: Theme1Colors.secondary,
    background: Theme1Colors.background,
    surface: Theme1Colors.surface,
    onPrimary: Theme1Colors.onPrimary,
    error: Theme1Colors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme1Colors.primary,
    foregroundColor: Theme1Colors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(color: Theme1Colors.onPrimary),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme1Colors.primary,
    foregroundColor: Theme1Colors.onPrimary,
  ),
  textTheme: TextTheme(
    // Display styles
    displayLarge: AppTextStyles.displayLarge.copyWith(color: Theme1Colors.text),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme1Colors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: Theme1Colors.text),

    // Headline styles
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme1Colors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme1Colors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme1Colors.text),

    // Title styles
    titleLarge: AppTextStyles.h4.copyWith(color: Theme1Colors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme1Colors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme1Colors.text),

    // Body styles
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme1Colors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme1Colors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme1Colors.textSecondary,
    ),

    // Label styles
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme1Colors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme1Colors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme1Colors.textTertiary,
    ),
  ),
);
