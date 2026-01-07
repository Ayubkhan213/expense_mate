// auth_event.dart
abstract class AuthEvent {}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailEvent({required this.email, required this.password});
}

class QuickLoginWithPinEvent extends AuthEvent {
  final String pin;

  QuickLoginWithPinEvent({required this.pin});
}

class BiometricLoginEvent extends AuthEvent {
  final String userId;

  BiometricLoginEvent({required this.userId});
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? phoneNumber;
  final String currency;
  final String? pin;
  final bool useBiometric;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.currency = 'USD',
    this.pin,

    this.useBiometric = false,
  });
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String newPassword;
  final String verificationCode;

  ResetPasswordEvent({
    required this.email,
    required this.newPassword,
    required this.verificationCode,
  });
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

// lib/features/auth/presentation/bloc/currency_event.dart
abstract class CurrencyEvent {}

class LoadCurrenciesEvent extends AuthEvent {}

class SelectCurrencyEvent extends AuthEvent {
  final String currencyCode;

  SelectCurrencyEvent(this.currencyCode);
}

class ToggleLoginModeEvent extends AuthEvent {}

class SetAnimatingEvent extends AuthEvent {
  final bool isAnimating;

  SetAnimatingEvent(this.isAnimating);
}

class TogglePasswordVisibility extends AuthEvent {}

class ToggleConfirmPasswordVisibility extends AuthEvent {}

class ChangeCurrencyEvent extends AuthEvent {
  final String currencyCode;
  ChangeCurrencyEvent(this.currencyCode);
}

class PinDigitEnteredEvent extends AuthEvent {
  final String digit;
  PinDigitEnteredEvent(this.digit);
}

class PinDigitDeletedEvent extends AuthEvent {}

class ClearPinEvent extends AuthEvent {}

class GetCurrentUserEvent extends AuthEvent {}

class PinCompleteEvent extends AuthEvent {
  final String pin;
  PinCompleteEvent({required this.pin});
}
