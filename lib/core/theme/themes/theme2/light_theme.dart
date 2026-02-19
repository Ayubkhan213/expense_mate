import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme2Colors {
  static const primary = Color(0xFF2E7D32);
  static const secondary = Color(0xFF66BB6A);
  static const background = Color(0xFFF6FFFA);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF062F1C);
  static const textSecondary = Color(0xFF1B5E20);
  static const textTertiary = Color(0xFF4CAF50);

  // Financial colors
  static const income = Color(0xFF059669);
  static const expense = Color(0xFFDC2626);
  static const neutral = Color(0xFF6B7280);
}

final ThemeData theme2Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme2Colors.primary,
  scaffoldBackgroundColor: Theme2Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme2Colors.primary,
    secondary: Theme2Colors.secondary,
    background: Theme2Colors.background,
    surface: Theme2Colors.surface,
    onPrimary: Theme2Colors.onPrimary,
    error: Theme2Colors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme2Colors.primary,
    foregroundColor: Theme2Colors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(color: Theme2Colors.onPrimary),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme2Colors.primary,
    foregroundColor: Theme2Colors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(color: Theme2Colors.text),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme2Colors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: Theme2Colors.text),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme2Colors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme2Colors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme2Colors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme2Colors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme2Colors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme2Colors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme2Colors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme2Colors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme2Colors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme2Colors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme2Colors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme2Colors.textTertiary,
    ),
  ),
);
