// lib/features/splah/presentation/bloc/splash_state.dart

import 'package:equatable/equatable.dart';
import 'package:spendio/core/data/models/currency_model.dart';
import 'package:spendio/core/data/models/user_sql_model.dart';
// import 'package:spendio/core/data/models/user_model.dart';

enum SplashStatus {
  checking,
  firstLaunch, // ← NEW: onboardingSeen == false
  authenticated,
  unauthenticated,
  loggingOut,
}

class SplashState extends Equatable {
  final SplashStatus status;
  final UserModel? currentUser;
  final List<CurrencyModel> currencies;
  final String selectedCurrency;
  final bool isLoadingCurrencies;

  const SplashState({
    this.status = SplashStatus.checking,
    this.currentUser,
    this.currencies = const [],
    this.selectedCurrency = 'USD',
    this.isLoadingCurrencies = false,
  });

  SplashState copyWith({
    SplashStatus? status,
    UserModel? currentUser,
    bool clearCurrentUser = false,
    List<CurrencyModel>? currencies,
    String? selectedCurrency,
    bool? isLoadingCurrencies,
  }) {
    return SplashState(
      status: status ?? this.status,
      currentUser: clearCurrentUser ? null : (currentUser ?? this.currentUser),
      currencies: currencies ?? this.currencies,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isLoadingCurrencies: isLoadingCurrencies ?? this.isLoadingCurrencies,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentUser,
    currencies,
    selectedCurrency,
    isLoadingCurrencies,
  ];
}
