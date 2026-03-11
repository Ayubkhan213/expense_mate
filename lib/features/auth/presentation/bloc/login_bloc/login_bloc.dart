// lib/features/auth/presentation/bloc/login_bloc/login_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:expense_mate/core/services/app_prefs.dart';
import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<LoginLoadAccount>(_onLoadAccount);
    on<LoginToggleMode>(_onToggleMode);
    on<LoginSetAnimating>(_onSetAnimating);
    on<LoginTogglePasswordVisibility>(_onTogglePassword);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginPinDigitEntered>(_onPinDigitEntered);
    on<LoginPinDigitDeleted>(_onPinDigitDeleted);
    on<LoginClearPin>(_onClearPin);

    // Auto-load on creation
    add(LoginLoadAccount());
  }

  // ── Bootstrap ─────────────────────────────────────────────────────────────

  Future<void> _onLoadAccount(
    LoginLoadAccount event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final users = await authRepository.getAllAccounts();
      // Single-account: grab first (and only) account
      final account = users.isNotEmpty ? users.first : null;

      // Always default to email/password mode on open
      emit(
        state.copyWith(storedAccount: account, mode: LoginMode.emailPassword),
      );
    } catch (_) {
      // No account yet — stay in email mode
    }
  }

  // ── Mode toggle ───────────────────────────────────────────────────────────

  void _onToggleMode(LoginToggleMode event, Emitter<LoginState> emit) {
    if (state.isAnimating) return;
    final newMode = state.mode == LoginMode.emailPassword
        ? LoginMode.pin
        : LoginMode.emailPassword;
    emit(
      state.copyWith(
        mode: newMode,
        isAnimating: true,
        enteredPin: '',
        clearError: true,
      ),
    );
  }

  void _onSetAnimating(LoginSetAnimating event, Emitter<LoginState> emit) {
    emit(state.copyWith(isAnimating: event.isAnimating));
  }

  // ── Password visibility ───────────────────────────────────────────────────

  void _onTogglePassword(
    LoginTogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  // ── Email/password submit ─────────────────────────────────────────────────

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, clearError: true));

    try {
      final user = await authRepository.login(event.email, event.password);

      if (user == null) {
        emit(
          state.copyWith(
            status: LoginStatus.error,
            errorMessage: 'Invalid email or password',
          ),
        );
        return;
      }

      AppPrefs.instance.setUserId(user.id);
      AppPrefs.instance.setLoggedIn(true);

      emit(
        state.copyWith(
          status: LoginStatus.authenticated,
          authenticatedUser: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  // ── PIN ───────────────────────────────────────────────────────────────────

  Future<void> _onPinDigitEntered(
    LoginPinDigitEntered event,
    Emitter<LoginState> emit,
  ) async {
    if (state.enteredPin.length >= 4) return;

    final updated = state.enteredPin + event.digit;
    emit(state.copyWith(enteredPin: updated, clearError: true));

    if (updated.length == 4) {
      await _verifyPin(updated, emit);
    }
  }

  void _onPinDigitDeleted(
    LoginPinDigitDeleted event,
    Emitter<LoginState> emit,
  ) {
    if (state.enteredPin.isEmpty) return;
    emit(
      state.copyWith(
        enteredPin: state.enteredPin.substring(0, state.enteredPin.length - 1),
      ),
    );
  }

  void _onClearPin(LoginClearPin event, Emitter<LoginState> emit) {
    emit(state.copyWith(enteredPin: '', clearError: true));
  }

  Future<void> _verifyPin(String pin, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final user = await authRepository.loginWithPin(pin);

      if (user == null) {
        emit(
          state.copyWith(
            status: LoginStatus.unauthenticated,
            enteredPin: '',
            errorMessage: 'Incorrect PIN. Please try again.',
          ),
        );
        return;
      }

      AppPrefs.instance.setUserId(user.id);
      AppPrefs.instance.setLoggedIn(true);

      emit(
        state.copyWith(
          status: LoginStatus.authenticated,
          authenticatedUser: user,
          enteredPin: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.unauthenticated,
          enteredPin: '',
          errorMessage: 'Incorrect PIN. Please try again.',
        ),
      );
    }
  }
}
