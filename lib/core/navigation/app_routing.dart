import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/debt_sql_model.dart';
import 'package:spendio/core/di/injection_container.dart';

import 'package:spendio/core/utils/enum.dart';
import 'package:spendio/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:spendio/features/auth/presentation/faces/forget_face.dart';
import 'package:spendio/features/budgets/presentation/faces/budget_details.dart';

import 'package:spendio/features/home/presentation/faces/all_debt_face.dart';
import 'package:spendio/features/home/presentation/faces/all_transcation_face.dart';
import 'package:spendio/features/home/presentation/faces/debt_transcation_repay_face.dart';
import 'package:spendio/features/on_boarding/on_boarding_screen.dart';
import 'package:spendio/features/profile/presentation/faces/language_face.dart';
import 'package:spendio/features/profile/presentation/faces/template_face.dart';
import 'package:spendio/features/transcation/presentation/faces/category_selection.dart';

import 'package:spendio/features/auth/presentation/faces/login_face.dart';
import 'package:spendio/features/auth/presentation/faces/signup_face.dart';
import 'package:spendio/features/splah/presentation/faces/splash_face.dart';
import 'package:spendio/navigation_fram.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => MainFrame());

      case 'template':
        return MaterialPageRoute(builder: (_) => const TemplateFace());
      case 'language':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LanguageFace(
            isFirstLaunch: args?['isFirstLaunch'] as bool? ?? false,
          ),
        );
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
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (ctx) =>
                LoginBloc(authRepository: sl())..add(LoginLoadAccount()),
            child: const LoginFace(),
          ),
        );
      case 'signup':
        return MaterialPageRoute(builder: (_) => const SignupFace());
      case 'forget_password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordFace());
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
      case 'forgot_password':
        return MaterialPageRoute(builder: (_) => ForgotPasswordFace());
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
