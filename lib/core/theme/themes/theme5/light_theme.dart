// // -------------------------
// // themes/theme5/light_theme.dart
// // -------------------------
// import 'package:flutter/material.dart';

// class Theme5Colors {
//   static const primary = Color(0xFF37474F); // minimal gray
//   static const secondary = Color(0xFF90A4AE);
//   static const background = Color(0xFFF7F8F9);
//   static const surface = Color(0xFFFFFFFF);
//   static const onPrimary = Colors.white;
//   static const text = Color(0xFF0B0F12);
// }

// final ThemeData theme5Light = ThemeData(
//   useMaterial3: true,
//   brightness: Brightness.light,
//   primaryColor: Theme5Colors.primary,
//   scaffoldBackgroundColor: Theme5Colors.background,
//   colorScheme: ColorScheme.light(
//     primary: Theme5Colors.primary,
//     secondary: Theme5Colors.secondary,
//     background: Theme5Colors.background,
//     surface: Theme5Colors.surface,
//     onPrimary: Theme5Colors.onPrimary,
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: Theme5Colors.primary,
//     foregroundColor: Theme5Colors.onPrimary,
//     elevation: 0,
//   ),
//   cardTheme: CardThemeData(
//     elevation: 1,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: Theme5Colors.primary,
//     foregroundColor: Theme5Colors.onPrimary,
//   ),
//   textTheme: Typography.blackMountainView.copyWith(
//     bodyLarge: TextStyle(color: Theme5Colors.text),
//   ),
// );
import 'package:flutter/material.dart';
import '../../typography/app_text_styles.dart';

class Theme5Colors {
  static const primary = Color(0xFF37474F); // Charcoal Gray
  static const secondary = Color(0xFF90A4AE);
  static const background = Color(0xFFF7F8F9);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF0B0F12);
  static const textSecondary = Color(0xFF546E7A);
  static const textTertiary = Color(0xFF78909C);

  // Financial colors
  static const income = Color(0xFF059669);
  static const expense = Color(0xFFDC2626);
  static const neutral = Color(0xFF6B7280);
}

final ThemeData theme5Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme5Colors.primary,
  scaffoldBackgroundColor: Theme5Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme5Colors.primary,
    secondary: Theme5Colors.secondary,
    background: Theme5Colors.background,
    surface: Theme5Colors.surface,
    onPrimary: Theme5Colors.onPrimary,
    error: Theme5Colors.expense,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme5Colors.primary,
    foregroundColor: Theme5Colors.onPrimary,
    elevation: 0,
    titleTextStyle: AppTextStyles.h4.copyWith(color: Theme5Colors.onPrimary),
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme5Colors.primary,
    foregroundColor: Theme5Colors.onPrimary,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge.copyWith(color: Theme5Colors.text),
    displayMedium: AppTextStyles.displayMedium.copyWith(
      color: Theme5Colors.text,
    ),
    displaySmall: AppTextStyles.displaySmall.copyWith(color: Theme5Colors.text),
    headlineLarge: AppTextStyles.h1.copyWith(color: Theme5Colors.text),
    headlineMedium: AppTextStyles.h2.copyWith(color: Theme5Colors.text),
    headlineSmall: AppTextStyles.h3.copyWith(color: Theme5Colors.text),
    titleLarge: AppTextStyles.h4.copyWith(color: Theme5Colors.text),
    titleMedium: AppTextStyles.h5.copyWith(color: Theme5Colors.text),
    titleSmall: AppTextStyles.h6.copyWith(color: Theme5Colors.text),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Theme5Colors.text),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(
      color: Theme5Colors.textSecondary,
    ),
    bodySmall: AppTextStyles.bodySmall.copyWith(
      color: Theme5Colors.textSecondary,
    ),
    labelLarge: AppTextStyles.labelLarge.copyWith(color: Theme5Colors.text),
    labelMedium: AppTextStyles.labelMedium.copyWith(
      color: Theme5Colors.textSecondary,
    ),
    labelSmall: AppTextStyles.labelSmall.copyWith(
      color: Theme5Colors.textTertiary,
    ),
  ),
);
