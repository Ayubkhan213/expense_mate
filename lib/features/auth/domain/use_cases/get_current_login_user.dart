import 'package:expense_mate/core/app_export.dart';

class GetCurrentLoggedInUserUseCase {
  final AuthRepository repository;

  GetCurrentLoggedInUserUseCase({required this.repository});

  Future<UserModel?> call() async {
    return await repository.getCurrentLoggedInUser();
  }
}
