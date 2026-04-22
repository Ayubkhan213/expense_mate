import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:spendio/core/data/models/user_sql_model.dart';
import 'package:spendio/features/auth/data/data_source/auth_local_datasource.dart';

import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  // ── private ────────────────────────────────────────────────────────────────
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REGISTRATION / AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<UserModel> register(UserModel user) async {
    try {
      // Hash the password before persisting
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
        securityQuestion1: user.securityQuestion1,
        securityAnswer1: user.securityAnswer1,
        securityQuestion2: user.securityQuestion2,
        securityAnswer2: user.securityAnswer2,
        recoveryKeys: user.recoveryKeys,
        updatedAt: DateTime.now(),
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
    try {
      // Delegates to the datasource — no direct Hive/SQLite access in repo
      await localDataSource.logoutCurrentUser();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CURRENT USER / SESSION
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      return await localDataSource.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> getCurrentLoggedInUser() async {
    try {
      return await localDataSource.getCurrentUser();
    } catch (_) {
      return null;
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

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

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
      // loginUser already calls logoutAllUsers first, then logs in the target
      await localDataSource.loginUser(userId);
    } catch (e) {
      throw Exception('Account switch failed: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final user = await localDataSource.getUserById(userId);
      if (user == null) throw Exception('User not found');

      if (user.passwordHash != _hashPassword(oldPassword)) {
        throw Exception('Incorrect old password');
      }

      await localDataSource.updatePassword(userId, _hashPassword(newPassword));
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }

  @override
  Future<void> resetPassword(String userId, String newPassword) async {
    try {
      await localDataSource.updatePassword(userId, _hashPassword(newPassword));
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PIN
  // ═══════════════════════════════════════════════════════════════════════════

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
  Future<bool> checkPinExists({required String pin}) async {
    try {
      final user = await localDataSource.getUserByPin(pin);
      return user != null;
    } catch (_) {
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BIOMETRIC
  // ═══════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════
  // LOOKUPS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      final user = await localDataSource.getUserByEmail(email);
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
