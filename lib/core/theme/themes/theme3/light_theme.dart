// -------------------------
// themes/theme3/light_theme.dart
// -------------------------
import 'package:flutter/material.dart';

class Theme3Colors {
  static const primary = Color(0xFF6A1B9A); // purple
  static const secondary = Color(0xFFAB47BC);
  static const background = Color(0xFFF9F5FF);
  static const surface = Color(0xFFFFFFFF);
  static const onPrimary = Colors.white;
  static const text = Color(0xFF2B0736);
}

final ThemeData theme3Light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: Theme3Colors.primary,
  scaffoldBackgroundColor: Theme3Colors.background,
  colorScheme: ColorScheme.light(
    primary: Theme3Colors.primary,
    secondary: Theme3Colors.secondary,
    background: Theme3Colors.background,
    surface: Theme3Colors.surface,
    onPrimary: Theme3Colors.onPrimary,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Theme3Colors.primary,
    foregroundColor: Theme3Colors.onPrimary,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Theme3Colors.primary,
    foregroundColor: Theme3Colors.onPrimary,
  ),
  textTheme: Typography.blackMountainView.copyWith(
    bodyLarge: TextStyle(color: Theme3Colors.text),
  ),
);
