import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/data_sources/local/budget_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/debt_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/recurring_local_data_source.dart';
import 'package:expense_mate/core/data/data_sources/local/transcation_local_data_source.dart';
import 'package:expense_mate/core/data/repository_imp/debt_repository.dart';
import 'package:expense_mate/core/data/repository_imp/transcation_repository.dart';
import 'package:expense_mate/core/di/injection_container.dart';
import 'package:expense_mate/core/services/hive_box_manager.dart';
import 'package:expense_mate/features/analytics/data/repository_impl/analytics_repository_impl.dart';
import 'package:expense_mate/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:expense_mate/features/budgets/data/data_source/budget_local_data_source.dart';
import 'package:expense_mate/features/budgets/data/repository_imp/budget_repository_imp.dart'
    show BudgetRepositoryImp;
import 'package:expense_mate/features/budgets/domain/use_cases/create_budget_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/delete_budget_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/get_all_budgets_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/get_budget_detail_usease.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/get_transactions_by_budget_usecase.dart';
import 'package:expense_mate/features/budgets/domain/use_cases/update_budget_usecase.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail/budget_detail_bloc.dart';
import 'package:expense_mate/features/home/data/data_source/home_datasource.dart';
import 'package:expense_mate/features/home/data/repository_impl/home_repository_imp.dart';
import 'package:expense_mate/features/home/domain/usecases/get_debtpayment_by_debtid_usecase.dart';
import 'package:expense_mate/features/home/presentation/bloc/debt_repay/debt_repay_bloc.dart';
import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:expense_mate/features/home/presentation/bloc/home_bloc/home_event.dart';
import 'package:expense_mate/features/profile/presentation/bloc/notification/notification_bloc.dart';
import 'package:expense_mate/features/profile/presentation/bloc/notification/notification_event.dart';
import 'package:expense_mate/features/recurring/data/data_source/recurring_local_data_source.dart';
import 'package:expense_mate/features/recurring/data/repositort_imp/recurring_repo_impl.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';

import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_list_event.dart';

class AppProviders {
  static List<BlocProvider> providers = [
    // Just get the instances from GetIt - no manual creation!
    BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),
    BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(
        transactionRepo: TransactionRepositoryImp(
          localDataSource: TransactionLocalDataSourceImpl(),
        ),
        debtRepo: DebtRepositoryImp(localDataSource: DebtLocalDataSourceImpl()),
      )..add(RefreshHomeData()),
    ),
    BlocProvider<LanguageBloc>(create: (_) => sl<LanguageBloc>()),
    BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()
        ..add(LoadCurrenciesEvent())
        ..add(CheckAuthStatusEvent()),
    ),
    BlocProvider<TranscationBloc>(
      create: (_) => sl<TranscationBloc>()
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
          repository: HomeRepositoryImp(homeDatasource: HomeDatasourceImp()),
        ),
      ),
    ),
    BlocProvider<RecurringListBloc>(
      create: (context) => RecurringListBloc(
        repository: RecurringRepositoryImpl(
          localDataSource: RecurringLocalDataSourceImpl(),
        ),
      )..add(LoadRecurringList()),
    ),
    // BlocProvider<AnalyticsBloc>(
    //   create: (context) => AnalyticsBloc(
    //     repository: AnalyticsRepositoryImpl(
    //       transactionBox: null,
    //       budgetBox: null,
    //       debtBox: null,
    //     ),
    //   ),
    // ),
    BlocProvider<AnalyticsBloc>(
      create: (context) => AnalyticsBloc(
        repository: AnalyticsRepositoryImpl(
          transactionBox: HiveBoxManager.transactions,
          budgetBox: HiveBoxManager.budgets,
          debtBox: HiveBoxManager.debts,
          categoryBox: HiveBoxManager.categories,
        ),
      ),
    ),
    BlocProvider<AddEditRecurringBloc>(
      create: (context) => AddEditRecurringBloc(
        repository: RecurringRepositoryImpl(
          localDataSource: RecurringLocalDataSourceImpl(),
        ),
      ),
    ),

    BlocProvider<NotificationBloc>(
      create: (_) => NotificationBloc()
        ..add(LoadNotificationSettings())
        ..add(LoadAllSchedules()),
    ),
  ];
}

// Aslam Khan
// A Money give from aslam
