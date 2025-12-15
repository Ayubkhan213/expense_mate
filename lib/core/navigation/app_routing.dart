import 'package:expense_mate/core/app_export.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => const MainFrame());

      case 'template':
        return MaterialPageRoute(builder: (_) => const TemplateFace());
      case 'language':
        return MaterialPageRoute(builder: (_) => const LanguageFace());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route not found"))),
        );
    }
  }
}
