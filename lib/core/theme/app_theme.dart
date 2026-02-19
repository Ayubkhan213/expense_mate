import 'package:flutter/material.dart';

import 'themes/theme1/light_theme.dart' as t1l;
import 'themes/theme1/dark_theme.dart' as t1d;
import 'themes/theme2/light_theme.dart' as t2l;
import 'themes/theme2/dark_theme.dart' as t2d;
import 'themes/theme3/light_theme.dart' as t3l;
import 'themes/theme3/dark_theme.dart' as t3d;
import 'themes/theme4/light_theme.dart' as t4l;
import 'themes/theme4/dark_theme.dart' as t4d;
import 'themes/theme5/light_theme.dart' as t5l;
import 'themes/theme5/dark_theme.dart' as t5d;
import 'themes/theme6/light_theme.dart' as t6l;
import 'themes/theme6/dark_theme.dart' as t6d;

class AppThemes {
  static final List<ThemeData> lightThemes = [
    t1l.theme1Light, // Ocean Blue
    t2l.theme2Light, // Emerald Green
    t3l.theme3Light, // Royal Purple
    t4l.theme4Light, // Sunset Orange
    t5l.theme5Light, // Charcoal Gray
    t6l.theme6Light, // Crimson Red
  ];

  static final List<ThemeData> darkThemes = [
    t1d.theme1Dark, // Ocean Blue Dark
    t2d.theme2Dark, // Emerald Green Dark
    t3d.theme3Dark, // Royal Purple Dark
    t4d.theme4Dark, // Sunset Orange Dark
    t5d.theme5Dark, // Charcoal Gray Dark
    t6d.theme6Dark, // Crimson Red Dark
  ];

  static final List<String> themeNames = [
    'Ocean Blue',
    'Emerald Green',
    'Royal Purple',
    'Sunset Orange',
    'Charcoal Gray',
    'Crimson Red',
  ];

  static final List<String> themeDescriptions = [
    'Professional & Trustworthy',
    'Growth & Prosperity',
    'Premium & Elegant',
    'Warm & Inviting',
    'Minimal & Modern',
    'Bold & Powerful',
  ];

  static ThemeData getTheme(int index, bool isDark) {
    final i = index.clamp(0, lightThemes.length - 1);
    return isDark ? darkThemes[i] : lightThemes[i];
  }

  static String getThemeName(int index) {
    final i = index.clamp(0, themeNames.length - 1);
    return themeNames[i];
  }

  static String getThemeDescription(int index) {
    final i = index.clamp(0, themeDescriptions.length - 1);
    return themeDescriptions[i];
  }

  // Get theme preview color
  static Color getThemePreviewColor(int index, bool isDark) {
    if (isDark) {
      return [
        const Color(0xFF0D47A1), // Theme 1
        const Color(0xFF1B5E20), // Theme 2
        const Color(0xFF4A148C), // Theme 3
        const Color(0xFFBF360C), // Theme 4
        const Color(0xFF263238), // Theme 5
        const Color(0xFFB71C1C), // Theme 6
      ][index.clamp(0, 5)];
    } else {
      return [
        const Color(0xFF1565C0), // Theme 1
        const Color(0xFF2E7D32), // Theme 2
        const Color(0xFF6A1B9A), // Theme 3
        const Color(0xFFEF6C00), // Theme 4
        const Color(0xFF37474F), // Theme 5
        const Color(0xFFC62828), // Theme 6
      ][index.clamp(0, 5)];
    }
  }
}
