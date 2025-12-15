// -------------------------
// themes/theme5/dark_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme5DarkColors {
  static const primary = Color(0xFF263238);
  static const secondary = Color(0xFF78909C);
  static const background = Color(0xFF0A0E10);
  static const surface = Color(0xFF111417);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFECEFF1);
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
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme5DarkColors.surface,
    foregroundColor: Theme5DarkColors.onPrimary,
    elevation: 0,
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
  textTheme: Typography.whiteMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme5DarkColors.text),
  ),
);
