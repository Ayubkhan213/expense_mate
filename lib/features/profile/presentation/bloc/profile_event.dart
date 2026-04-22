import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfileImage extends ProfileEvent {
  final String imagePath;
  const UpdateProfileImage(this.imagePath);
  @override
  List<Object?> get props => [imagePath];
}

class UpdateProfileName extends ProfileEvent {
  final String name;
  const UpdateProfileName(this.name);
  @override
  List<Object?> get props => [name];
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  final String? profileImagePath;
  final String? currency;
  const UpdateProfile({
    required this.name,
    required this.email,
    this.profileImagePath,
    this.currency,
  });
  @override
  List<Object?> get props => [name, email, profileImagePath, currency];
}

class ProfileLogout extends ProfileEvent {}

class ProfileCurrencyChanged extends ProfileEvent {
  final String currency;
  const ProfileCurrencyChanged(this.currency);
  @override
  List<Object?> get props => [currency];
}
