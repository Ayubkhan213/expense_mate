import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage);
    on<UpdateProfileName>(_onUpdateProfileName);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      // TODO: Load from your data source (Hive/SharedPreferences)
      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          userName: 'John Doe',
          userEmail: 'john.doe@example.com',
          profileImagePath: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Save to your data source
      emit(state.copyWith(profileImagePath: event.imagePath));
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateProfileName(
    UpdateProfileName event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Save to your data source
      emit(state.copyWith(userName: event.name));
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
