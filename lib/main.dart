import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/core/data/models/transaction_item_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/di/injection_container.dart';
import 'package:expense_mate/core/services/app_prefs.dart';
import 'package:expense_mate/core/services/daily_notification_service.dart';
import 'package:expense_mate/core/services/hive_box_manager.dart';
import 'package:expense_mate/core/services/recurring_background_service.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  // Initialize shared preferences
  await AppPrefs.instance.init();
  await HiveInitializer.init();
  // Initialize Daily Notifications
  await DailyNotificationService().initialize();
  await RecurringBackgroundService.initialize();

  // await ThemePersistence.init();
  // await LanguagePersistence.init();

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

                localizationsDelegates: const [
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



//Ayub khan
//ayubkhn1@gmail.com
//03417825364
//ayub213
// 4321