// import 'package:spendio/core/data/models/user_model.dart';
import 'package:spendio/core/data/models/user_sql_model.dart';
import 'package:spendio/features/auth/domain/repository/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';

class GetAllAccountsUseCase {
  final AuthRepository repository;

  GetAllAccountsUseCase({required this.repository});

  Future<List<UserModel>> call() async {
    return await repository.getAllAccounts();
  }
}
