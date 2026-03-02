import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/utils/enum.dart';
import 'package:expense_mate/features/budgets/presentation/faces/budget_details.dart';

import 'package:expense_mate/features/home/presentation/faces/all_debt_face.dart';
import 'package:expense_mate/features/home/presentation/faces/all_transcation_face.dart';
import 'package:expense_mate/features/home/presentation/faces/debt_transcation_repay_face.dart';
import 'package:expense_mate/features/on_boarding/on_boarding_screen.dart';
import 'package:expense_mate/features/transcation/presentation/faces/category_selection.dart';

import 'package:expense_mate/features/auth/presentation/faces/login_face.dart';
import 'package:expense_mate/features/auth/presentation/faces/signup_face.dart';
import 'package:expense_mate/features/splah/presentation/faces/splash_face.dart';
import 'package:expense_mate/navigation_fram.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => MainFrame());

      case 'template':
        return MaterialPageRoute(builder: (_) => const TemplateFace());
      case 'language':
        return MaterialPageRoute(builder: (_) => const LanguageFace());
      case 'add_record':
        final args = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => CategorySelector(
            flowType:
                args?['flowType'] as TransactionSource? ??
                TransactionSource.normal,
            budgetModel: args?['budget'] as BudgetModel?,
          ),
        );

      case 'splash':
        return MaterialPageRoute(builder: (_) => const SplashFace());
      case 'login':
        return MaterialPageRoute(builder: (_) => const LoginFace());
      case 'signup':
        return MaterialPageRoute(builder: (_) => const SignupFace());
      case 'forget_password':
        return MaterialPageRoute(builder: (_) => const SplashFace());
      case 'budget_details':
        final args = settings.arguments as Map<String, dynamic>?;
        final BudgetModel budget = args?['budget'] ?? '';

        return MaterialPageRoute(
          builder: (_) => BudgetDetailsFace(budget: budget),
        );
      case 'on_boarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case 'debt_repayment':
        final args = settings.arguments as Map<String, dynamic>?;
        final DebtModel debtModel = args?['debt'] ?? '';
        return MaterialPageRoute(
          builder: (_) => DebtTransactionRepayFace(debtModel: debtModel),
        );
      case 'all_transcation':
        return MaterialPageRoute(builder: (_) => AllTransactionsFace());
      case 'all_debt_transcation':
        return MaterialPageRoute(builder: (_) => AllDebtTransactionsFace());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route not found"))),
        );
    }
  }
}
