import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme3Colors {
  static const primary = Color(0xFF6A1B9A);
  static const secondary = Color(0xFFAB47BC);
  static const background = Color(0xFFF9F5FF);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF2B0736);
  static const textSecondary = Color(0xFF6A1B9A);
  static const textTertiary = Color(0xFF9C27B0);

  // Financial colors
  static const income = Color(0xFF059669);
  static const expense = Color(0xFFDC2626);
  static const neutral = Color(0xFF6B7280);
}

final ThemeData theme3Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme3Colors.primary,
  scaffoldBackgroundColor: Theme3Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme3Colors.primary,
    secondary: Theme3Colors.secondary,
    background: Theme3Colors.background,
    surface: Theme3Colors.surface,
    onPrimary: Theme3Colors.onPrimary,
    error: Theme3Colors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme3Colors.primary,
    foregroundColor: Theme3Colors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(color: Theme3Colors.onPrimary),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme3Colors.primary,
    foregroundColor: Theme3Colors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(color: Theme3Colors.text),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme3Colors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: Theme3Colors.text),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme3Colors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme3Colors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme3Colors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme3Colors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme3Colors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme3Colors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme3Colors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme3Colors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme3Colors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme3Colors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme3Colors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme3Colors.textTertiary,
    ),
  ),
);
