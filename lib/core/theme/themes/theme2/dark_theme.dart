// -------------------------
// themes/theme2/dark_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme2DarkColors {
  static const primary = Color(0xFF1B5E20);
  static const secondary = Color(0xFF43A047);
  static const background = Color(0xFF06140A);
  static const surface = Color(0xFF0B1B12);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFE9F6EE);
}

final ThemeData theme2Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme2DarkColors.primary,
  scaffoldBackgroundColor: Theme2DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme2DarkColors.primary,
    secondary: Theme2DarkColors.secondary,
    background: Theme2DarkColors.background,
    surface: Theme2DarkColors.surface,
    onPrimary: Theme2DarkColors.onPrimary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme2DarkColors.surface,
    foregroundColor: Theme2DarkColors.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme2DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme2DarkColors.primary,
    foregroundColor: Theme2DarkColors.onPrimary,
  ),
  textTheme: Typography.whiteMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme2DarkColors.text),
  ),
);
