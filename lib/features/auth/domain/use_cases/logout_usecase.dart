import 'package:spendio/core/app_export.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call(String userId) async {
    await repository.logout(userId);
  }
}
