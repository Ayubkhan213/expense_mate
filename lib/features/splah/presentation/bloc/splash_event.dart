// lib/features/splah/presentation/bloc/splash_event.dart

abstract class SplashEvent {}

/// Checks login status on app start — replaces CheckAuthStatusEvent
class SplashCheckAuth extends SplashEvent {}

/// Loads all available currencies — replaces LoadCurrenciesEvent
class SplashLoadCurrencies extends SplashEvent {}

/// Logout — clears session from AppPrefs + Hive — replaces LogoutEvent
class SplashLogout extends SplashEvent {}
