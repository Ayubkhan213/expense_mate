import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String? userName;
  final String? userEmail;
  final String? profileImagePath;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userName,
    this.userEmail,
    this.profileImagePath,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? userName,
    String? userEmail,
    String? profileImagePath,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userName,
    userEmail,
    profileImagePath,
    errorMessage,
  ];
}
