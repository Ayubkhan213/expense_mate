// import 'package:spendio/core/data/models/user_model.dart';
import 'package:spendio/core/data/models/user_sql_model.dart';
import 'package:spendio/features/auth/domain/repository/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';

class LoginWithPinUseCase {
  final AuthRepository repository;

  LoginWithPinUseCase({required this.repository});

  Future<UserModel?> call(String pin) async {
    return await repository.loginWithPin(pin);
  }
}
