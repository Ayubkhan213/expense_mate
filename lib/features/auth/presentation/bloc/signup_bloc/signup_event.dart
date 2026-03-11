// lib/features/auth/presentation/bloc/signup/signup_event.dart

part of 'signup_bloc.dart';

abstract class SignupEvent {}

// ── Form field visibility toggles ──────────────────────────────────────────

class SignupTogglePasswordVisibility extends SignupEvent {}

class SignupToggleConfirmPasswordVisibility extends SignupEvent {}

// ── Profile image ───────────────────────────────────────────────────────────

/// Called when user picks an image from camera/gallery.
/// Pass null to clear the pending image.
class SignupProfileImageChanged extends SignupEvent {
  final String? path;
  SignupProfileImageChanged(this.path);
}

// ── Currency ────────────────────────────────────────────────────────────────

class SignupLoadCurrencies extends SignupEvent {}

class SignupCurrencyChanged extends SignupEvent {
  final String currencyCode;
  SignupCurrencyChanged(this.currencyCode);
}

// ── Security questions toggle ───────────────────────────────────────────────

class SignupToggleSecurityQuestions extends SignupEvent {}

// ── Security question dropdowns ─────────────────────────────────────────────

class SignupSecurityQ1Selected extends SignupEvent {
  final String question;
  SignupSecurityQ1Selected(this.question);
}

class SignupSecurityQ2Selected extends SignupEvent {
  final String question;
  SignupSecurityQ2Selected(this.question);
}

// ── Security answer text changes ────────────────────────────────────────────

class SignupSecurityA1Changed extends SignupEvent {
  final String answer;
  SignupSecurityA1Changed(this.answer);
}

class SignupSecurityA2Changed extends SignupEvent {
  final String answer;
  SignupSecurityA2Changed(this.answer);
}

// ── Terms & conditions ──────────────────────────────────────────────────────

class SignupToggleTerms extends SignupEvent {}

// ── Submit ──────────────────────────────────────────────────────────────────

class SignupSubmitted extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? pin;

  SignupSubmitted({
    required this.name,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.pin,
  });
}
