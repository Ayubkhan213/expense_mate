// lib/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart

import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';
import 'package:expense_mate/features/auth/presentation/bloc/forget_password_bloc/forget_password_event.dart';
import 'package:expense_mate/features/auth/presentation/bloc/forget_password_bloc/forget_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc({required this.authRepository})
    : super(const ForgotPasswordState()) {
    on<ForgotPasswordMethodChanged>(_onMethodChanged);
    on<ForgotPasswordEmailSubmitted>(_onEmailSubmitted);
    on<ForgotPasswordKeyChanged>(_onKeyChanged);
    on<ForgotPasswordVerifyKey>(_onVerifyKey);
    on<ForgotPasswordAnswerChanged>(_onAnswerChanged);
    on<ForgotPasswordVerifyAnswers>(_onVerifyAnswers);
    on<ForgotPasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ForgotPasswordConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ForgotPasswordToggleNewPasswordVisibility>(_onToggleNewPassword);
    on<ForgotPasswordToggleConfirmPasswordVisibility>(_onToggleConfirmPassword);
    on<ForgotPasswordResetSubmitted>(_onResetSubmitted);
    on<ForgotPasswordReset>(_onReset);
  }

  // ── Method ────────────────────────────────────────────────────────────────

  void _onMethodChanged(
    ForgotPasswordMethodChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        selectedMethod: event.method,
        clearError: true,
        recoveryKeyInput: '',
        answer1: '',
        answer2: '',
      ),
    );
  }

  // ── Step 1: find user by email ────────────────────────────────────────────

  Future<void> _onEmailSubmitted(
    ForgotPasswordEmailSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ForgotPasswordStatus.loading,
        email: event.email,
        clearError: true,
      ),
    );

    try {
      final exists = await authRepository.checkEmailExists(event.email);
      if (!exists) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.error,
            errorMessage: 'No account found with this email address',
          ),
        );
        return;
      }

      // Load the user to check available recovery options
      final users = await authRepository.getAllAccounts();
      final user = users.firstWhere(
        (u) => u.email.toLowerCase() == event.email.toLowerCase(),
      );

      final hasKeys =
          user.recoveryKeys != null && user.recoveryKeys!.isNotEmpty;
      final hasQuestions =
          user.securityQuestion1 != null && user.securityQuestion2 != null;

      if (!hasKeys && !hasQuestions) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.error,
            errorMessage:
                'This account has no recovery options set up. Please contact support.',
          ),
        );
        return;
      }

      // Default method based on what's available
      final defaultMethod = hasKeys
          ? ForgotPasswordMethod.recoveryKey
          : ForgotPasswordMethod.securityQuestions;

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.initial,
          step: ForgotPasswordStep.chooseMethod,
          foundUserId: user.id,
          userHasRecoveryKeys: hasKeys,
          userHasSecurityQuestions: hasQuestions,
          securityQuestion1: user.securityQuestion1,
          securityQuestion2: user.securityQuestion2,
          selectedMethod: defaultMethod,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  // ── Recovery key ──────────────────────────────────────────────────────────

  void _onKeyChanged(
    ForgotPasswordKeyChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(recoveryKeyInput: event.key.toUpperCase().trim()));
  }

  Future<void> _onVerifyKey(
    ForgotPasswordVerifyKey event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(status: ForgotPasswordStatus.loading, clearError: true),
    );

    try {
      final users = await authRepository.getAllAccounts();
      final user = users.firstWhere((u) => u.id == state.foundUserId);

      final keys = user.recoveryKeys ?? [];
      final inputKey = state.recoveryKeyInput.trim().toUpperCase();

      if (!keys.contains(inputKey)) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.error,
            errorMessage: 'Invalid recovery key. Please check and try again.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.initial,
          step: ForgotPasswordStep.setNewPassword,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: 'Verification failed. Please try again.',
        ),
      );
    }
  }

  // ── Security questions ────────────────────────────────────────────────────

  void _onAnswerChanged(
    ForgotPasswordAnswerChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    if (event.questionNumber == 1) {
      emit(state.copyWith(answer1: event.answer));
    } else {
      emit(state.copyWith(answer2: event.answer));
    }
  }

  Future<void> _onVerifyAnswers(
    ForgotPasswordVerifyAnswers event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      state.copyWith(status: ForgotPasswordStatus.loading, clearError: true),
    );

    try {
      final users = await authRepository.getAllAccounts();
      final user = users.firstWhere((u) => u.id == state.foundUserId);

      // Case-insensitive trimmed comparison
      final a1Match =
          (user.securityAnswer1 ?? '').trim().toLowerCase() ==
          state.answer1.trim().toLowerCase();
      final a2Match =
          (user.securityAnswer2 ?? '').trim().toLowerCase() ==
          state.answer2.trim().toLowerCase();

      // At least ONE correct answer unlocks reset (you can require both)
      if (!a1Match && !a2Match) {
        emit(
          state.copyWith(
            status: ForgotPasswordStatus.error,
            errorMessage:
                'Neither answer matched. Please check your answers and try again.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.initial,
          step: ForgotPasswordStep.setNewPassword,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: 'Verification failed. Please try again.',
        ),
      );
    }
  }

  // ── New password ──────────────────────────────────────────────────────────

  void _onNewPasswordChanged(
    ForgotPasswordNewPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(newPassword: event.password));
  }

  void _onConfirmPasswordChanged(
    ForgotPasswordConfirmPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.password));
  }

  void _onToggleNewPassword(
    ForgotPasswordToggleNewPasswordVisibility event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(obscureNewPassword: !state.obscureNewPassword));
  }

  void _onToggleConfirmPassword(
    ForgotPasswordToggleConfirmPasswordVisibility event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  Future<void> _onResetSubmitted(
    ForgotPasswordResetSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.newPassword.length < 6) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: 'Password must be at least 6 characters',
        ),
      );
      return;
    }
    if (state.newPassword != state.confirmPassword) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: 'Passwords do not match',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: ForgotPasswordStatus.loading, clearError: true),
    );

    try {
      await authRepository.resetPassword(state.foundUserId!, state.newPassword);

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.done,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: 'Failed to reset password. Please try again.',
        ),
      );
    }
  }
  // ── Reset ─────────────────────────────────────────────────────────────────

  void _onReset(ForgotPasswordReset event, Emitter<ForgotPasswordState> emit) {
    emit(const ForgotPasswordState());
  }
}
