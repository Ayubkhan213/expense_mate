// -------------------------
// app_themes.dart
// -------------------------
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

class AppThemes {
  static final List<ThemeData> lightThemes = [
    t1l.theme1Light,
    t2l.theme2Light,
    t3l.theme3Light,
    t4l.theme4Light,
    t5l.theme5Light,
  ];

  static final List<ThemeData> darkThemes = [
    t1d.theme1Dark,
    t2d.theme2Dark,
    t3d.theme3Dark,
    t4d.theme4Dark,
    t5d.theme5Dark,
  ];

  static ThemeData getTheme(int index, bool isDark) {
    final i = index.clamp(0, lightThemes.length - 1);
    return isDark ? darkThemes[i] : lightThemes[i];
  }
}
