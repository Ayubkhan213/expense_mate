// -------------------------
// themes/theme1/dark_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme1DarkColors {
  static const primary = Color(0xFF0D47A1);
  static const secondary = Color(0xFF29B6F6);
  static const background = Color(0xFF081228);
  static const surface = Color(0xFF0B1220);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFE6EEF8);
}

final ThemeData theme1Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme1DarkColors.primary,
  scaffoldBackgroundColor: Theme1DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme1DarkColors.primary,
    secondary: Theme1DarkColors.secondary,
    background: Theme1DarkColors.background,
    surface: Theme1DarkColors.surface,
    onPrimary: Theme1DarkColors.onPrimary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme1DarkColors.surface,
    foregroundColor: Theme1DarkColors.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme1DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme1DarkColors.primary,
    foregroundColor: Theme1DarkColors.onPrimary,
  ),
  textTheme: Typography.whiteMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme1DarkColors.text),
  ),
);
