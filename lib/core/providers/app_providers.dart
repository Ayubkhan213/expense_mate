import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/features/auth/domain/use_cases/get_current_login_user.dart';

class AppProviders {
  static List<BlocProvider> providers = [
    BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
    BlocProvider<LanguageBloc>(create: (_) => LanguageBloc()),
    BlocProvider<AuthBloc>(
      create: (_) =>
          AuthBloc(
              currencyRepository: CurrencyRepositoryImpl(
                localDataSource: CurrencyLocalDataSourceImpl(),
              ),
              checkAuthStatusUseCase: CheckAuthStatusUseCase(
                repository: AuthRepositoryImpl(
                  localDataSource: AuthLocalDataSourceImpl(),
                ),
              ),
              loginWithEmailUseCase: LoginWithEmailUseCase(
                repository: AuthRepositoryImpl(
                  localDataSource: AuthLocalDataSourceImpl(),
                ),
              ),
              loginWithPinUseCase: LoginWithPinUseCase(
                repository: AuthRepositoryImpl(
                  localDataSource: AuthLocalDataSourceImpl(),
                ),
              ),
              registerUseCase: RegisterUseCase(
                repository: AuthRepositoryImpl(
                  localDataSource: AuthLocalDataSourceImpl(),
                ),
              ),
              logoutUseCase: LogoutUseCase(
                repository: AuthRepositoryImpl(
                  localDataSource: AuthLocalDataSourceImpl(),
                ),
              ),
              changePasswordUseCase: ChangePasswordUseCase(
                repository: AuthRepositoryImpl(
                  localDataSource: AuthLocalDataSourceImpl(),
                ),
              ),
              getAllAccountsUseCase: GetAllAccountsUseCase(
                repository: AuthRepositoryImpl(
                  localDataSource: AuthLocalDataSourceImpl(),
                ),
              ),
              authRepository: AuthRepositoryImpl(
                localDataSource: AuthLocalDataSourceImpl(),
              ),
              getCurrentLoggedInUserUseCase: GetCurrentLoggedInUserUseCase(
                repository: AuthRepositoryImpl(
                  localDataSource: AuthLocalDataSourceImpl(),
                ),
              ),
            )
            ..add(LoadCurrenciesEvent())
            ..add(CheckAuthStatusEvent()),
    ),
    BlocProvider<AddRecordBloc>(
      create: (_) => AddRecordBloc(categoryRepository: CategoryRepositoryImp())
        ..add(FetchAllExpancesEvent())
        ..add(FetchAllIncomEvent()),
    ),
  ];
}
