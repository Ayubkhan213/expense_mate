// -------------------------
// themes/theme4/light_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme4Colors {
  static const primary = Color(0xFFEF6C00); // sunset orange
  static const secondary = Color(0xFFFFA726);
  static const background = Color(0xFFFFFBF6);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF3B1F00);
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
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme4Colors.primary,
    foregroundColor: Theme4Colors.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme4Colors.primary,
    foregroundColor: Theme4Colors.onPrimary,
  ),
  textTheme: Typography.blackMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme4Colors.text),
  ),
);
