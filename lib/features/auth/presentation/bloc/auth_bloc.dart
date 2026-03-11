// // lib/features/auth/presentation/bloc/auth_bloc.dart
// import 'package:expense_mate/core/app_export.dart';
// import 'package:expense_mate/core/services/app_prefs.dart';
// import 'package:expense_mate/features/auth/domain/repository/currency_repository.dart';
// import 'package:expense_mate/features/auth/domain/use_cases/get_current_login_user.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final CheckAuthStatusUseCase checkAuthStatusUseCase;
//   final LoginWithEmailUseCase loginWithEmailUseCase;
//   final LoginWithPinUseCase loginWithPinUseCase;
//   final RegisterUseCase registerUseCase;
//   final LogoutUseCase logoutUseCase;
//   final ChangePasswordUseCase changePasswordUseCase;
//   final GetAllAccountsUseCase getAllAccountsUseCase;
//   final AuthRepository authRepository;
//   final CurrencyRepository currencyRepository;
//   final GetCurrentLoggedInUserUseCase getCurrentLoggedInUserUseCase;
//   AuthBloc({
//     required this.checkAuthStatusUseCase,
//     required this.loginWithEmailUseCase,
//     required this.loginWithPinUseCase,
//     required this.registerUseCase,
//     required this.logoutUseCase,
//     required this.changePasswordUseCase,
//     required this.getAllAccountsUseCase,
//     required this.authRepository,
//     required this.currencyRepository,
//     required this.getCurrentLoggedInUserUseCase,
//   }) : super(const AuthState()) {
//     on<CheckAuthStatusEvent>(_onCheckAuthStatus);
//     on<LoginWithEmailEvent>(_onLoginWithEmail);
//     on<QuickLoginWithPinEvent>(_onQuickLoginWithPin);
//     on<BiometricLoginEvent>(_onBiometricLogin);
//     on<SignUpEvent>(_onSignUp);
//     on<ForgotPasswordEvent>(_onForgotPassword);
//     on<ResetPasswordEvent>(_onResetPassword);
//     on<LogoutEvent>(_onLogout);
//     on<ToggleLoginModeEvent>(_onToggleLoginMode);
//     on<SetAnimatingEvent>(_onSetAnimating);
//     on<GetCurrentUserEvent>(_onGetCurrentUser);
//     on<PinCompleteEvent>(_onPinComplete);

//     on<TogglePasswordVisibility>((event, emit) {
//       emit(state.copyWith(obscurePassword: !state.obscurePassword));
//     });

//     on<ToggleConfirmPasswordVisibility>((event, emit) {
//       emit(
//         state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword),
//       );
//     });
//     on<LoadCurrenciesEvent>(_onLoadCurrencies);

//     on<ChangeCurrencyEvent>((event, emit) {
//       emit(state.copyWith(selectedCurrency: event.currencyCode));
//     });
//     on<PinDigitEnteredEvent>(_onPinDigitEntered);

//     on<PinDigitDeletedEvent>(_onPinDigitDeleted);

//     on<ClearPinEvent>((event, emit) {
//       emit(state.copyWith(enteredPin: ''));
//     });
//   }
//   Future<void> _onPinDigitEntered(
//     PinDigitEnteredEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     if (state.enteredPin.length >= 4) return;

//     final updatedPin = state.enteredPin + event.digit;

//     emit(state.copyWith(enteredPin: updatedPin));

//     // AUTO LOGIN WHEN PIN COMPLETE
//     if (updatedPin.length == 4) {
//       add(QuickLoginWithPinEvent(pin: updatedPin));
//     }
//   }

//   Future<void> _onPinComplete(
//     PinCompleteEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));

//     try {
//       final user = state.user;
//       if (user == null) throw Exception("User not found");

//       if (event.pin == user.pin) {
//         //  SUCCESS
//         emit(
//           state.copyWith(
//             status: AuthStatus.authenticated,
//             enteredPin: '',
//             errorMessage: null,
//           ),
//         );
//       } else {
//         //  WRONG PIN
//         emit(
//           state.copyWith(
//             status: AuthStatus.error,
//             enteredPin: '',
//             errorMessage: 'Incorrect PIN',
//           ),
//         );
//       }
//     } catch (e) {
//       emit(
//         state.copyWith(
//           status: AuthStatus.error,
//           enteredPin: '',
//           errorMessage: e.toString().replaceAll('Exception: ', ''),
//         ),
//       );
//     }
//   }

