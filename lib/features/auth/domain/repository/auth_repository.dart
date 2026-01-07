// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:expense_mate/core/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> register(UserModel user);
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> loginWithPin(String pin);

  Future<void> logout(String userId);

  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUserProfile(UserModel user);
  Future<void> deleteAccount(String userId);
  Future<List<UserModel>> getAllAccounts();
  Future<void> switchAccount(String userId);
  Future<bool> isLoggedIn();
  Future<void> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  );
  Future<void> setPin(String userId, String pin);
  Future<void> removePin(String userId);
  Future<void> enableBiometric(String userId);
  Future<void> disableBiometric(String userId);
  Future<bool> checkEmailExists(String email);
  Future<bool> checkPinExists({required String pin});
  Future<UserModel?> getCurrentLoggedInUser();
}
