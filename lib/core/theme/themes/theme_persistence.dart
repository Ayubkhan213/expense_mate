// import 'package:spendio/core/services/hive_box_manager.dart';

// class ThemePersistence {
//   static const _keyThemeIndex = 'themeIndex';
//   static const _keyIsDark = 'isDark';

//   // No need for init() - BoxManager handles it!
//   // No need for _box - use BoxManager.settings!

//   static void saveThemeIndex(int index) {
//     HiveBoxManager.settings.put(_keyThemeIndex, index);
//   }

//   static int getThemeIndex() {
//     return HiveBoxManager.settings.get(_keyThemeIndex, defaultValue: 0) as int;
//   }

//   static void saveDarkMode(bool isDark) {
//     HiveBoxManager.settings.put(_keyIsDark, isDark);
//   }

//   static bool getDarkMode() {
//     return HiveBoxManager.settings.get(_keyIsDark, defaultValue: false) as bool;
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

class ThemePersistence {
  static const _keyThemeIndex = 'themeIndex';
  static const _keyIsDark = 'isDark';

  static SharedPreferences? _prefs;

  /// Call once in main() before runApp
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _p {
    assert(_prefs != null, 'ThemePersistence.init() must be called first');
    return _prefs!;
  }

  static void saveThemeIndex(int index) => _p.setInt(_keyThemeIndex, index);

  static int getThemeIndex() => _p.getInt(_keyThemeIndex) ?? 4;

  static void saveDarkMode(bool isDark) => _p.setBool(_keyIsDark, isDark);

  static bool getDarkMode() => _p.getBool(_keyIsDark) ?? false;
}