//   void _onPinDigitDeleted(PinDigitDeletedEvent event, Emitter<AuthState> emit) {
//     if (state.enteredPin.isEmpty) return;

//     emit(
//       state.copyWith(
//         enteredPin: state.enteredPin.substring(0, state.enteredPin.length - 1),
//       ),
//     );
//   }

//   Future<void> _onLoadCurrencies(
//     LoadCurrenciesEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(isLoadingCurrencies: true));

//     final currencies = await currencyRepository.getAllCurrencies();

//     emit(
//       state.copyWith(
//         currencies: currencies,
//         selectedCurrency: currencies.isNotEmpty ? currencies.first.code : 'USD',
//         isLoadingCurrencies: false,
//       ),
//     );
//   }

//   void _onToggleLoginMode(ToggleLoginModeEvent event, Emitter<AuthState> emit) {
//     if (state.isAnimating) return;

//     emit(state.copyWith(isAnimating: true, isQuickLogin: !state.isQuickLogin));
//   }

//   void _onSetAnimating(SetAnimatingEvent event, Emitter<AuthState> emit) {
//     emit(state.copyWith(isAnimating: event.isAnimating));
//   }

//   Future<void> _onCheckAuthStatus(
//     CheckAuthStatusEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     try {
//       final result = await checkAuthStatusUseCase();

//       if (result.isAuthenticated && result.user != null) {
//         emit(
//           state.copyWith(
//             status: AuthStatus.authenticated,
//             user: result.user,
//             errorMessage: null,
//           ),
//         );
//       } else {
//         emit(
//           state.copyWith(
//             status: AuthStatus.unauthenticated,
//             user: null,
//             quickLoginUsers: result.quickLoginUsers,
//           ),
//         );
//       }
//     } catch (_) {
//       emit(state.copyWith(status: AuthStatus.unauthenticated));
//     }
//   }

//   Future<void> _onLoginWithEmail(
//     LoginWithEmailEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

//     try {
//       final user = await loginWithEmailUseCase(event.email, event.password);

//       if (user == null) {
//         throw Exception('Invalid email or password');
//       }

//       emit(
//         state.copyWith(
//           status: AuthStatus.authenticated,
//           user: user,
//           errorMessage: null,
//         ),
//       );
//     } catch (e) {
//       await _emitErrorAndFallback(
//         emit,
//         e.toString().replaceAll('Exception: ', ''),
//       );
//     }
//   }

//   Future<void> _onQuickLoginWithPin(
//     QuickLoginWithPinEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));

//     try {
//       final user = await loginWithPinUseCase(event.pin);

//       if (user == null) {
//         throw Exception('Invalid PIN');
//       }

//       emit(
//         state.copyWith(
//           status: AuthStatus.authenticated,
//           user: user,
//           enteredPin: '',
//         ),
//       );
//     } catch (e) {
//       emit(
//         state.copyWith(
//           status: AuthStatus.unauthenticated,
//           enteredPin: '', //
//           errorMessage: e.toString().replaceAll('Exception: ', ''),
//         ),
//       );
//     }
//   }

//   Future<void> _onBiometricLogin(
//     BiometricLoginEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     // emit(AuthState.loading());

//     // Implement biometric authentication when needed
//     // try {
//     //   final canAuthenticate = await _localAuth.canCheckBiometrics;
//     //   if (!canAuthenticate) {
//     //     throw Exception('Biometric authentication not available');
//     //   }

//     //   final authenticated = await _localAuth.authenticate(
//     //     localizedReason: 'Authenticate to login',
//     //     options: const AuthenticationOptions(
//     //       stickyAuth: true,
//     //       biometricOnly: true,
//     //     ),
//     //   );

//     //   if (!authenticated) {
//     //     throw Exception('Biometric authentication failed');
//     //   }

//     //   // Get user and verify biometric is enabled
//     //   final user = await authRepository.getUserById(event.userId);
//     //   if (user == null || !user.useBiometric) {
//     //     throw Exception('Biometric login not enabled for this user');
//     //   }

//     //   // Login the user
//     //   await authRepository.switchAccount(event.userId);
//     //   final loggedInUser = await authRepository.getCurrentUser();

//     //   if (loggedInUser != null) {
//     //     emit(AuthState.authenticated(user: loggedInUser));
//     //   } else {
//     //     throw Exception('Login failed');
//     //   }
//     // } catch (e) {
//     //   emit(AuthState.error(
//     //     message: e.toString().replaceAll('Exception: ', ''),
//     //   ));

