// lib/features/profile/presentation/bloc/profile_bloc.dart

import 'dart:io';
import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:expense_mate/core/services/app_prefs.dart';
import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';
import 'package:expense_mate/features/auth/domain/use_cases/logout_usecase.dart';
import 'package:expense_mate/features/auth/domain/use_cases/update_profile_usecase.dart';
import 'package:expense_mate/features/splah/presentation/bloc/splash_bloc.dart';
import 'package:expense_mate/features/splah/presentation/bloc/splash_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final LogoutUseCase logoutUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final SplashBloc splashBloc;

  ProfileBloc({
    required this.authRepository,
    required this.logoutUseCase,
    required this.updateProfileUseCase,
    required this.splashBloc,
  }) : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage);
    on<UpdateProfileName>(_onUpdateProfileName);
    on<UpdateProfile>(_onUpdateProfile);
    on<ProfileLogout>(_onLogout);
  }

  // ── Load — ALWAYS fetches from Hive directly ───────────────────────────────
  // Never read from splashBloc.state.currentUser — it is stale after updates.

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final userId = AppPrefs.instance.userId;
      if (userId == null) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            errorMessage: 'No user session',
          ),
        );
        return;
      }

      // Always re-fetch from Hive — splashBloc.currentUser is stale after edits
      final users = await authRepository.getAllAccounts();
      final user = users.where((u) => u.id == userId).firstOrNull;

      if (user == null) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            errorMessage: 'No user found',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          userName: user.name,
          userEmail: user.email,
          profileImagePath: user.profilePicturePath,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  // ── Image preview in state (not persisted yet) ─────────────────────────────

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.imagePath.isEmpty) {
      emit(state.copyWith(clearProfileImage: true));
    } else {
      emit(state.copyWith(profileImagePath: event.imagePath));
    }
  }

  // ── Name preview in state (not persisted yet) ──────────────────────────────

  Future<void> _onUpdateProfileName(
    UpdateProfileName event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(userName: event.name));
  }

  // ── Persist to Hive then emit updated state directly ──────────────────────
  // After saving we emit the new values immediately — no extra LoadProfile call
  // needed. The caller (EditProfileFace) pops with true and ProfileFace calls
  // LoadProfile() to sync the header.

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.updating, clearError: true));

    try {
      final userId = AppPrefs.instance.userId;
      if (userId == null) throw Exception('No user session');

      final users = await authRepository.getAllAccounts();
      final current = users.where((u) => u.id == userId).firstOrNull;
      if (current == null) throw Exception('User not found');

      // ── Image handling ─────────────────────────────────────────────────────
      String? finalImagePath;

      if (event.profileImagePath == null || event.profileImagePath!.isEmpty) {
        finalImagePath = null; // cleared
      } else if (event.profileImagePath == current.profilePicturePath) {
        finalImagePath = current.profilePicturePath; // unchanged
      } else {
        // New image — copy to permanent storage (same as SignupBloc)
        finalImagePath = await _copyImageToAppStorage(
          sourcePath: event.profileImagePath!,
          userId: userId,
        );
      }

      // ── Rebuild UserModel (name/email are final — must reconstruct) ────────
      final updated = UserModel(
        id: current.id,
        name: event.name,
        email: event.email,
        phoneNumber: current.phoneNumber,
        profilePicturePath: finalImagePath,
        currency: current.currency,
        passwordHash: current.passwordHash,
        isLoggedIn: current.isLoggedIn,
        createdAt: current.createdAt,
        lastLoginAt: current.lastLoginAt,
        pin: current.pin,
        useBiometric: current.useBiometric,
        securityQuestion1: current.securityQuestion1,
        securityAnswer1: current.securityAnswer1,
        securityQuestion2: current.securityQuestion2,
        securityAnswer2: current.securityAnswer2,
        recoveryKeys: current.recoveryKeys,
      );

      await updateProfileUseCase(updated);

      // Emit updated values immediately — UI reflects changes right away
      emit(
        state.copyWith(
          status: ProfileStatus.updated,
          userName: updated.name,
          userEmail: updated.email,
          profileImagePath: updated.profilePicturePath,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  Future<void> _onLogout(
    ProfileLogout event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    splashBloc.add(SplashLogout());
    emit(state.copyWith(status: ProfileStatus.initial));
  }

  // ── Copy picked image to permanent storage (same as SignupBloc) ───────────

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
}
