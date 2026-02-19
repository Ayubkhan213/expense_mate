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