//     //   // Return to unauthenticated state
//     //   try {
//     //     final allUsers = await getAllAccountsUseCase();
//     //     emit(AuthState.unauthenticated(
//     //       quickLoginUsers: allUsers.isEmpty ? null : allUsers,
//     //     ));
//     //   } catch (_) {
//     //     emit(AuthState.unauthenticated());
//     //   }
//     // }
//   }

//   Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
//     emit(state.copyWith(status: AuthStatus.loading));

//     try {
//       final emailExists = await authRepository.checkEmailExists(event.email);

//       if (emailExists) {
//         throw Exception('Email already registered');
//       }

//       final pinExists = await authRepository.checkPinExists(
//         pin: event.pin ?? '0000',
//       );

//       if (pinExists) {
//         throw Exception('PIN already in use. Please choose another PIN');
//       }

//       final newUser = await registerUseCase(
//         name: event.name,
//         email: event.email,
//         password: event.password,
//         phoneNumber: event.phoneNumber,
//         currency: event.currency,
//         pin: event.pin,
//         useBiometric: event.useBiometric,
//       );
//       AppPrefs.instance.setUserId(newUser.id);
//       AppPrefs.instance.setLoggedIn(true);
//       emit(
//         state.copyWith(
//           status: AuthStatus.authenticated,
//           user: newUser,
//           errorMessage: null,
//         ),
//       );
//     } catch (e) {
//       await _emitErrorAndFallback(
//         emit,
//         e.toString().replaceAll('Exception: ', ''),
//       );
//     }
//   }

//   Future<void> _onForgotPassword(
//     ForgotPasswordEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));

//     try {
//       final userExists = await authRepository.checkEmailExists(event.email);

//       if (!userExists) {
//         throw Exception('No account found with this email');
//       }

//       await Future.delayed(const Duration(seconds: 1));

//       emit(
//         state.copyWith(
//           status: AuthStatus.passwordResetEmailSent,
//           email: event.email,
//         ),
//       );
//     } catch (e) {
//       await _emitErrorAndFallback(
//         emit,
//         e.toString().replaceAll('Exception: ', ''),
//       );
//     }
//   }

//   Future<void> _onResetPassword(
//     ResetPasswordEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.loading));

//     try {
//       final allUsers = await getAllAccountsUseCase();

//       final targetUser = allUsers.firstWhere(
//         (u) => u.email.toLowerCase() == event.email.toLowerCase(),
//         orElse: () => throw Exception('User not found'),
//       );

//       await changePasswordUseCase(
//         userId: targetUser.id,
//         oldPassword: targetUser.passwordHash ?? '',
//         newPassword: event.newPassword,
//       );

//       emit(state.copyWith(status: AuthStatus.passwordResetSuccess));
//     } catch (e) {
//       emit(
//         state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: e.toString().replaceAll('Exception: ', ''),
//         ),
//       );
//     }
//   }

//   Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
//     try {
//       final currentUser = state.user;

//       if (currentUser == null) return;

//       await logoutUseCase(currentUser.id);

//       final allUsers = await getAllAccountsUseCase();

//       emit(
//         state.copyWith(
//           status: AuthStatus.unauthenticated,
//           user: null,
//           quickLoginUsers: allUsers.isEmpty ? null : allUsers,
//         ),
//       );
//     } catch (e) {
//       emit(
//         state.copyWith(
//           status: AuthStatus.error,
//           errorMessage: e.toString().replaceAll('Exception: ', ''),
//         ),
//       );
//     }
//   }

//   Future<void> _onGetCurrentUser(
//     GetCurrentUserEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     try {
//       final user = await getCurrentLoggedInUserUseCase();

//       if (user != null) {
//         emit(state.copyWith(status: AuthStatus.authenticated, user: user));
//       } else {
//         emit(
//           state.copyWith(
//             status: AuthStatus.unauthenticated,
//             user: null, // ✅ CLEAR USER
//           ),
//         );
//       }
//     } catch (e) {
//       emit(
//         state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
//       );
//     }
//   }

//   Future<void> _emitErrorAndFallback(
//     Emitter<AuthState> emit,
//     String message,
//   ) async {
//     emit(state.copyWith(status: AuthStatus.error, errorMessage: message));
//   }
// }
