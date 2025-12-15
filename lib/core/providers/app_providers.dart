import 'package:expense_mate/core/app_export.dart';

class AppProviders {
  static List<BlocProvider> providers = [
    BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
    BlocProvider<LanguageBloc>(create: (_) => LanguageBloc()),
  ];
}
