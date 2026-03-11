// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:expense_mate/core/data/models/user_model.dart';

import 'package:crypto/crypto.dart';
import 'package:expense_mate/features/auth/data/data_source/auth_data_source.dart';
import 'dart:convert';

import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';
import 'package:hive/hive.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  // Hash password (you should use a proper password hashing library like bcrypt)
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<UserModel> register(UserModel user) async {
    try {
      final hashedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        profilePicturePath: user.profilePicturePath,
        currency: user.currency,
        passwordHash: user.passwordHash != null
            ? _hashPassword(user.passwordHash!)
            : null,
        isLoggedIn: false,
        createdAt: user.createdAt,
        lastLoginAt: user.lastLoginAt,
        pin: user.pin,
        useBiometric: user.useBiometric,
        // ── New fields ──
        securityQuestion1: user.securityQuestion1,
        securityAnswer1: user.securityAnswer1,
        securityQuestion2: user.securityQuestion2,
        securityAnswer2: user.securityAnswer2,
        recoveryKeys: user.recoveryKeys,
      );

      return await localDataSource.createUser(hashedUser);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final hashedPassword = _hashPassword(password);
      return await localDataSource.authenticateUser(email, hashedPassword);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserModel?> loginWithPin(String pin) async {
    try {
      return await localDataSource.authenticateWithPin(pin);
    } catch (e) {
      throw Exception('PIN login failed: $e');
    }
  }

  @override
  Future<void> logout(String userId) async {
    final box = Hive.box<UserModel>('users');

    final user = box.get(userId);
    if (user == null) return;

    final updatedUser = user.copyWith(
      isLoggedIn: false,
      lastLoginAt: DateTime.now(),
    );

    await box.put(userId, updatedUser);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      return await localDataSource.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    try {
      return await localDataSource.updateUser(user);
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  @override
  Future<void> deleteAccount(String userId) async {
    try {
      await localDataSource.deleteUser(userId);
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllAccounts() async {
    try {
      return await localDataSource.getAllUsers();
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }

  @override
  Future<void> switchAccount(String userId) async {
    try {
      await localDataSource.loginUser(userId);
    } catch (e) {
      throw Exception('Account switch failed: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.isAnyUserLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final user = await localDataSource.getUserById(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final hashedOldPassword = _hashPassword(oldPassword);
      if (user.passwordHash != hashedOldPassword) {
        throw Exception('Incorrect old password');
      }

      final hashedNewPassword = _hashPassword(newPassword);
      await localDataSource.updatePassword(userId, hashedNewPassword);
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }

  @override
  Future<void> setPin(String userId, String pin) async {
    try {
      if (pin.length != 4 || int.tryParse(pin) == null) {
        throw Exception('PIN must be 4 digits');
      }
      await localDataSource.updatePin(userId, pin);
    } catch (e) {
      throw Exception('PIN setup failed: $e');
    }
  }

  @override
  Future<void> removePin(String userId) async {
    try {
      await localDataSource.updatePin(userId, null);
    } catch (e) {
      throw Exception('PIN removal failed: $e');
    }
  }

  @override
  Future<void> enableBiometric(String userId) async {
    try {
      await localDataSource.toggleBiometric(userId, true);
    } catch (e) {
      throw Exception('Failed to enable biometric: $e');
    }
  }

  @override
  Future<void> disableBiometric(String userId) async {
    try {
      await localDataSource.toggleBiometric(userId, false);
    } catch (e) {
      throw Exception('Failed to disable biometric: $e');
    }
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      final user = await localDataSource.getUserByEmail(email);
      return user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> checkPinExists({required String pin}) async {
    try {
      final user = await localDataSource.getUserByPin(pin);
      return user != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentLoggedInUser() async {
    final users = await localDataSource.getAllUsers();

    try {
      return users.firstWhere((user) => user.isLoggedIn);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> resetPassword(String userId, String newPassword) async {
    try {
      final hashedPassword = _hashPassword(newPassword);
      await localDataSource.updatePassword(userId, hashedPassword);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
}
