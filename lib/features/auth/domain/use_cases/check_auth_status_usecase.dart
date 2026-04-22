// import 'package:spendio/core/data/models/user_model.dart';
import 'package:spendio/features/auth/domain/repository/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';

import '../../../../core/data/models/user_sql_model.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase({required this.repository});

  Future<AuthStatusResult> call() async {
    final isLoggedIn = await repository.isLoggedIn();
    if (isLoggedIn) {
      final user = await repository.getCurrentUser();
      return AuthStatusResult(isAuthenticated: true, user: user);
    } else {
      final allUsers = await repository.getAllAccounts();
      return AuthStatusResult(
        isAuthenticated: false,
        quickLoginUsers: allUsers.isEmpty ? null : allUsers,
      );
    }
  }
}

class AuthStatusResult {
  final bool isAuthenticated;
  final UserModel? user;
  final List<UserModel>? quickLoginUsers;

  AuthStatusResult({
    required this.isAuthenticated,
    this.user,
    this.quickLoginUsers,
  });
}
