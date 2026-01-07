import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<UserModel> call({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
    String currency = 'USD',
    String? pin,
    bool useBiometric = false,
  }) async {
    final userId = DateTime.now().millisecondsSinceEpoch.toString();

    final newUser = UserModel(
      id: userId,
      name: name.trim(),
      email: email.trim(),
      phoneNumber: phoneNumber?.trim(),
      currency: currency,
      passwordHash: password,
      pin: pin,
      useBiometric: useBiometric,
      isLoggedIn: true,
    );

    return await repository.register(newUser);
  }
}
