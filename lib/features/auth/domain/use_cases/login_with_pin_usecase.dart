import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';

class LoginWithPinUseCase {
  final AuthRepository repository;

  LoginWithPinUseCase({required this.repository});

  Future<UserModel?> call(String pin) async {
    return await repository.loginWithPin(pin);
  }
}
