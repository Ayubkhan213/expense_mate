// -------------------------
// themes/theme3/dark_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme3DarkColors {
  static const primary = Color(0xFF4A148C);
  static const secondary = Color(0xFF9C27B0);
  static const background = Color(0xFF12061A);
  static const surface = Color(0xFF1B0E1F);
  static const onPrimary = Colors.white;
  static const text = Color(0xFFFFF1FF);
}

final ThemeData theme3Dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: Theme3DarkColors.primary,
  scaffoldBackgroundColor: Theme3DarkColors.background,
  colorScheme: ColorScheme.dark(
    primary: Theme3DarkColors.primary,
    secondary: Theme3DarkColors.secondary,
    background: Theme3DarkColors.background,
    surface: Theme3DarkColors.surface,
    onPrimary: Theme3DarkColors.onPrimary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme3DarkColors.surface,
    foregroundColor: Theme3DarkColors.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Theme3DarkColors.surface,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme3DarkColors.primary,
    foregroundColor: Theme3DarkColors.onPrimary,
  ),
  textTheme: Typography.whiteMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme3DarkColors.text),
  ),
);
