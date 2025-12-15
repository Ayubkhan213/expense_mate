// -------------------------
// themes/theme1/light_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme1Colors {
  static const primary = Color(0xFF1565C0); // modern blue
  static const secondary = Color(0xFF4FC3F7);
  static const background = Color(0xFFF5FAFF);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF0F172A);
}

final ThemeData theme1Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme1Colors.primary,
  scaffoldBackgroundColor: Theme1Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme1Colors.primary,
    secondary: Theme1Colors.secondary,
    background: Theme1Colors.background,
    surface: Theme1Colors.surface,
    onPrimary: Theme1Colors.onPrimary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme1Colors.primary,
    foregroundColor: Theme1Colors.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme1Colors.primary,
    foregroundColor: Theme1Colors.onPrimary,
  ),
  textTheme: Typography.blackMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme1Colors.text),
  ),
);
