import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  await HiveInitializer.init();
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
