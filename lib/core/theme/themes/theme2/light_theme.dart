// -------------------------
// themes/theme2/light_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme2Colors {
  static const primary = Color(0xFF2E7D32); // emerald
  static const secondary = Color(0xFF66BB6A);
  static const background = Color(0xFFF6FFFA);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF062F1C);
}

final ThemeData theme2Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme2Colors.primary,
  scaffoldBackgroundColor: Theme2Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme2Colors.primary,
    secondary: Theme2Colors.secondary,
    background: Theme2Colors.background,
    surface: Theme2Colors.surface,
    onPrimary: Theme2Colors.onPrimary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme2Colors.primary,
    foregroundColor: Theme2Colors.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme2Colors.primary,
    foregroundColor: Theme2Colors.onPrimary,
  ),
  textTheme: Typography.blackMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme2Colors.text),
  ),
);
