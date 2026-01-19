import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  AppPrefs._internal();
  static final AppPrefs instance = AppPrefs._internal();

  late SharedPreferences _prefs;

  /// Call this once at app startup
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // KEYS
  // ---------------------------------------------------------------------------
  static const String _onboardingSeen = 'onboarding_seen';
  static const String _isLoggedIn = 'is_logged_in';
  static const String _userId = 'user_id';

  // ---------------------------------------------------------------------------
  // ONBOARDING
  // ---------------------------------------------------------------------------
  bool get onboardingSeen => _prefs.getBool(_onboardingSeen) ?? false;

  Future<void> setOnboardingSeen(bool value) async {
    await _prefs.setBool(_onboardingSeen, value);
  }

  // ---------------------------------------------------------------------------
  // LOGIN STATE
  // ---------------------------------------------------------------------------
  bool get isLoggedIn => _prefs.getBool(_isLoggedIn) ?? false;

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedIn, value);
  }

  // ---------------------------------------------------------------------------
  // USER ID
  // ---------------------------------------------------------------------------
  String? get userId => _prefs.getString(_userId);

  Future<void> setUserId(String id) async {
    await _prefs.setString(_userId, id);
  }

  // ---------------------------------------------------------------------------
  // CLEAR SESSION (LOGOUT)
  // ---------------------------------------------------------------------------
  Future<void> clearSession() async {
    await _prefs.remove(_isLoggedIn);
    await _prefs.remove(_userId);
  }

  // ---------------------------------------------------------------------------
  // FULL RESET (OPTIONAL)
  // ---------------------------------------------------------------------------
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
