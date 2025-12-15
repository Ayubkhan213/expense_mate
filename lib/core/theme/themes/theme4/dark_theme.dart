// -------------------------
// themes/theme4/dark_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme4DarkColors {
  static const primary = Color(0xFFBF360C);
  static const secondary = Color(0xFFFF8A65);
  static const background = Color(0xFF2A1408);
  static const surface = Color(0xFF33170B);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFFFF5EE);
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
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme4DarkColors.surface,
    foregroundColor: Theme4DarkColors.onPrimary,
    elevation: 0,
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
  textTheme: Typography.whiteMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme4DarkColors.text),
  ),
);
