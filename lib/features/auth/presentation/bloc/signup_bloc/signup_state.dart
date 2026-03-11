// lib/features/auth/presentation/bloc/signup/signup_state.dart

part of 'signup_bloc.dart';

enum SignupStatus {
  initial,
  loading,
  success, // account created — triggers recovery keys dialog then navigate
  error,
}

class SignupState extends Equatable {
  // ── Form visibility ────────────────────────────────────────────────────────
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  // ── Profile image ──────────────────────────────────────────────────────────
  /// Temp path from image_picker; copied to app storage on submit
  final String? pendingProfileImagePath;

  // ── Currency ───────────────────────────────────────────────────────────────
  final String selectedCurrency;
  final List<CurrencyModel> currencies;
  final bool isLoadingCurrencies;

  // ── Security questions ─────────────────────────────────────────────────────
  final bool securityQuestionsEnabled;
  final String? selectedSecurityQ1;
  final String? selectedSecurityQ2;
  final String securityAnswer1;
  final String securityAnswer2;

  // ── Terms ──────────────────────────────────────────────────────────────────
  final bool agreedToTerms;

  // ── Submission ─────────────────────────────────────────────────────────────
  final SignupStatus status;
  final String? errorMessage;

  /// Populated on success when security questions are enabled.
  /// UI reads this to show the recovery-keys dialog.
  final List<String>? recoveryKeys;

  const SignupState({
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.pendingProfileImagePath,
    this.selectedCurrency = 'USD',
    this.currencies = const [],
    this.isLoadingCurrencies = false,
    this.securityQuestionsEnabled = false,
    this.selectedSecurityQ1,
    this.selectedSecurityQ2,
    this.securityAnswer1 = '',
    this.securityAnswer2 = '',
    this.agreedToTerms = false,
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.recoveryKeys,
  });

  SignupState copyWith({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? pendingProfileImagePath,
    bool clearProfileImage = false,
    String? selectedCurrency,
    List<CurrencyModel>? currencies,
    bool? isLoadingCurrencies,
    bool? securityQuestionsEnabled,
    String? selectedSecurityQ1,
    bool clearQ1 = false,
    String? selectedSecurityQ2,
    bool clearQ2 = false,
    String? securityAnswer1,
    String? securityAnswer2,
    bool? agreedToTerms,
    SignupStatus? status,
    String? errorMessage,
    bool clearError = false,
    List<String>? recoveryKeys,
  }) {
    return SignupState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      pendingProfileImagePath: clearProfileImage
          ? null
          : (pendingProfileImagePath ?? this.pendingProfileImagePath),
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      currencies: currencies ?? this.currencies,
      isLoadingCurrencies: isLoadingCurrencies ?? this.isLoadingCurrencies,
      securityQuestionsEnabled:
          securityQuestionsEnabled ?? this.securityQuestionsEnabled,
      selectedSecurityQ1: clearQ1
          ? null
          : (selectedSecurityQ1 ?? this.selectedSecurityQ1),
      selectedSecurityQ2: clearQ2
          ? null
          : (selectedSecurityQ2 ?? this.selectedSecurityQ2),
      securityAnswer1: securityAnswer1 ?? this.securityAnswer1,
      securityAnswer2: securityAnswer2 ?? this.securityAnswer2,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      recoveryKeys: recoveryKeys ?? this.recoveryKeys,
    );
  }

  @override
  List<Object?> get props => [
    obscurePassword,
    obscureConfirmPassword,
    pendingProfileImagePath,
    selectedCurrency,
    currencies,
    isLoadingCurrencies,
    securityQuestionsEnabled,
    selectedSecurityQ1,
    selectedSecurityQ2,
    securityAnswer1,
    securityAnswer2,
    agreedToTerms,
    status,
    errorMessage,
    recoveryKeys,
  ];
}
