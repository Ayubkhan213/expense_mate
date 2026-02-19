// // -------------------------
// // themes/theme4/dark_theme.dart
// // -------------------------
// import 'package:flutter/material.dart';

// class Theme4DarkColors {
//   static const primary = Color(0xFFBF360C);
//   static const secondary = Color(0xFFFF8A65);
//   static const background = Color(0xFF2A1408);
//   static const surface = Color(0xFF33170B);
//   static const onPrimary = Colors.white;
//   static const text = Color(0xFFFFF5EE);
// }

// final ThemeData theme4Dark = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.dark,
//   primaryColor: Theme4DarkColors.primary,
//   scaffoldBackgroundColor: Theme4DarkColors.background,
//   colorScheme: ColorScheme.dark(
//     primary: Theme4DarkColors.primary,
//     secondary: Theme4DarkColors.secondary,
//     background: Theme4DarkColors.background,
//     surface: Theme4DarkColors.surface,
//     onPrimary: Theme4DarkColors.onPrimary,
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: Theme4DarkColors.surface,
//     foregroundColor: Theme4DarkColors.onPrimary,
//     elevation: 0,
//   ),
//   cardTheme: CardThemeData(
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     color: Theme4DarkColors.surface,
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: Theme4DarkColors.primary,
//     foregroundColor: Theme4DarkColors.onPrimary,
//   ),
//   textTheme: Typography.whiteMountainView.copyWith(
//     bodyLarge: TextStyle(color: Theme4DarkColors.text),
//   ),
// );
import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme4DarkColors {
  static const primary = Color(0xFFBF360C);
  static const secondary = Color(0xFFFF8A65);
  static const background = Color(0xFF2A1408);
  static const surface = Color(0xFF33170B);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFFFF5EE);
  static const textSecondary = Color(0xFFFFB997);
  static const textTertiary = Color(0xFFFF9966);

  // Financial colors
  static const income = Color(0xFF10B981);
  static const expense = Color(0xFFEF4444);
  static const neutral = Color(0xFF9CA3AF);
}

final ThemeData theme4Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme4DarkColors.primary,
  scaffoldBackgroundColor: Theme4DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme4DarkColors.primary,
    secondary: Theme4DarkColors.secondary,
    background: Theme4DarkColors.background,
    surface: Theme4DarkColors.surface,
    onPrimary: Theme4DarkColors.onPrimary,
    error: Theme4DarkColors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme4DarkColors.surface,
    foregroundColor: Theme4DarkColors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(
      color: Theme4DarkColors.onPrimary,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme4DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme4DarkColors.primary,
    foregroundColor: Theme4DarkColors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(
      color: Theme4DarkColors.text,
    ),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme4DarkColors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(
      color: Theme4DarkColors.text,
    ),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme4DarkColors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme4DarkColors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme4DarkColors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme4DarkColors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme4DarkColors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme4DarkColors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme4DarkColors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme4DarkColors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme4DarkColors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme4DarkColors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme4DarkColors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme4DarkColors.textTertiary,
    ),
  ),
);
