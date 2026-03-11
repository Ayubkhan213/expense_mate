// lib/features/auth/presentation/bloc/login_bloc/login_event.dart

part of 'login_bloc.dart';

abstract class LoginEvent {}

// ── Email & Password login ───────────────────────────────────────────────────

class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged(this.email);
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);
}

class LoginTogglePasswordVisibility extends LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted({required this.email, required this.password});
}

// ── PIN login ────────────────────────────────────────────────────────────────

class LoginPinDigitEntered extends LoginEvent {
  final String digit;
  LoginPinDigitEntered(this.digit);
}

class LoginPinDigitDeleted extends LoginEvent {}

class LoginClearPin extends LoginEvent {}

// ── Mode toggle ──────────────────────────────────────────────────────────────

class LoginToggleMode extends LoginEvent {}

class LoginSetAnimating extends LoginEvent {
  final bool isAnimating;
  LoginSetAnimating(this.isAnimating);
}

// ── Bootstrap ────────────────────────────────────────────────────────────────

/// Called on init — loads the stored account (if any) so PIN card can show it.
class LoginLoadAccount extends LoginEvent {}
