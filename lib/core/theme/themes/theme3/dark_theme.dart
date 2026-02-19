import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme3DarkColors {
  static const primary = Color(0xFF4A148C);
  static const secondary = Color(0xFF9C27B0);
  static const background = Color(0xFF12061A);
  static const surface = Color(0xFF1B0E1F);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFFFF1FF);
  static const textSecondary = Color(0xFFE1BEE7);
  static const textTertiary = Color(0xFFCE93D8);

  // Financial colors
  static const income = Color(0xFF10B981);
  static const expense = Color(0xFFEF4444);
  static const neutral = Color(0xFF9CA3AF);
}

final ThemeData theme3Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme3DarkColors.primary,
  scaffoldBackgroundColor: Theme3DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme3DarkColors.primary,
    secondary: Theme3DarkColors.secondary,
    background: Theme3DarkColors.background,
    surface: Theme3DarkColors.surface,
    onPrimary: Theme3DarkColors.onPrimary,
    error: Theme3DarkColors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme3DarkColors.surface,
    foregroundColor: Theme3DarkColors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(
      color: Theme3DarkColors.onPrimary,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme3DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme3DarkColors.primary,
    foregroundColor: Theme3DarkColors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(
      color: Theme3DarkColors.text,
    ),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme3DarkColors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(
      color: Theme3DarkColors.text,
    ),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme3DarkColors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme3DarkColors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme3DarkColors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme3DarkColors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme3DarkColors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme3DarkColors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme3DarkColors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme3DarkColors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme3DarkColors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme3DarkColors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme3DarkColors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme3DarkColors.textTertiary,
    ),
  ),
);
