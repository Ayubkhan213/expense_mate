// import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/data/models/user_sql_model.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';

class GetCurrentLoggedInUserUseCase {
  final AuthRepository repository;

  GetCurrentLoggedInUserUseCase({required this.repository});

  Future<UserModel?> call() async {
    return await repository.getCurrentLoggedInUser();
  }
}
