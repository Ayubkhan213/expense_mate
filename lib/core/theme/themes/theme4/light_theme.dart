// // -------------------------
// // themes/theme4/light_theme.dart
// // -------------------------
// import 'package:flutter/material.dart';

// class Theme4Colors {
//   static const primary = Color(0xFFEF6C00); // sunset orange
//   static const secondary = Color(0xFFFFA726);
//   static const background = Color(0xFFFFFBF6);
//   static const surface = Color(0xFFFFFFFF);
//   static const onPrimary = Colors.white;
//   static const text = Color(0xFF3B1F00);
// }

// final ThemeData theme4Light = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.light,
//   primaryColor: Theme4Colors.primary,
//   scaffoldBackgroundColor: Theme4Colors.background,
//   colorScheme: ColorScheme.light(
//     primary: Theme4Colors.primary,
//     secondary: Theme4Colors.secondary,
//     background: Theme4Colors.background,
//     surface: Theme4Colors.surface,
//     onPrimary: Theme4Colors.onPrimary,
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: Theme4Colors.primary,
//     foregroundColor: Theme4Colors.onPrimary,
//     elevation: 0,
//   ),
//   cardTheme: CardThemeData(
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: Theme4Colors.primary,
//     foregroundColor: Theme4Colors.onPrimary,
//   ),
//   textTheme: Typography.blackMountainView.copyWith(
//     bodyLarge: TextStyle(color: Theme4Colors.text),
//   ),
// );
import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme4Colors {
  static const primary = Color(0xFFEF6C00); // Sunset Orange
  static const secondary = Color(0xFFFFA726);
  static const background = Color(0xFFFFFBF6);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF3B1F00);
  static const textSecondary = Color(0xFF8B4000);
  static const textTertiary = Color(0xFFFF8C42);

  // Financial colors
  static const income = Color(0xFF059669);
  static const expense = Color(0xFFDC2626);
  static const neutral = Color(0xFF6B7280);
}

final ThemeData theme4Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme4Colors.primary,
  scaffoldBackgroundColor: Theme4Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme4Colors.primary,
    secondary: Theme4Colors.secondary,
    background: Theme4Colors.background,
    surface: Theme4Colors.surface,
    onPrimary: Theme4Colors.onPrimary,
    error: Theme4Colors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme4Colors.primary,
    foregroundColor: Theme4Colors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(color: Theme4Colors.onPrimary),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme4Colors.primary,
    foregroundColor: Theme4Colors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(color: Theme4Colors.text),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme4Colors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: Theme4Colors.text),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme4Colors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme4Colors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme4Colors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme4Colors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme4Colors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme4Colors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme4Colors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme4Colors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme4Colors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme4Colors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme4Colors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme4Colors.textTertiary,
    ),
  ),
);
