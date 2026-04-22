// lib/features/auth/presentation/bloc/signup_bloc/signup_bloc.dart

import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:spendio/core/data/models/currency_model.dart';
import 'package:spendio/core/services/dummy_account_sedding.dart';
import 'package:spendio/features/auth/domain/repository/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/currency_repository.dart';
import 'package:spendio/core/services/app_prefs.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/sql/currency_repository.dart';
import 'package:spendio/features/auth/domain/use_cases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final RegisterUseCase registerUseCase;
  final AuthRepository authRepository;
  final CurrencyRepository currencyRepository;

  SignupBloc({
    required this.registerUseCase,
    required this.authRepository,
    required this.currencyRepository,
  }) : super(const SignupState()) {
    on<SignupTogglePasswordVisibility>(_onTogglePassword);
    on<SignupToggleConfirmPasswordVisibility>(_onToggleConfirmPassword);
    on<SignupProfileImageChanged>(_onProfileImageChanged);
    on<SignupLoadCurrencies>(_onLoadCurrencies);
    on<SignupCurrencyChanged>(_onCurrencyChanged);
    on<SignupToggleSecurityQuestions>(_onToggleSecurityQuestions);
    on<SignupSecurityQ1Selected>(_onSecurityQ1Selected);
    on<SignupSecurityQ2Selected>(_onSecurityQ2Selected);
    on<SignupSecurityA1Changed>(_onSecurityA1Changed);
    on<SignupSecurityA2Changed>(_onSecurityA2Changed);
    on<SignupToggleTerms>(_onToggleTerms);
    on<SignupSubmitted>(_onSubmitted);

    // Auto-load currencies on creation
    add(SignupLoadCurrencies());
  }

  // ── Visibility toggles ────────────────────────────────────────────────────

  void _onTogglePassword(
    SignupTogglePasswordVisibility event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onToggleConfirmPassword(
    SignupToggleConfirmPasswordVisibility event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  // ── Profile image ─────────────────────────────────────────────────────────

  void _onProfileImageChanged(
    SignupProfileImageChanged event,
    Emitter<SignupState> emit,
  ) {
    if (event.path == null) {
      emit(state.copyWith(clearProfileImage: true));
    } else {
      emit(state.copyWith(pendingProfileImagePath: event.path));
    }
  }

  // ── Currencies ────────────────────────────────────────────────────────────

  Future<void> _onLoadCurrencies(
    SignupLoadCurrencies event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoadingCurrencies: true));
    try {
      final currencies = await currencyRepository.getAllCurrencies();
      emit(
        state.copyWith(
          currencies: currencies,
          selectedCurrency: currencies.isNotEmpty
              ? currencies.first.code
              : 'USD',
          isLoadingCurrencies: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingCurrencies: false));
    }
  }

  void _onCurrencyChanged(
    SignupCurrencyChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(selectedCurrency: event.currencyCode));
  }

  // ── Security questions ────────────────────────────────────────────────────

  void _onToggleSecurityQuestions(
    SignupToggleSecurityQuestions event,
    Emitter<SignupState> emit,
  ) {
    final enabling = !state.securityQuestionsEnabled;
    if (enabling) {
      emit(state.copyWith(securityQuestionsEnabled: true));
    } else {
      emit(
        state.copyWith(
          securityQuestionsEnabled: false,
          clearQ1: true,
          clearQ2: true,
          securityAnswer1: '',
          securityAnswer2: '',
        ),
      );
    }
  }

  void _onSecurityQ1Selected(
    SignupSecurityQ1Selected event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(selectedSecurityQ1: event.question));
  }

  void _onSecurityQ2Selected(
    SignupSecurityQ2Selected event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(selectedSecurityQ2: event.question));
  }

  void _onSecurityA1Changed(
    SignupSecurityA1Changed event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(securityAnswer1: event.answer));
  }

  void _onSecurityA2Changed(
    SignupSecurityA2Changed event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(securityAnswer2: event.answer));
  }

  // ── Terms ─────────────────────────────────────────────────────────────────

  void _onToggleTerms(SignupToggleTerms event, Emitter<SignupState> emit) {
    emit(state.copyWith(agreedToTerms: !state.agreedToTerms));
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading, clearError: true));

    try {
      // ── 0. Single-account enforcement ─────────────────────────────────────
      // Filter out dummy account — it must never block real user signup
      final existingAccounts = await authRepository.getAllAccounts();
      final realAccounts = existingAccounts
          .where((u) => u.email != DummyAccountSeeder.dummyEmail)
          .toList();

      if (realAccounts.isNotEmpty) {
        emit(
          state.copyWith(
            status: SignupStatus.error,
            errorMessage:
                'An account already exists on this device. Only one account is allowed.',
          ),
        );
        return;
      }

      // ── 1. Check email uniqueness ──────────────────────────────────────────
      final emailExists = await authRepository.checkEmailExists(event.email);
      if (emailExists) throw Exception('Email already registered');

      // ── 2. Check PIN uniqueness ────────────────────────────────────────────
      // If user entered a PIN, make sure it doesn't conflict with any account
      // including the dummy account (PIN 1234 is reserved by dummy account)
      if (event.pin != null && event.pin!.isNotEmpty) {
        final pinExists = await authRepository.checkPinExists(pin: event.pin!);
        if (pinExists) {
          throw Exception(
            'PIN ${event.pin} is already in use. Please choose a different PIN.',
          );
        }
      }

      // ── 3. Copy profile image to permanent app storage ─────────────────────
      String? savedImagePath;
      if (state.pendingProfileImagePath != null &&
          state.pendingProfileImagePath!.isNotEmpty) {
        savedImagePath = await _copyImageToAppStorage(
          sourcePath: state.pendingProfileImagePath!,
          userId: DateTime.now().millisecondsSinceEpoch.toString(),
        );
      }

      // ── 4. Generate recovery keys only when security questions are enabled ──
      List<String>? recoveryKeys;
      if (state.securityQuestionsEnabled) {
        recoveryKeys = _generateRecoveryKeys(8);
      }

      // ── 5. Register user ───────────────────────────────────────────────────
      final newUser = await registerUseCase(
        name: event.name,
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber,
        currency: state.selectedCurrency,
        pin: event.pin,
        useBiometric: false,
        profileImagePath: savedImagePath,
        securityQuestion1: state.selectedSecurityQ1,
        securityAnswer1: state.securityAnswer1.isNotEmpty
            ? state.securityAnswer1
            : null,
        securityQuestion2: state.selectedSecurityQ2,
        securityAnswer2: state.securityAnswer2.isNotEmpty
            ? state.securityAnswer2
            : null,
        recoveryKeys: recoveryKeys,
      );

      AppPrefs.instance.setUserId(newUser.id);
      AppPrefs.instance.setLoggedIn(true);
      AppPrefs.instance.setUserCurrency(state.selectedCurrency);

      // ── 6. Emit success ────────────────────────────────────────────────────
      emit(
        state.copyWith(
          status: SignupStatus.success,
          recoveryKeys: recoveryKeys,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<String> _copyImageToAppStorage({
    required String sourcePath,
    required String userId,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/profile_images');
    if (!await dir.exists()) await dir.create(recursive: true);
    final ext = sourcePath.split('.').last.toLowerCase();
    final dest = '${dir.path}/profile_$userId.$ext';
    await File(sourcePath).copy(dest);
    return dest;
  }

  List<String> _generateRecoveryKeys(int count) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random.secure();
    return List.generate(
      count,
      (_) => List.generate(8, (_) => chars[rnd.nextInt(chars.length)]).join(),
    );
  }
}
