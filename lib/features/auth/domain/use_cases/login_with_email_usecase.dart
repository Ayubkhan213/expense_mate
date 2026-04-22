// import 'package:spendio/core/data/models/user_model.dart';
import 'package:spendio/core/data/models/user_sql_model.dart';
import 'package:spendio/features/auth/domain/repository/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';

class LoginWithEmailUseCase {
  final AuthRepository repository;

  LoginWithEmailUseCase({required this.repository});

  Future<UserModel?> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
