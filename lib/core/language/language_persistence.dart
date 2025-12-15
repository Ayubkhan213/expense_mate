import 'package:expense_mate/core/app_export.dart';

class LanguagePersistence {
  static late Box box;

  /// Initialize Hive box
  static Future<void> init() async {
    box = await Hive.openBox("languageBox");
  }

  /// Returns saved Locale, default is English
  static Locale getSavedLocale() {
    final String code = box.get("locale", defaultValue: "en");
    return Locale(code);
  }

  static String getLocale() {
    return box.get("locale", defaultValue: "en");
  }

  /// Save selected locale
  static Future<void> saveLocale(String localeCode) async {
    await box.put("locale", localeCode);
  }
}
