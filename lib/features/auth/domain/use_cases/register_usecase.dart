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
    // ── New fields ──
    String? profileImagePath,
    String? securityQuestion1,
    String? securityAnswer1,
    String? securityQuestion2,
    String? securityAnswer2,
    List<String>? recoveryKeys,
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
      profilePicturePath: profileImagePath,
      securityQuestion1: securityQuestion1,
      securityAnswer1: securityAnswer1,
      securityQuestion2: securityQuestion2,
      securityAnswer2: securityAnswer2,
      recoveryKeys: recoveryKeys,
    );

    return await repository.register(newUser);
  }
}
