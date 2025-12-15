// -------------------------
// themes/theme5/light_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme5Colors {
  static const primary = Color(0xFF37474F); // minimal gray
  static const secondary = Color(0xFF90A4AE);
  static const background = Color(0xFFF7F8F9);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF0B0F12);
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
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme5Colors.primary,
    foregroundColor: Theme5Colors.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme5Colors.primary,
    foregroundColor: Theme5Colors.onPrimary,
  ),
  textTheme: Typography.blackMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme5Colors.text),
  ),
);
