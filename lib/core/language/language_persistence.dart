// import 'package:flutter/material.dart';
// import 'package:spendio/core/services/hive_box_manager.dart';

// class LanguagePersistence {
//   static const _keyLocale = 'locale';

//   // No need for init() or box variable anymore!

//   /// Returns saved Locale, default is English
//   static Locale getSavedLocale() {
//     final String code = HiveBoxManager.language.get(
//       _keyLocale,
//       defaultValue: "en",
//     );
//     return Locale(code);
//   }

//   static String getLocale() {
//     return HiveBoxManager.language.get(_keyLocale, defaultValue: "en");
//   }

//   /// Save selected locale
//   static Future<void> saveLocale(String localeCode) async {
//     await HiveBoxManager.language.put(_keyLocale, localeCode);
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePersistence {
  static const _keyLocale = 'locale';

  static SharedPreferences? _prefs;

  /// Call once in main() before runApp
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _p {
    assert(_prefs != null, 'LanguagePersistence.init() must be called first');
    return _prefs!;
  }

  /// Returns saved Locale, default is English
  static Locale getSavedLocale() => Locale(getLocale());

  static String getLocale() => _p.getString(_keyLocale) ?? 'en';

  static Future<void> saveLocale(String localeCode) async {
    await _p.setString(_keyLocale, localeCode);
  }
}
