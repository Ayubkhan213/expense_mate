// lib/features/auth/presentation/bloc/login_bloc/login_state.dart

part of 'login_bloc.dart';

enum LoginStatus { initial, loading, authenticated, unauthenticated, error }

enum LoginMode { emailPassword, pin }

class LoginState extends Equatable {
  // ── Mode ───────────────────────────────────────────────────────────────────
  final LoginMode mode;
  final bool isAnimating;

  // ── Email/password form ────────────────────────────────────────────────────
  final bool obscurePassword;

  // ── PIN ────────────────────────────────────────────────────────────────────
  final String enteredPin;

  // ── Stored account (single-account mode) ───────────────────────────────────
  /// The one account stored on this device (null if no account yet).
  final UserModel? storedAccount;

  // ── Status ─────────────────────────────────────────────────────────────────
  final LoginStatus status;
  final String? errorMessage;

  // ── Authenticated user ─────────────────────────────────────────────────────
  final UserModel? authenticatedUser;

  const LoginState({
    this.mode = LoginMode.emailPassword,
    this.isAnimating = false,
    this.obscurePassword = true,
    this.enteredPin = '',
    this.storedAccount,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.authenticatedUser,
  });

  /// True when PIN mode makes sense — account exists and has a PIN set.
  bool get canUsePinLogin =>
      storedAccount != null &&
      storedAccount!.pin != null &&
      storedAccount!.pin!.isNotEmpty;

  LoginState copyWith({
    LoginMode? mode,
    bool? isAnimating,
    bool? obscurePassword,
    String? enteredPin,
    UserModel? storedAccount,
    bool clearStoredAccount = false,
    LoginStatus? status,
    String? errorMessage,
    bool clearError = false,
    UserModel? authenticatedUser,
  }) {
    return LoginState(
      mode: mode ?? this.mode,
      isAnimating: isAnimating ?? this.isAnimating,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      enteredPin: enteredPin ?? this.enteredPin,
      storedAccount: clearStoredAccount
          ? null
          : (storedAccount ?? this.storedAccount),
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      authenticatedUser: authenticatedUser ?? this.authenticatedUser,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    isAnimating,
    obscurePassword,
    enteredPin,
    storedAccount,
    status,
    errorMessage,
    authenticatedUser,
  ];
}
