import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/sql/currency_repository.dart';
import 'package:spendio/features/splah/presentation/bloc/splash_event.dart';
import 'package:spendio/features/splah/presentation/bloc/splash_state.dart';

import '../../../../core/services/app_prefs.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository authRepository;
  final CurrencyRepository currencyRepository;

  SplashBloc({required this.authRepository, required this.currencyRepository})
    : super(const SplashState()) {
    on<SplashCheckAuth>(_onCheckAuth);
    on<SplashLoadCurrencies>(_onLoadCurrencies);
    on<SplashLogout>(_onLogout);

    // ── FIX: auto-fire on creation so splash always starts the check ─────────
    add(SplashCheckAuth());
    add(SplashLoadCurrencies());
  }

  // ── Auth check ─────────────────────────────────────────────────────────────
  //
  // Decision tree:
  //   1. onboardingSeen == false  →  firstLaunch   → LanguageFace → Onboarding
  //   2. isLoggedIn == true       →  authenticated → Home
  //   3. else                     →  unauthenticated → Login
  //
  Future<void> _onCheckAuth(
    SplashCheckAuth event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(status: SplashStatus.checking));

    try {
      // ── Step 1: Has the user completed onboarding? ─────────────────────────
      final onboardingSeen = AppPrefs.instance.onboardingSeen;
      if (!onboardingSeen) {
        emit(state.copyWith(status: SplashStatus.firstLaunch));
        return;
      }

      // ── Step 2: Check SharedPreferences login flag ─────────────────────────
      final isLoggedIn = AppPrefs.instance.isLoggedIn;
      if (!isLoggedIn) {
        emit(state.copyWith(status: SplashStatus.unauthenticated));
        return;
      }

      final userId = AppPrefs.instance.userId;
      if (userId == null || userId.isEmpty) {
        emit(state.copyWith(status: SplashStatus.unauthenticated));
        return;
      }

      // ── Step 3: Verify the user still exists in Hive ───────────────────────
      final users = await authRepository.getAllAccounts();
      final matchedUser = users.where((u) => u.id == userId).firstOrNull;

      if (matchedUser == null) {
        await AppPrefs.instance.clearSession();
        emit(state.copyWith(status: SplashStatus.unauthenticated));
        return;
      }

      emit(
        state.copyWith(
          status: SplashStatus.authenticated,
          currentUser: matchedUser,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SplashStatus.unauthenticated));
    }
  }

  // ── Load currencies ────────────────────────────────────────────────────────
  Future<void> _onLoadCurrencies(
    SplashLoadCurrencies event,
    Emitter<SplashState> emit,
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

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> _onLogout(SplashLogout event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.loggingOut));
    try {
      final userId = state.currentUser?.id ?? AppPrefs.instance.userId;
      await AppPrefs.instance.clearSession();
      // NOTE: do NOT reset onboardingSeen — user should never see onboarding again
      if (userId != null && userId.isNotEmpty) {
        try {
          await authRepository.logout(userId);
        } catch (_) {}
      }
      emit(
        state.copyWith(
          status: SplashStatus.unauthenticated,
          clearCurrentUser: true,
        ),
      );
    } catch (_) {
      await AppPrefs.instance.clearSession();
      emit(
        state.copyWith(
          status: SplashStatus.unauthenticated,
          clearCurrentUser: true,
        ),
      );
    }
  }
}
