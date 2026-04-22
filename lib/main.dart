// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendio/core/data/data_sources/local/category_seeder.dart';
import 'package:spendio/core/data/data_sources/local/currencies_seeding.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'package:spendio/core/di/injection_container.dart';
import 'package:spendio/core/language/bloc/language_bloc.dart';
import 'package:spendio/core/language/bloc/language_state.dart';
import 'package:spendio/core/language/language_persistence.dart';
import 'package:spendio/core/navigation/app_routing.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spendio/core/providers/app_providers.dart';
import 'package:spendio/core/services/app_prefs.dart';
import 'package:spendio/core/services/auto_notification_scheduler.dart';
import 'package:spendio/core/services/dummy_account_sedding.dart';
import 'package:spendio/core/services/recurring_background_sql_services.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:spendio/core/theme/app_theme.dart';
import 'package:spendio/core/theme/bloc/theme_bloc.dart';
import 'package:spendio/core/theme/bloc/theme_state.dart';
import 'package:spendio/core/theme/themes/theme_persistence.dart';
import 'package:spendio/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();
  // Initialize shared preferences
  await AppPrefs.instance.init();
  // await HiveInitializer.init();
  await SqliteHelper.instance.database;

  await CategorySeeder.seedIfFirstTime();
  await CurrenciesSeeding.seedCurrenciesIfFirstTime();
  await DummyAccountSeeder.seedIfFirstTime();
  // Initialize Daily Notifications
  try {
    await AutoNotificationScheduler.scheduleIfNeeded();
  } catch (e) {
    debugPrint('Notification scheduling skipped: $e');
  }

  await RecurringBackgroundService.initialize();
  //  Process on every app open (catches missed transactions)
  await RecurringBackgroundService.processRecurringTransactions();
  // await RecurringBackgroundService.debugPrintRecurringState();
  await LanguagePersistence.init();
  await ThemePersistence.init();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppProviders.providers,

      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, langState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,

                //  THEME SYSTEM
                theme: AppThemes.lightThemes[themeState.themeIndex],
                darkTheme: AppThemes.darkThemes[themeState.themeIndex],
                themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,

                //  LANGUAGE / LOCALIZATION
                locale: Locale(langState.locale), //

                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                  Locale('ur'),
                  Locale('fr'),
                ],

                //  ROUTING
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute: RouteName.splash,
              );
            },
          );
        },
      ),
    );
  }
}

// flutter gen-l10n
//flutter pub run build_runner build --delete-conflicting-outputs
// C:\Program Files\Common Files\Oracle\Java\javapath
// final t = AppLocalizations.of(context)!;

// keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
// flutter build appbundle --release
