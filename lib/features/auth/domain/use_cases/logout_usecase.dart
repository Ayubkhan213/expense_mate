import 'package:expense_mate/core/app_export.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call(String userId) async {
    await repository.logout(userId);
  }
}
