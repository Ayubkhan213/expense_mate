// // -------------------------
// // themes/theme5/dark_theme.dart
// // -------------------------
// import 'package:flutter/material.dart';

// class Theme5DarkColors {
//   static const primary = Color(0xFF263238);
//   static const secondary = Color(0xFF78909C);
//   static const background = Color(0xFF0A0E10);
//   static const surface = Color(0xFF111417);
//   static const onPrimary = Colors.white;
//   static const text = Color(0xFFECEFF1);
// }

// final ThemeData theme5Dark = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.dark,
//   primaryColor: Theme5DarkColors.primary,
//   scaffoldBackgroundColor: Theme5DarkColors.background,
//   colorScheme: ColorScheme.dark(
//     primary: Theme5DarkColors.primary,
//     secondary: Theme5DarkColors.secondary,
//     background: Theme5DarkColors.background,
//     surface: Theme5DarkColors.surface,
//     onPrimary: Theme5DarkColors.onPrimary,
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: Theme5DarkColors.surface,
//     foregroundColor: Theme5DarkColors.onPrimary,
//     elevation: 0,
//   ),
//   cardTheme: CardThemeData(
//     elevation: 1,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     color: Theme5DarkColors.surface,
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: Theme5DarkColors.primary,
//     foregroundColor: Theme5DarkColors.onPrimary,
//   ),
//   textTheme: Typography.whiteMountainView.copyWith(
//     bodyLarge: TextStyle(color: Theme5DarkColors.text),
//   ),
// );
import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme5DarkColors {
  static const primary = Color(0xFF263238);
  static const secondary = Color(0xFF78909C);
  static const background = Color(0xFF0A0E10);
  static const surface = Color(0xFF111417);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFECEFF1);
  static const textSecondary = Color(0xFFB0BEC5);
  static const textTertiary = Color(0xFF90A4AE);

  // Financial colors
  static const income = Color(0xFF10B981);
  static const expense = Color(0xFFEF4444);
  static const neutral = Color(0xFF9CA3AF);
}

final ThemeData theme5Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme5DarkColors.primary,
  scaffoldBackgroundColor: Theme5DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme5DarkColors.primary,
    secondary: Theme5DarkColors.secondary,
    background: Theme5DarkColors.background,
    surface: Theme5DarkColors.surface,
    onPrimary: Theme5DarkColors.onPrimary,
    error: Theme5DarkColors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme5DarkColors.surface,
    foregroundColor: Theme5DarkColors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(
      color: Theme5DarkColors.onPrimary,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme5DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme5DarkColors.primary,
    foregroundColor: Theme5DarkColors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(
      color: Theme5DarkColors.text,
    ),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme5DarkColors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(
      color: Theme5DarkColors.text,
    ),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme5DarkColors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme5DarkColors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme5DarkColors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme5DarkColors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme5DarkColors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme5DarkColors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme5DarkColors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme5DarkColors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme5DarkColors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme5DarkColors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme5DarkColors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme5DarkColors.textTertiary,
    ),
  ),
);
