import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';

class GetAllAccountsUseCase {
  final AuthRepository repository;

  GetAllAccountsUseCase({required this.repository});

  Future<List<UserModel>> call() async {
    return await repository.getAllAccounts();
  }
}
