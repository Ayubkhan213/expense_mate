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
      // Hash the password before storing
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
}

// // lib/features/auth/data/repositories/auth_repository.dart

// import 'dart:convert';
// import 'package:expense_mate/core/services/hive_initializer.dart';
// import 'package:hive/hive.dart';
// import 'package:expense_mate/core/data/models/user_model.dart';

// class AuthRepository {
//   // final Box<UserModel> _userBox = HiveInitializer.users;
//   // final LocalAuthentication _localAuth = LocalAuthentication();

//   // Hash password
//   String _hashPassword(String password) {
//     final bytes = utf8.encode(password);
//     final hash = sha256.convert(bytes);
//     return hash.toString();
//   }

//   // Get current logged-in user
//   Future<UserModel?> getCurrentUser() async {
//     try {
//       return _userBox.values.firstWhere((user) => user.isLoggedIn);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Login with email & password
//   Future<UserModel?> loginWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final user = _userBox.values.firstWhere(
//         (u) => u.email.toLowerCase() == email.toLowerCase(),
//       );

//       if (user.passwordHash == _hashPassword(password)) {
//         // Update login status
//         final updatedUser = UserModel(
//           id: user.id,
//           name: user.name,
//           email: user.email,
//           phoneNumber: user.phoneNumber,
//           profilePicturePath: user.profilePicturePath,
//           currency: user.currency,
//           passwordHash: user.passwordHash,
//           isLoggedIn: true,
//           createdAt: user.createdAt,
//           lastLoginAt: DateTime.now(),
//           pin: user.pin,
//           useBiometric: user.useBiometric,
//         );

//         await _userBox.put(user.id, updatedUser);
//         return updatedUser;
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   // Login with PIN
//   Future<UserModel?> loginWithPin({required String pin}) async {
//     try {
//       final user = _userBox.values.firstWhere((u) => u.pin == pin);

//       final updatedUser = UserModel(
//         id: user.id,
//         name: user.name,
//         email: user.email,
//         phoneNumber: user.phoneNumber,
//         profilePicturePath: user.profilePicturePath,
//         currency: user.currency,
//         passwordHash: user.passwordHash,
//         isLoggedIn: true,
//         createdAt: user.createdAt,
//         lastLoginAt: DateTime.now(),
//         pin: user.pin,
//         useBiometric: user.useBiometric,
//       );

//       await _userBox.put(user.id, updatedUser);
//       return updatedUser;
//     } catch (e) {
//       return null;
//     }
//   }

//   // Sign up
//   Future<UserModel?> signUp({
//     required String name,
//     required String email,
//     required String password,
//     String? phoneNumber,
//   }) async {
//     try {
//       // Check if email already exists
//       final existingUser = _userBox.values.where(
//         (u) => u.email.toLowerCase() == email.toLowerCase(),
//       );

//       if (existingUser.isNotEmpty) {
//         throw Exception('Email already registered');
//       }

//       final user = UserModel(
//         id: 'user_${DateTime.now().millisecondsSinceEpoch}',
//         name: name,
//         email: email,
//         phoneNumber: phoneNumber,
//         passwordHash: _hashPassword(password),
//         isLoggedIn: true,
//         currency: 'USD',
//       );

//       await _userBox.put(user.id, user);
//       return user;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Set PIN
//   Future<UserModel?> setPin({required String pin}) async {
//     final currentUser = await getCurrentUser();
//     if (currentUser == null) return null;

//     final updatedUser = UserModel(
//       id: currentUser.id,
//       name: currentUser.name,
//       email: currentUser.email,
//       phoneNumber: currentUser.phoneNumber,
//       profilePicturePath: currentUser.profilePicturePath,
//       currency: currentUser.currency,
//       passwordHash: currentUser.passwordHash,
//       isLoggedIn: true,
//       createdAt: currentUser.createdAt,
//       lastLoginAt: DateTime.now(),
//       pin: pin,
//       useBiometric: currentUser.useBiometric,
//     );

//     await _userBox.put(currentUser.id, updatedUser);
//     return updatedUser;
//   }

//   // Logout
//   Future<void> logout() async {
//     final currentUser = await getCurrentUser();
//     if (currentUser == null) return;

//     final updatedUser = UserModel(
//       id: currentUser.id,
//       name: currentUser.name,
//       email: currentUser.email,
//       phoneNumber: currentUser.phoneNumber,
//       profilePicturePath: currentUser.profilePicturePath,
//       currency: currentUser.currency,
//       passwordHash: currentUser.passwordHash,
//       isLoggedIn: false,
//       createdAt: currentUser.createdAt,
//       lastLoginAt: currentUser.lastLoginAt,
//       pin: currentUser.pin,
//       useBiometric: currentUser.useBiometric,
//     );

//     await _userBox.put(currentUser.id, updatedUser);
//   }

//   // Reset password (local mock)
//   Future<void> resetPassword({required String email}) async {
//     await Future.delayed(Duration(seconds: 2));
//     // In a real app, send email or SMS
//   }

//   // Biometric login
//   Future<UserModel?> loginWithBiometric() async {
//     try {
//       final canAuth = await _localAuth.canCheckBiometrics;
//       if (!canAuth) return null;

//       final authenticated = await _localAuth.authenticate(
//         localizedReason: 'Authenticate to login',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           stickyAuth: true,
//         ),
//       );

//       if (authenticated) {
//         final user = _userBox.values.firstWhere((u) => u.useBiometric);
//         return loginWithPin(pin: user.pin!);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
// }
