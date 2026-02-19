import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme6DarkColors {
  static const primary = Color(0xFFB71C1C);
  static const secondary = Color(0xFFE57373);
  static const background = Color(0xFF1A0505);
  static const surface = Color(0xFF2D0A0A);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFFFEBEE);
  static const textSecondary = Color(0xFFFFCDD2);
  static const textTertiary = Color(0xFFEF9A9A);

  // Financial colors
  static const income = Color(0xFF10B981);
  static const expense = Color(0xFFEF4444);
  static const neutral = Color(0xFF9CA3AF);
}

final ThemeData theme6Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme6DarkColors.primary,
  scaffoldBackgroundColor: Theme6DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme6DarkColors.primary,
    secondary: Theme6DarkColors.secondary,
    background: Theme6DarkColors.background,
    surface: Theme6DarkColors.surface,
    onPrimary: Theme6DarkColors.onPrimary,
    error: Theme6DarkColors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme6DarkColors.surface,
    foregroundColor: Theme6DarkColors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(
      color: Theme6DarkColors.onPrimary,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme6DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme6DarkColors.primary,
    foregroundColor: Theme6DarkColors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(
      color: Theme6DarkColors.text,
    ),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme6DarkColors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(
      color: Theme6DarkColors.text,
    ),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme6DarkColors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme6DarkColors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme6DarkColors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme6DarkColors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme6DarkColors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme6DarkColors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme6DarkColors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme6DarkColors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme6DarkColors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme6DarkColors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme6DarkColors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme6DarkColors.textTertiary,
    ),
  ),
);
