import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, loaded, updating, updated, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String? userName;
  final String? userEmail;
  final String? userCurrency;
  final String? profileImagePath;
  final String? errorMessage;
  final int totalTransactions;
  final int totalBudgets;
  final String memberSince;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userName,
    this.userEmail,
    this.userCurrency,
    this.profileImagePath,
    this.errorMessage,
    this.totalTransactions = 0,
    this.totalBudgets = 0,
    this.memberSince = '',
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? userName,
    String? userEmail,
    String? userCurrency,
    String? profileImagePath,
    bool clearProfileImage = false,
    String? errorMessage,
    bool clearError = false,
    int? totalTransactions,
    int? totalBudgets,
    String? memberSince,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userCurrency: userCurrency ?? this.userCurrency,
      profileImagePath: clearProfileImage
          ? null
          : (profileImagePath ?? this.profileImagePath),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      totalTransactions: totalTransactions ?? this.totalTransactions,
      totalBudgets: totalBudgets ?? this.totalBudgets,
      memberSince: memberSince ?? this.memberSince,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userName,
    userEmail,
    userCurrency,
    profileImagePath,
    errorMessage,
    totalTransactions,
    totalBudgets,
    memberSince,
  ];
}
