import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase({required this.repository});

  Future<void> call({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await repository.changePassword(userId, oldPassword, newPassword);
  }
}
