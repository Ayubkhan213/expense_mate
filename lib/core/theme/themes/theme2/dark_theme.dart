import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme2DarkColors {
  static const primary = Color(0xFF1B5E20);
  static const secondary = Color(0xFF43A047);
  static const background = Color(0xFF06140A);
  static const surface = Color(0xFF0B1B12);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFE9F6EE);
  static const textSecondary = Color(0xFFB2DFBB);
  static const textTertiary = Color(0xFF81C784);

  // Financial colors
  static const income = Color(0xFF10B981);
  static const expense = Color(0xFFEF4444);
  static const neutral = Color(0xFF9CA3AF);
}

final ThemeData theme2Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme2DarkColors.primary,
  scaffoldBackgroundColor: Theme2DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme2DarkColors.primary,
    secondary: Theme2DarkColors.secondary,
    background: Theme2DarkColors.background,
    surface: Theme2DarkColors.surface,
    onPrimary: Theme2DarkColors.onPrimary,
    error: Theme2DarkColors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme2DarkColors.surface,
    foregroundColor: Theme2DarkColors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(
      color: Theme2DarkColors.onPrimary,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme2DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme2DarkColors.primary,
    foregroundColor: Theme2DarkColors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(
      color: Theme2DarkColors.text,
    ),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme2DarkColors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(
      color: Theme2DarkColors.text,
    ),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme2DarkColors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme2DarkColors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme2DarkColors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme2DarkColors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme2DarkColors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme2DarkColors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme2DarkColors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme2DarkColors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme2DarkColors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme2DarkColors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme2DarkColors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme2DarkColors.textTertiary,
    ),
  ),
);
