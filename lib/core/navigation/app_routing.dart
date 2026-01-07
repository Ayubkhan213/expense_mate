import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/features/add_record/presentation/faces/add_recort_face.dart';
import 'package:expense_mate/features/auth/presentation/faces/login_face.dart';
import 'package:expense_mate/features/auth/presentation/faces/signup_face.dart';
import 'package:expense_mate/features/splah/presentation/faces/splash_face.dart';
import 'package:expense_mate/navigation_fram.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => const MainFrame());

      case 'template':
        return MaterialPageRoute(builder: (_) => const TemplateFace());
      case 'language':
        return MaterialPageRoute(builder: (_) => const LanguageFace());
      case 'add_record':
        return MaterialPageRoute(builder: (_) => const AddRecordFace());
      case 'splash':
        return MaterialPageRoute(builder: (_) => const SplashFace());
      case 'login':
        return MaterialPageRoute(builder: (_) => const LoginFace());
      case 'signup':
        return MaterialPageRoute(builder: (_) => const SignupFace());
      case 'forget_password':
        return MaterialPageRoute(builder: (_) => const SplashFace());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route not found"))),
        );
    }
  }
}
