import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme6Colors {
  static const primary = Color(0xFFC62828); // Crimson Red
  static const secondary = Color(0xFFEF5350);
  static const background = Color(0xFFFFF5F5);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF1A0000);
  static const textSecondary = Color(0xFF5D0000);
  static const textTertiary = Color(0xFFB71C1C);

  // Financial colors
  static const income = Color(0xFF059669);
  static const expense = Color(0xFFDC2626);
  static const neutral = Color(0xFF6B7280);
}

final ThemeData theme6Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme6Colors.primary,
  scaffoldBackgroundColor: Theme6Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme6Colors.primary,
    secondary: Theme6Colors.secondary,
    background: Theme6Colors.background,
    surface: Theme6Colors.surface,
    onPrimary: Theme6Colors.onPrimary,
    error: Theme6Colors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme6Colors.primary,
    foregroundColor: Theme6Colors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(color: Theme6Colors.onPrimary),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme6Colors.primary,
    foregroundColor: Theme6Colors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(color: Theme6Colors.text),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme6Colors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: Theme6Colors.text),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme6Colors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme6Colors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme6Colors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme6Colors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme6Colors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme6Colors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme6Colors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme6Colors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme6Colors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme6Colors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme6Colors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme6Colors.textTertiary,
    ),
  ),
);
