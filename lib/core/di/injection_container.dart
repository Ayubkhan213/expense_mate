import 'package:expense_mate/features/budgets/data/data_source/budget_local_data_source.dart';
import 'package:expense_mate/features/budgets/data/repository_imp/budget_repository_imp.dart';
import 'package:expense_mate/features/budgets/domain/repository/budget_repository.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/create_budget_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/delete_budget_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/get_all_budgets_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/update_budget_usecase.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_bloc.dart';
import 'package:expense_mate/features/recurring/data/data_source/recurring_local_data_source.dart'
    as rec;
import 'package:get_it/get_it.dart';

// ================= CORE =================
import 'package:expense_mate/core/theme/bloc/theme_bloc.dart';
import 'package:expense_mate/core/language/bloc/language_bloc.dart';

// ================= AUTH =================
import 'package:expense_mate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_mate/features/auth/data/data_source/auth_data_source.dart';
import 'package:expense_mate/features/auth/data/data_source/currency_data_source.dart';
import 'package:expense_mate/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:expense_mate/features/auth/data/repositories/currency_repository_imp.dart';
import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';
import 'package:expense_mate/features/auth/domain/repository/currency_repository.dart';
import 'package:expense_mate/features/auth/domain/use_cases/change_password_usecase.dart';
import 'package:expense_mate/features/auth/domain/use_cases/check_auth_status_usecase.dart';
import 'package:expense_mate/features/auth/domain/use_cases/get_all_accounts_usecase.dart';
import 'package:expense_mate/features/auth/domain/use_cases/get_current_login_user.dart';
import 'package:expense_mate/features/auth/domain/use_cases/login_with_email_usecase.dart';
import 'package:expense_mate/features/auth/domain/use_cases/login_with_pin_usecase.dart';
import 'package:expense_mate/features/auth/domain/use_cases/logout_usecase.dart';
import 'package:expense_mate/features/auth/domain/use_cases/register_usecase.dart';

// ================= TRANSACTION =================
import 'package:expense_mate/features/transcation/presentation/bloc/transcation_bloc/transcation_bloc.dart';
import 'package:expense_mate/features/transcation/domain/use_cases/create_budget_transcation.dart';
import 'package:expense_mate/features/transcation/domain/use_cases/create_debt_transcation.dart';
import 'package:expense_mate/features/transcation/domain/use_cases/create_normal_transcation.dart';
import 'package:expense_mate/features/transcation/domain/use_cases/create_recurring_transcation.dart';

// ================= DATA SOURCES =================
import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/budget_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/debt_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/recurring_local_data_source.dart'
    as rec;

// ================= REPOSITORIES =================
import 'package:expense_mate/core/data/repository_imp/transcation_repository.dart';
// import 'package:expense_mate/core/data/repository_imp/budget_repository.dart';
import 'package:expense_mate/core/data/repository_imp/debt_repository.dart';
import 'package:expense_mate/core/data/repository_imp/recurring_repository.dart';
import 'package:expense_mate/core/data/repository_imp/category_repository_imp.dart';

import 'package:expense_mate/core/domain/repository/transcation_repository.dart';
// import 'package:expense_mate/core/domain/repository/budget_repository.dart';
import 'package:expense_mate/core/domain/repository/debt_repository.dart';
import 'package:expense_mate/core/domain/repository/recurrin_repository.dart';
import 'package:expense_mate/core/domain/repository/category_repository.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ================= BLOCS =================
  sl.registerFactory(() => ThemeBloc());
  sl.registerFactory(() => LanguageBloc());
  sl.registerFactory(
    () => BudgetBloc(
      getAllBudgetsUseCase: sl(),
      createBudgetUseCase: sl(),
      updateBudgetUseCase: sl(),
      deleteBudgetUseCase: sl(),
    ),
  );
  sl.registerFactory(() => BudgetFormBloc());

  sl.registerFactory(
    () => AuthBloc(
      checkAuthStatusUseCase: sl(),
      loginWithEmailUseCase: sl(),
      loginWithPinUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      changePasswordUseCase: sl(),
      getAllAccountsUseCase: sl(),
      getCurrentLoggedInUserUseCase: sl(),
      authRepository: sl(),
      currencyRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => TranscationBloc(
      categoryRepository: sl(),
      // createNormalTransaction: sl(),
      // createDebtTransaction: sl(),
      // createBudgetTransaction: sl(),
      // processDueRecurring: sl(),
    ),
  );

  // ================= AUTH USE CASES =================
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginWithEmailUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginWithPinUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllAccountsUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetCurrentLoggedInUserUseCase(repository: sl()),
  );

  // ================= TRANSACTION USE CASES =================
  // sl.registerLazySingleton(() => CreateNormalTransaction(repository: sl()));

  // sl.registerLazySingleton(
  //   () => CreateDebtTransaction(
  //     transactionRepository: sl(),
  //     debtRepository: sl(),
  //   ),
  // );

  // sl.registerLazySingleton(
  //   () => CreateBudgetTransaction(
  //     transactionRepository: sl(),
  //     budgetRepository: sl(),
  //   ),
  // );

  // sl.registerLazySingleton(
  //   () => ProcessDueRecurring(
  //     recurringRepository: sl(),
  //     createNormalTransaction: sl(),
  //   ),
  // );

  // ================= Budget USE CASES =================
  sl.registerSingleton(() => GetAllBudgetsUseCase(repository: sl()));
  sl.registerSingleton(() => CreateBudgetUseCase(repository: sl()));
  sl.registerSingleton(() => UpdateBudgetUseCase(repository: sl()));
  sl.registerSingleton(() => DeleteBudgetUseCase(repository: sl()));

  // ================= REPOSITORIES =================

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImp(localDataSource: sl()),
  );

  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImp(localDataSource: sl()),
  );

  sl.registerLazySingleton<DebtRepository>(
    () => DebtRepositoryImp(localDataSource: sl()),
  );

  // sl.registerLazySingleton<RecurringRepositories>(
  //   () => RecurringRepositoryImp(localDataSource: sl()),
  // );

  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImp());

  // ================= DATA SOURCES =================
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<CurrencyLocalDataSource>(
    () => CurrencyLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<DebtLocalDataSource>(
    () => DebtLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<rec.RecurringLocalDataSource>(
    () => rec.RecurringLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<BudgetLocalDataSource>(
    () => BudgetLocalDataSourceImpl(),
  );
}
