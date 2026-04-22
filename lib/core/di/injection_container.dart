import 'package:spendio/core/data/data_sources/local/debt_local_datasource.dart';
import 'package:spendio/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:spendio/core/data/repository_imp/category_repository_imp.dart';
import 'package:spendio/core/data/repository_imp/debt_repository_imp.dart';
import 'package:spendio/core/data/repository_imp/transcation_repo_imp.dart';
import 'package:spendio/core/domain/repository/sql/category_repository.dart';
import 'package:spendio/core/domain/repository/sql/debt_repository.dart'
    show DebtRepository;
import 'package:spendio/core/domain/repository/sql/transcation_repository.dart';
import 'package:spendio/core/language/bloc/language_bloc.dart';
import 'package:spendio/core/theme/bloc/theme_bloc.dart';
import 'package:spendio/features/auth/data/data_source/auth_local_datasource.dart';
import 'package:spendio/features/auth/data/data_source/currency_local_datasource.dart';

import 'package:spendio/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:spendio/features/auth/data/repositories/currency_repository_imp.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/sql/currency_repository.dart';
import 'package:spendio/features/auth/domain/use_cases/change_password_usecase.dart';
import 'package:spendio/features/auth/domain/use_cases/check_auth_status_usecase.dart';
import 'package:spendio/features/auth/domain/use_cases/get_all_accounts_usecase.dart';
import 'package:spendio/features/auth/domain/use_cases/get_current_login_user.dart';
import 'package:spendio/features/auth/domain/use_cases/login_with_email_usecase.dart';
import 'package:spendio/features/auth/domain/use_cases/login_with_pin_usecase.dart';
import 'package:spendio/features/auth/domain/use_cases/logout_usecase.dart';
import 'package:spendio/features/auth/domain/use_cases/register_usecase.dart';
import 'package:spendio/features/budgets/data/data_source/sql/budget_local_datasource.dart';
import 'package:spendio/features/budgets/data/repository_imp/budget_repository_imp.dart';
import 'package:spendio/features/budgets/domain/repository/budget_repository.dart';
import 'package:spendio/features/budgets/domain/use_cases/create_budget_usecase.dart';
import 'package:spendio/features/budgets/domain/use_cases/delete_budget_usecase.dart';
import 'package:spendio/features/budgets/domain/use_cases/get_all_budgets_usecase.dart';
import 'package:spendio/features/budgets/domain/use_cases/update_budget_usecase.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget/budget_bloc.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_from/budget_form_bloc.dart';
import 'package:spendio/features/recurring/data/data_source/recurring_local_datasource.dart'
    as rec;

import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_bloc.dart';

import 'package:get_it/get_it.dart';

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

  // sl.registerFactory(
  //   () => AuthBloc(
  //     checkAuthStatusUseCase: sl(),
  //     loginWithEmailUseCase: sl(),
  //     loginWithPinUseCase: sl(),
  //     registerUseCase: sl(),
  //     logoutUseCase: sl(),
  //     changePasswordUseCase: sl(),
  //     getAllAccountsUseCase: sl(),
  //     getCurrentLoggedInUserUseCase: sl(),
  //     authRepository: sl(),
  //     currencyRepository: sl(),
  //   ),
  // );

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

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImp(localDataSource: sl()),
  );

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
