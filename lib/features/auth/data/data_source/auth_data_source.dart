// lib/features/auth/data/datasources/auth_local_datasource.dart
import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> createUser(UserModel user);
  Future<UserModel?> getUserById(String id);
  Future<UserModel?> getUserByEmail(String email);
  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<List<UserModel>> getAllUsers();
  Future<void> loginUser(String userId);
  Future<void> logoutCurrentUser();
  Future<void> logoutAllUsers();
  Future<bool> isAnyUserLoggedIn();
  Future<UserModel?> authenticateUser(String email, String password);
  Future<UserModel?> authenticateWithPin(String pin);
  Future<void> updatePassword(String userId, String newPasswordHash);
  Future<void> updatePin(String userId, String? newPin);
  Future<void> toggleBiometric(String userId, bool enabled);
  Future<void> updateLastLogin(String userId);
  Future<UserModel?> getUserByPin(String pin);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userBoxName = 'users';

  Box<UserModel> get _userBox => Hive.box<UserModel>(_userBoxName);
  @override
  Future<UserModel?> getUserByPin(String pin) async {
    try {
      return _userBox.values.firstWhere((u) => u.pin == pin);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      // Check if user with same email already exists
      final existingUser = await getUserByEmail(user.email);
      if (existingUser != null) {
        throw Exception('User with this email already exists');
      }

      // Save user to Hive
      await _userBox.put(user.id, user);
      return user;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    try {
      return _userBox.get(id);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      return _userBox.values.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      return _userBox.values.firstWhere(
        (user) => user.isLoggedIn,
        orElse: () => throw Exception('No logged in user'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      await _userBox.put(user.id, user);
      return user;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _userBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      return _userBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  @override
  Future<void> loginUser(String userId) async {
    try {
      // First, logout all users
      await logoutAllUsers();

      // Get the user
      final user = await getUserById(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Update user login status
      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        profilePicturePath: user.profilePicturePath,
        currency: user.currency,
        passwordHash: user.passwordHash,
        isLoggedIn: true,
        createdAt: user.createdAt,
        lastLoginAt: DateTime.now(),
        pin: user.pin,
        useBiometric: user.useBiometric,
      );

      await _userBox.put(userId, updatedUser);
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<void> logoutCurrentUser() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser != null) {
        final updatedUser = UserModel(
          id: currentUser.id,
          name: currentUser.name,
          email: currentUser.email,
          phoneNumber: currentUser.phoneNumber,
          profilePicturePath: currentUser.profilePicturePath,
          currency: currentUser.currency,
          passwordHash: currentUser.passwordHash,
          isLoggedIn: false,
          createdAt: currentUser.createdAt,
          lastLoginAt: currentUser.lastLoginAt,
          pin: currentUser.pin,
          useBiometric: currentUser.useBiometric,
        );

        await _userBox.put(currentUser.id, updatedUser);
      }
    } catch (e) {
      throw Exception('Failed to logout user: $e');
    }
  }

  @override
  Future<void> logoutAllUsers() async {
    try {
      for (var user in _userBox.values) {
        if (user.isLoggedIn) {
          final updatedUser = UserModel(
            id: user.id,
            name: user.name,
            email: user.email,
            phoneNumber: user.phoneNumber,
            profilePicturePath: user.profilePicturePath,
            currency: user.currency,
            passwordHash: user.passwordHash,
            isLoggedIn: false,
            createdAt: user.createdAt,
            lastLoginAt: user.lastLoginAt,
            pin: user.pin,
            useBiometric: user.useBiometric,
          );

          await _userBox.put(user.id, updatedUser);
        }
      }
    } catch (e) {
      throw Exception('Failed to logout all users: $e');
    }
  }

  @override
  Future<bool> isAnyUserLoggedIn() async {
    try {
      return _userBox.values.any((user) => user.isLoggedIn);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> authenticateUser(String email, String password) async {
    try {
      final user = await getUserByEmail(email);
      if (user == null) {
        return null;
      }

      // Verify password (you should use proper password hashing)
      if (user.passwordHash == password) {
        await loginUser(user.id);
        return await getCurrentUser();
      }

      return null;
    } catch (e) {
      throw Exception('Failed to authenticate user: $e');
    }
  }

  @override
  Future<UserModel?> authenticateWithPin(String pin) async {
    try {
      final user = _userBox.values.firstWhere(
        (user) => user.pin == pin,
        orElse: () => throw Exception('Invalid PIN'),
      );

      await loginUser(user.id);
      return await getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updatePassword(String userId, String newPasswordHash) async {
    try {
      final user = await getUserById(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        profilePicturePath: user.profilePicturePath,
        currency: user.currency,
        passwordHash: newPasswordHash,
        isLoggedIn: user.isLoggedIn,
        createdAt: user.createdAt,
        lastLoginAt: user.lastLoginAt,
        pin: user.pin,
        useBiometric: user.useBiometric,
      );

      await _userBox.put(userId, updatedUser);
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  @override
  Future<void> updatePin(String userId, String? newPin) async {
    try {
      final user = await getUserById(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        profilePicturePath: user.profilePicturePath,
        currency: user.currency,
        passwordHash: user.passwordHash,
        isLoggedIn: user.isLoggedIn,
        createdAt: user.createdAt,
        lastLoginAt: user.lastLoginAt,
        pin: newPin,
        useBiometric: user.useBiometric,
      );

      await _userBox.put(userId, updatedUser);
    } catch (e) {
      throw Exception('Failed to update PIN: $e');
    }
  }

  @override
  Future<void> toggleBiometric(String userId, bool enabled) async {
    try {
      final user = await getUserById(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        profilePicturePath: user.profilePicturePath,
        currency: user.currency,
        passwordHash: user.passwordHash,
        isLoggedIn: user.isLoggedIn,
        createdAt: user.createdAt,
        lastLoginAt: user.lastLoginAt,
        pin: user.pin,
        useBiometric: enabled,
      );

      await _userBox.put(userId, updatedUser);
    } catch (e) {
      throw Exception('Failed to toggle biometric: $e');
    }
  }

  @override
  Future<void> updateLastLogin(String userId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        profilePicturePath: user.profilePicturePath,
        currency: user.currency,
        passwordHash: user.passwordHash,
        isLoggedIn: user.isLoggedIn,
        createdAt: user.createdAt,
        lastLoginAt: DateTime.now(),
        pin: user.pin,
        useBiometric: user.useBiometric,
      );

      await _userBox.put(userId, updatedUser);
    } catch (e) {
      throw Exception('Failed to update last login: $e');
    }
  }
}
