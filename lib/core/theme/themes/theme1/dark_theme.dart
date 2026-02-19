import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme1DarkColors {
  static const primary = Color(0xFF0D47A1);
  static const secondary = Color(0xFF29B6F6);
  static const background = Color(0xFF081228);
  static const surface = Color(0xFF0B1220);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFE6EEF8);
  static const textSecondary = Color(0xFF9DB4D1);
  static const textTertiary = Color(0xFF6B86A3);

  // Financial colors
  static const income = Color(0xFF10B981);
  static const expense = Color(0xFFEF4444);
  static const neutral = Color(0xFF9CA3AF);
}

final ThemeData theme1Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme1DarkColors.primary,
  scaffoldBackgroundColor: Theme1DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme1DarkColors.primary,
    secondary: Theme1DarkColors.secondary,
    background: Theme1DarkColors.background,
    surface: Theme1DarkColors.surface,
    onPrimary: Theme1DarkColors.onPrimary,
    error: Theme1DarkColors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme1DarkColors.surface,
    foregroundColor: Theme1DarkColors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(
      color: Theme1DarkColors.onPrimary,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme1DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme1DarkColors.primary,
    foregroundColor: Theme1DarkColors.onPrimary,
  ),
  textTheme: TextTheme(
    // Display styles
    displayLarge: AppTextStyles.displayLarge.copyWith(
      color: Theme1DarkColors.text,
    ),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme1DarkColors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(
      color: Theme1DarkColors.text,
    ),

    // Headline styles
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme1DarkColors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme1DarkColors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme1DarkColors.text),

    // Title styles
    titleLarge: AppTextStyles.h4.copyWith(color: Theme1DarkColors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme1DarkColors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme1DarkColors.text),

    // Body styles
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme1DarkColors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme1DarkColors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme1DarkColors.textSecondary,
    ),

    // Label styles
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme1DarkColors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme1DarkColors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme1DarkColors.textTertiary,
    ),
  ),
);
