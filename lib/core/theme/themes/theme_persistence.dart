import 'package:expense_mate/core/services/hive_box_manager.dart';

class ThemePersistence {
  static const _keyThemeIndex = 'themeIndex';
  static const _keyIsDark = 'isDark';

  // No need for init() - BoxManager handles it!
  // No need for _box - use BoxManager.settings!

  static void saveThemeIndex(int index) {
    HiveBoxManager.settings.put(_keyThemeIndex, index);
  }

  static int getThemeIndex() {
    return HiveBoxManager.settings.get(_keyThemeIndex, defaultValue: 0) as int;
  }

  static void saveDarkMode(bool isDark) {
    HiveBoxManager.settings.put(_keyIsDark, isDark);
  }

  static bool getDarkMode() {
    return HiveBoxManager.settings.get(_keyIsDark, defaultValue: false) as bool;
  }
}
