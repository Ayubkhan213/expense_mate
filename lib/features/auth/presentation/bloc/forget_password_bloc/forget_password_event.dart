// lib/features/auth/presentation/bloc/forgot_password/forgot_password_event.dart

import 'package:expense_mate/features/auth/presentation/bloc/forget_password_bloc/forget_password_state.dart';

abstract class ForgotPasswordEvent {}

// ── Method selection ────────────────────────────────────────────────────────

class ForgotPasswordMethodChanged extends ForgotPasswordEvent {
  final ForgotPasswordMethod method;
  ForgotPasswordMethodChanged(this.method);
}

// ── Step 1 — Find user ───────────────────────────────────────────────────────

class ForgotPasswordEmailSubmitted extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordEmailSubmitted(this.email);
}

// ── Recovery key method ──────────────────────────────────────────────────────

class ForgotPasswordKeyChanged extends ForgotPasswordEvent {
  final String key;
  ForgotPasswordKeyChanged(this.key);
}

class ForgotPasswordVerifyKey extends ForgotPasswordEvent {}

// ── Security question method ─────────────────────────────────────────────────

class ForgotPasswordAnswerChanged extends ForgotPasswordEvent {
  /// Which question (1 or 2)
  final int questionNumber;
  final String answer;
  ForgotPasswordAnswerChanged(this.questionNumber, this.answer);
}

class ForgotPasswordVerifyAnswers extends ForgotPasswordEvent {}

// ── Step 3 — Set new password ────────────────────────────────────────────────

class ForgotPasswordNewPasswordChanged extends ForgotPasswordEvent {
  final String password;
  ForgotPasswordNewPasswordChanged(this.password);
}

class ForgotPasswordConfirmPasswordChanged extends ForgotPasswordEvent {
  final String password;
  ForgotPasswordConfirmPasswordChanged(this.password);
}

class ForgotPasswordToggleNewPasswordVisibility extends ForgotPasswordEvent {}

class ForgotPasswordToggleConfirmPasswordVisibility
    extends ForgotPasswordEvent {}

class ForgotPasswordResetSubmitted extends ForgotPasswordEvent {}

// ── Navigation ───────────────────────────────────────────────────────────────

class ForgotPasswordReset extends ForgotPasswordEvent {}
