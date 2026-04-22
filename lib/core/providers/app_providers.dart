import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendio/core/data/data_sources/local/category_local_datasource.dart';
import 'package:spendio/core/data/data_sources/local/debt_local_datasource.dart';
import 'package:spendio/core/data/data_sources/local/transcation_local_data_source.dart';

import 'package:spendio/core/data/repository_imp/category_repository_imp.dart';

import 'package:spendio/core/di/injection_container.dart';
import 'package:spendio/core/language/bloc/language_bloc.dart';
import 'package:spendio/core/theme/bloc/theme_bloc.dart';

import 'package:spendio/features/analytics/data/repository_impl/analytics_repository_impl.dart';
import 'package:spendio/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:spendio/features/auth/data/data_source/auth_local_datasource.dart';
import 'package:spendio/features/auth/data/data_source/currency_local_datasource.dart';

import 'package:spendio/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:spendio/features/auth/data/repositories/currency_repository_imp.dart';
import 'package:spendio/features/auth/domain/use_cases/logout_usecase.dart';
import 'package:spendio/features/auth/domain/use_cases/register_usecase.dart';
import 'package:spendio/features/auth/domain/use_cases/update_profile_usecase.dart';
import 'package:spendio/features/auth/presentation/bloc/forget_password_bloc/forget_password_bloc.dart';
import 'package:spendio/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:spendio/features/auth/presentation/bloc/signup_bloc/signup_bloc.dart';
import 'package:spendio/features/budgets/data/data_source/sql/budget_local_datasource.dart';
import 'package:spendio/features/budgets/data/repository_imp/budget_repository_imp.dart';

import 'package:spendio/features/budgets/domain/use_cases/create_budget_usecase.dart';
import 'package:spendio/features/budgets/domain/use_cases/delete_budget_usecase.dart';
import 'package:spendio/features/budgets/domain/use_cases/get_all_budgets_usecase.dart';
import 'package:spendio/features/budgets/domain/use_cases/get_budget_detail_usease.dart';

import 'package:spendio/features/budgets/domain/use_cases/update_budget_usecase.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget/budget_bloc.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_detail/budget_detail_bloc.dart';
import 'package:spendio/features/home/data/data_source/home_data_source.dart';
import 'package:spendio/features/home/data/repository_impl/home_repository_imp.dart';
import 'package:spendio/features/home/domain/usecases/get_debtpayment_by_debtid_usecase.dart';
import 'package:spendio/features/home/presentation/bloc/all_debt_bloc/all_debt_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/all_debt_bloc/all_debt_event.dart';
import 'package:spendio/features/home/presentation/bloc/all_transcation_bloc/all_transcation_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/all_transcation_bloc/all_transcation_event.dart';
import 'package:spendio/features/home/presentation/bloc/debt_repay/debt_repay_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:spendio/features/home/presentation/bloc/home_bloc/home_event.dart';
import 'package:spendio/features/profile/presentation/bloc/notification/notification_bloc.dart';
import 'package:spendio/features/profile/presentation/bloc/notification/notification_event.dart';
import 'package:spendio/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:spendio/features/profile/presentation/bloc/profile_event.dart';
import 'package:spendio/features/recurring/data/data_source/recurring_local_datasource.dart';

import 'package:spendio/features/recurring/data/repositort_imp/recurring_repo_impl.dart';
import 'package:spendio/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';

import 'package:spendio/features/recurring/presentation/bloc/recurring/recurring_bloc.dart';
import 'package:spendio/features/recurring/presentation/bloc/recurring/recurring_list_event.dart';
import 'package:spendio/features/splah/presentation/bloc/splash_bloc.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_bloc.dart';
import 'package:spendio/features/transcation/presentation/bloc/transcation_bloc/transcation_event.dart';

