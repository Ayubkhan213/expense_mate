import 'package:flutter/material.dart';
import 'package:expense_mate/core/services/hive_box_manager.dart';

class LanguagePersistence {
  static const _keyLocale = 'locale';

  // No need for init() or box variable anymore!

  /// Returns saved Locale, default is English
  static Locale getSavedLocale() {
    final String code = HiveBoxManager.language.get(
      _keyLocale,
      defaultValue: "en",
    );
    return Locale(code);
  }

  static String getLocale() {
    return HiveBoxManager.language.get(_keyLocale, defaultValue: "en");
  }

  /// Save selected locale
  static Future<void> saveLocale(String localeCode) async {
    await HiveBoxManager.language.put(_keyLocale, localeCode);
  }
}
