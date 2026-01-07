import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';

class LoginWithEmailUseCase {
  final AuthRepository repository;

  LoginWithEmailUseCase({required this.repository});

  Future<UserModel?> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
