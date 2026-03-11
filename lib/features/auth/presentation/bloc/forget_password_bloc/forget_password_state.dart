// lib/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart

import 'package:equatable/equatable.dart';

enum ForgotPasswordMethod { recoveryKey, securityQuestions }

enum ForgotPasswordStep {
  enterEmail, // Step 1: enter email to find account
  chooseMethod, // Step 2: pick recovery method
  verifyRecoveryKey, // Step 3a: enter recovery key
  verifySecurityQuestions, // Step 3b: answer security questions
  setNewPassword, // Step 4: set new password
  done, // Step 5: success
}

enum ForgotPasswordStatus { initial, loading, error, success }

class ForgotPasswordState extends Equatable {
  // ── Navigation ─────────────────────────────────────────────────────────────
  final ForgotPasswordStep step;
  final ForgotPasswordMethod selectedMethod;

  // ── Step 1 ─────────────────────────────────────────────────────────────────
  final String email;

  // ── Found user data ────────────────────────────────────────────────────────
  /// Populated after step 1 succeeds (user found & has recovery options)
  final String? foundUserId;
  final bool userHasRecoveryKeys;
  final bool userHasSecurityQuestions;

  /// The questions loaded from the user record
  final String? securityQuestion1;
  final String? securityQuestion2;

  // ── Recovery key verification ───────────────────────────────────────────────
  final String recoveryKeyInput;

  // ── Security question verification ─────────────────────────────────────────
  final String answer1;
  final String answer2;

  // ── Step 4 — new password ──────────────────────────────────────────────────
  final String newPassword;
  final String confirmPassword;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;

  // ── Async status ───────────────────────────────────────────────────────────
  final ForgotPasswordStatus status;
  final String? errorMessage;

  const ForgotPasswordState({
    this.step = ForgotPasswordStep.enterEmail,
    this.selectedMethod = ForgotPasswordMethod.recoveryKey,
    this.email = '',
    this.foundUserId,
    this.userHasRecoveryKeys = false,
    this.userHasSecurityQuestions = false,
    this.securityQuestion1,
    this.securityQuestion2,
    this.recoveryKeyInput = '',
    this.answer1 = '',
    this.answer2 = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.obscureNewPassword = true,
    this.obscureConfirmPassword = true,
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    ForgotPasswordMethod? selectedMethod,
    String? email,
    String? foundUserId,
    bool? userHasRecoveryKeys,
    bool? userHasSecurityQuestions,
    String? securityQuestion1,
    String? securityQuestion2,
    String? recoveryKeyInput,
    String? answer1,
    String? answer2,
    String? newPassword,
    String? confirmPassword,
    bool? obscureNewPassword,
    bool? obscureConfirmPassword,
    ForgotPasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      email: email ?? this.email,
      foundUserId: foundUserId ?? this.foundUserId,
      userHasRecoveryKeys: userHasRecoveryKeys ?? this.userHasRecoveryKeys,
      userHasSecurityQuestions:
          userHasSecurityQuestions ?? this.userHasSecurityQuestions,
      securityQuestion1: securityQuestion1 ?? this.securityQuestion1,
      securityQuestion2: securityQuestion2 ?? this.securityQuestion2,
      recoveryKeyInput: recoveryKeyInput ?? this.recoveryKeyInput,
      answer1: answer1 ?? this.answer1,
      answer2: answer2 ?? this.answer2,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscureNewPassword: obscureNewPassword ?? this.obscureNewPassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    step,
    selectedMethod,
    email,
    foundUserId,
    userHasRecoveryKeys,
    userHasSecurityQuestions,
    securityQuestion1,
    securityQuestion2,
    recoveryKeyInput,
    answer1,
    answer2,
    newPassword,
    confirmPassword,
    obscureNewPassword,
    obscureConfirmPassword,
    status,
    errorMessage,
  ];
}
