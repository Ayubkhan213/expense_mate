// // lib/features/auth/presentation/bloc/auth_state.dart
// import 'package:equatable/equatable.dart';
// import 'package:spendio/core/data/models/currency_model.dart';
// import '../../../../core/data/models/user_model.dart';

// enum AuthStatus {
//   initial,
//   loading,
//   authenticated,
//   unauthenticated,
//   error,
//   passwordResetEmailSent,
//   passwordResetSuccess,
//   signUpSuccess,
// }

// class AuthState extends Equatable {
//   final AuthStatus status;
//   final UserModel? user;
//   final List<UserModel>? quickLoginUsers;
//   final String? errorMessage;
//   final String? email;
//   final bool isQuickLogin;
//   final bool isAnimating;
//   final bool obscurePassword;
//   final bool obscureConfirmPassword;
//   final String selectedCurrency;
//   final List<CurrencyModel> currencies;
//   final bool isLoadingCurrencies;
//   final String enteredPin;

//   const AuthState({
//     this.status = AuthStatus.initial,
//     this.user,
//     this.quickLoginUsers,
//     this.errorMessage,
//     this.email,
//     this.isQuickLogin = false,
//     this.isAnimating = false,
//     this.obscurePassword = true,
//     this.obscureConfirmPassword = true,
//     this.selectedCurrency = 'USD',
//     this.currencies = const [],
//     this.isLoadingCurrencies = false,
//     this.enteredPin = '',
//     // keep your existing fields
//   });

//   // CopyWith method
//   AuthState copyWith({
//     AuthStatus? status,
//     UserModel? user,
//     List<UserModel>? quickLoginUsers,
//     String? errorMessage,
//     String? email,
//     bool? isQuickLogin,
//     bool? isAnimating,
//     bool? obscurePassword,
//     bool? obscureConfirmPassword,
//     String? selectedCurrency,
//     List<CurrencyModel>? currencies,
//     bool? isLoadingCurrencies,
//     String? enteredPin,
//   }) {
//     return AuthState(
//       status: status ?? this.status,
//       user: user ?? this.user,
//       quickLoginUsers: quickLoginUsers ?? this.quickLoginUsers,
//       errorMessage: errorMessage,
//       email: email,
//       isQuickLogin: isQuickLogin ?? this.isQuickLogin,
//       isAnimating: isAnimating ?? this.isAnimating,
//       obscurePassword: obscurePassword ?? this.obscurePassword,
//       obscureConfirmPassword:
//           obscureConfirmPassword ?? this.obscureConfirmPassword,
//       selectedCurrency: selectedCurrency ?? this.selectedCurrency,
//       currencies: currencies ?? this.currencies,
//       isLoadingCurrencies: isLoadingCurrencies ?? this.isLoadingCurrencies,
//       enteredPin: enteredPin ?? this.enteredPin,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     status,
//     user,
//     quickLoginUsers,
//     errorMessage,
//     email,
//     isQuickLogin,
//     isAnimating,
//     currencies,
//     selectedCurrency,
//     isLoadingCurrencies,
//     enteredPin,
//   ];
// }
