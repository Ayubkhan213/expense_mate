import 'package:hive_flutter/hive_flutter.dart';

class ThemePersistence {
  static const _boxName = 'settings';
  static const _keyThemeIndex = 'themeIndex';
  static const _keyIsDark = 'isDark';

  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  static void saveThemeIndex(int index) {
    _box.put(_keyThemeIndex, index);
  }

  static int getThemeIndex() {
    return _box.get(_keyThemeIndex, defaultValue: 0) as int;
  }

  static void saveDarkMode(bool isDark) {
    _box.put(_keyIsDark, isDark);
  }

  static bool getDarkMode() {
    return _box.get(_keyIsDark, defaultValue: false) as bool;
  }
}