class AppProviders {
  static List<BlocProvider> providers = [
    // Just get the instances from GetIt - no manual creation!
    BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),
    BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(
        homeRepo: HomeRepositoryImp(
          homeDatasource: HomeDatasourceImpl(),
          localDataSource: TransactionLocalDataSourceImpl(),
          debtDataSource: DebtLocalDataSourceImpl(),
        ),
      )..add(RefreshHomeData()),
    ),
    BlocProvider<LanguageBloc>(create: (_) => sl<LanguageBloc>()),
    // BlocProvider<AuthBloc>(
    //   create: (_) => sl<AuthBloc>()
    //     ..add(LoadCurrenciesEvent())
    //     ..add(CheckAuthStatusEvent()),
    // ),
    BlocProvider<TranscationBloc>(
      create: (_) =>
          TranscationBloc(
              categoryRepository: CategoryRepositoryImp(
                localDataSource: CategoryLocalDataSourceImpl(),
              ),
            )
            ..add(FetchAllExpancesEvent())
            ..add(FetchAllIncomEvent()),
    ),
    BlocProvider<BudgetBloc>(
      create: (_) => BudgetBloc(
        getAllBudgetsUseCase: GetAllBudgetsUseCase(
          repository: BudgetRepositoryImp(
            localDataSource: BudgetLocalDataSourceImpl(),
          ),
        ),
        createBudgetUseCase: CreateBudgetUseCase(
          repository: BudgetRepositoryImp(
            localDataSource: BudgetLocalDataSourceImpl(),
          ),
        ),
        updateBudgetUseCase: UpdateBudgetUseCase(
          repository: BudgetRepositoryImp(
            localDataSource: BudgetLocalDataSourceImpl(),
          ),
        ),
        deleteBudgetUseCase: DeleteBudgetUseCase(
          repository: BudgetRepositoryImp(
            localDataSource: BudgetLocalDataSourceImpl(),
          ),
        ),
      ),
    ),
    BlocProvider<BudgetDetailsBloc>(
      create: (_) => BudgetDetailsBloc(
        getBudgetDetailsUseCase: GetBudgetDetailsUseCase(
          BudgetRepositoryImp(localDataSource: BudgetLocalDataSourceImpl()),
        ),
      ),
    ),
    BlocProvider<DebtRepaymentBloc>(
      create: (context) => DebtRepaymentBloc(
        getDebtPaymentsByDebtIdUseCase: GetDebtPaymentsByDebtIdUseCase(
          repository: HomeRepositoryImp(
            homeDatasource: HomeDatasourceImpl(),
            localDataSource: TransactionLocalDataSourceImpl(),
            debtDataSource: DebtLocalDataSourceImpl(),
          ),
        ),
      ),
    ),
    BlocProvider<RecurringListBloc>(
      create: (context) => RecurringListBloc(
        repository: RecurringRepositoryImpl(
          localDataSource: RecurringLocalDataSourceImpl(),
          transactionDataSource: TransactionLocalDataSourceImpl(),
        ),
      )..add(LoadRecurringList()),
    ),

    BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(
        transactionDataSource: TransactionLocalDataSourceImpl(), // ← add
        budgetDataSource: BudgetLocalDataSourceImpl(),
        authRepository: AuthRepositoryImpl(
          localDataSource: AuthLocalDataSourceImpl(),
        ),
        logoutUseCase: LogoutUseCase(
          repository: AuthRepositoryImpl(
            localDataSource: AuthLocalDataSourceImpl(),
          ),
        ),
        splashBloc: SplashBloc(
          authRepository: AuthRepositoryImpl(
            localDataSource: AuthLocalDataSourceImpl(),
          ),
          currencyRepository: CurrencyRepositoryImpl(
            localDataSource: CurrencyLocalDataSourceImpl(),
          ),
        ),
        updateProfileUseCase: UpdateProfileUseCase(
          repository: AuthRepositoryImpl(
            localDataSource: AuthLocalDataSourceImpl(),
          ),
        ),
      )..add(LoadProfile()),
    ),

    BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(
        transactionDataSource: TransactionLocalDataSourceImpl(), // ← add
        budgetDataSource: BudgetLocalDataSourceImpl(),
        authRepository: AuthRepositoryImpl(
          localDataSource: AuthLocalDataSourceImpl(),
        ),
        logoutUseCase: LogoutUseCase(
          repository: AuthRepositoryImpl(
            localDataSource: AuthLocalDataSourceImpl(),
          ),
        ),
        splashBloc: SplashBloc(
          authRepository: AuthRepositoryImpl(
            localDataSource: AuthLocalDataSourceImpl(),
          ),
          currencyRepository: CurrencyRepositoryImpl(
            localDataSource: CurrencyLocalDataSourceImpl(),
          ),
        ),
        updateProfileUseCase: UpdateProfileUseCase(
          repository: AuthRepositoryImpl(
            localDataSource: AuthLocalDataSourceImpl(),
          ),
        ),
      )..add(LoadProfile()),
    ),
    BlocProvider<SplashBloc>(
      create: (_) => SplashBloc(
        authRepository: AuthRepositoryImpl(
          localDataSource: AuthLocalDataSourceImpl(),
        ),
        currencyRepository: CurrencyRepositoryImpl(
          localDataSource: CurrencyLocalDataSourceImpl(),
        ),
      ),
    ),
    BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(
        authRepository: AuthRepositoryImpl(
          localDataSource: AuthLocalDataSourceImpl(),
        ),
      ),
    ),
    BlocProvider<SignupBloc>(
      create: (_) => SignupBloc(
        registerUseCase: RegisterUseCase(
          repository: AuthRepositoryImpl(
            localDataSource: AuthLocalDataSourceImpl(),
          ),
        ),
        authRepository: AuthRepositoryImpl(
          localDataSource: AuthLocalDataSourceImpl(),
        ),
        currencyRepository: CurrencyRepositoryImpl(
          localDataSource: CurrencyLocalDataSourceImpl(),
        ),
      ),
    ),

    BlocProvider<ForgotPasswordBloc>(
      create: (_) => ForgotPasswordBloc(
        authRepository: AuthRepositoryImpl(
          localDataSource: AuthLocalDataSourceImpl(),
        ),
      ),
    ),

    BlocProvider<AnalyticsBloc>(
      create: (context) => AnalyticsBloc(repository: AnalyticsRepositoryImpl()),
    ),
    BlocProvider<AddEditRecurringBloc>(
      create: (context) => AddEditRecurringBloc(
        repository: RecurringRepositoryImpl(
          localDataSource: RecurringLocalDataSourceImpl(),
          transactionDataSource: TransactionLocalDataSourceImpl(),
        ),
      ),
    ),

    BlocProvider<NotificationBloc>(
      create: (_) => NotificationBloc()
        ..add(LoadNotificationSettings())
        ..add(LoadAllSchedules()),
    ),

    BlocProvider<AllTransactionsBloc>(
      create: (_) => AllTransactionsBloc(
        repository: HomeRepositoryImp(
          homeDatasource: HomeDatasourceImpl(),
          localDataSource: TransactionLocalDataSourceImpl(),
          debtDataSource: DebtLocalDataSourceImpl(),
        ),
      )..add(LoadAllTransactions()),
    ),
    BlocProvider<AllDebtTransactionsBloc>(
      create: (_) => AllDebtTransactionsBloc(
        repository: HomeRepositoryImp(
          homeDatasource: HomeDatasourceImpl(),
          localDataSource: TransactionLocalDataSourceImpl(),
          debtDataSource: DebtLocalDataSourceImpl(),
        ),
      )..add(LoadAllDebtTransactions()),
    ),
  ];
}

// Aslam Khan
// A Money give from aslam
