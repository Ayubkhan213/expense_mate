// import 'package:expense_mate/core/data/models/user_sql_model.dart';
// import 'package:expense_mate/core/database/db_constants.dart';
// import 'package:expense_mate/core/database/sqflite_helper.dart';

// abstract class AuthLocalDataSource {
//   Future<UserModel> createUser(UserModel user);
//   Future<UserModel?> getUserById(String id);
//   Future<UserModel?> getUserByEmail(String email);
//   Future<UserModel?> getCurrentUser();
//   Future<UserModel> updateUser(UserModel user);
//   Future<void> deleteUser(String id);
//   Future<List<UserModel>> getAllUsers();
//   Future<void> loginUser(String userId);
//   Future<void> logoutCurrentUser();
//   Future<void> logoutAllUsers();
//   Future<bool> isAnyUserLoggedIn();
//   Future<UserModel?> authenticateUser(String email, String password);
//   Future<UserModel?> authenticateWithPin(String pin);
//   Future<void> updatePassword(String userId, String newPasswordHash);
//   Future<void> updatePin(String userId, String? newPin);
//   Future<void> toggleBiometric(String userId, bool enabled);
//   Future<void> updateLastLogin(String userId);
//   Future<UserModel?> getUserByPin(String pin);
// }

// // ─────────────────────────────────────────────────────────────────────────────

// class AuthLocalDataSourceImpl implements AuthLocalDataSource {
//   final SqliteHelper _db = SqliteHelper.instance;

//   // ── private helpers ────────────────────────────────────────────────────────

//   /// Patch a specific set of [fields] for a user by [userId].
//   Future<void> _patchUser(String userId, Map<String, dynamic> fields) async {
//     await _db.update(
//       DbConstants.tableUsers,
//       {...fields, DbConstants.colUpdatedAt: DateTime.now().toIso8601String()},
//       where: '${DbConstants.colId} = ?',
//       whereArgs: [userId],
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // CREATE / READ / UPDATE / DELETE
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<UserModel> createUser(UserModel user) async {
//     try {
//       final existing = await getUserByEmail(user.email);
//       if (existing != null) {
//         throw Exception('User with this email already exists');
//       }
//       await _db.insert(
//         DbConstants.tableUsers,
//         UserModel.fromEntity(user).toMap(),
//       );
//       return user;
//     } catch (e) {
//       throw Exception('Failed to create user: $e');
//     }
//   }

//   @override
//   Future<UserModel?> getUserById(String id) async {
//     try {
//       final rows = await _db.queryWhere(
//         DbConstants.tableUsers,
//         where: '${DbConstants.colId} = ?',
//         whereArgs: [id],
//         limit: 1,
//       );
//       if (rows.isEmpty) return null;
//       return UserModel.fromMap(rows.first);
//     } catch (e) {
//       throw Exception('Failed to get user: $e');
//     }
//   }

//   @override
//   Future<UserModel?> getUserByEmail(String email) async {
//     try {
//       final rows = await _db.queryWhere(
//         DbConstants.tableUsers,
//         where: 'LOWER(${DbConstants.colUserEmail}) = LOWER(?)',
//         whereArgs: [email],
//         limit: 1,
//       );
//       if (rows.isEmpty) return null;
//       return UserModel.fromMap(rows.first);
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<UserModel?> getCurrentUser() async {
//     try {
//       final rows = await _db.queryWhere(
//         DbConstants.tableUsers,
//         where: '${DbConstants.colUserIsLoggedIn} = ?',
//         whereArgs: [1],
//         limit: 1,
//       );
//       if (rows.isEmpty) return null;
//       return UserModel.fromMap(rows.first);
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<UserModel> updateUser(UserModel user) async {
//     try {
//       await _db.update(
//         DbConstants.tableUsers,
//         UserModel.fromEntity(user).toMap()
//           ..[DbConstants.colUpdatedAt] = DateTime.now().toIso8601String(),
//         where: '${DbConstants.colId} = ?',
//         whereArgs: [user.id],
//       );
//       return user;
//     } catch (e) {
//       throw Exception('Failed to update user: $e');
//     }
//   }

//   @override
//   Future<void> deleteUser(String id) async {
//     try {
//       await _db.delete(
//         DbConstants.tableUsers,
//         where: '${DbConstants.colId} = ?',
//         whereArgs: [id],
//       );
//     } catch (e) {
//       throw Exception('Failed to delete user: $e');
//     }
//   }

//   @override
//   Future<List<UserModel>> getAllUsers() async {
//     try {
//       final rows = await _db.queryAll(DbConstants.tableUsers);
//       return rows.map((r) => UserModel.fromMap(r)).toList();
//     } catch (e) {
//       throw Exception('Failed to get all users: $e');
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // AUTH / SESSION
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<void> loginUser(String userId) async {
//     try {
//       // Ensure only one user is logged in at a time
//       await logoutAllUsers();
//       await _patchUser(userId, {
//         DbConstants.colUserIsLoggedIn: 1,
//         DbConstants.colUserLastLoginAt: DateTime.now().toIso8601String(),
//       });
//     } catch (e) {
//       throw Exception('Failed to login user: $e');
//     }
//   }

//   @override
//   Future<void> logoutCurrentUser() async {
//     try {
//       await _db.update(
//         DbConstants.tableUsers,
//         {
//           DbConstants.colUserIsLoggedIn: 0,
//           DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
//         },
//         where: '${DbConstants.colUserIsLoggedIn} = ?',
//         whereArgs: [1],
//       );
//     } catch (e) {
//       throw Exception('Failed to logout user: $e');
//     }
//   }

//   @override
//   Future<void> logoutAllUsers() async {
//     try {
//       await _db.update(
//         DbConstants.tableUsers,
//         {
//           DbConstants.colUserIsLoggedIn: 0,
//           DbConstants.colUpdatedAt: DateTime.now().toIso8601String(),
//         },
//         where: '${DbConstants.colUserIsLoggedIn} = ?',
//         whereArgs: [1],
//       );
//     } catch (e) {
//       throw Exception('Failed to logout all users: $e');
//     }
//   }

//   @override
//   Future<bool> isAnyUserLoggedIn() async {
//     try {
//       final rows = await _db.queryWhere(
//         DbConstants.tableUsers,
//         where: '${DbConstants.colUserIsLoggedIn} = ?',
//         whereArgs: [1],
//         limit: 1,
//       );
//       return rows.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }

//   @override
//   Future<UserModel?> authenticateUser(String email, String password) async {
//     try {
//       final user = await getUserByEmail(email);
//       if (user == null) return null;

//       if (user.passwordHash == password) {
//         await loginUser(user.id);
//         return await getCurrentUser();
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to authenticate user: $e');
//     }
//   }

//   @override
//   Future<UserModel?> authenticateWithPin(String pin) async {
//     try {
//       final user = await getUserByPin(pin);
//       if (user == null) return null;

//       await loginUser(user.id);
//       return await getCurrentUser();
//     } catch (e) {
//       return null;
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // FIELD-LEVEL UPDATES  (patch only the changed column — no full re-write)
//   // ═══════════════════════════════════════════════════════════════════════════

//   @override
//   Future<void> updatePassword(String userId, String newPasswordHash) async {
//     try {
//       await _patchUser(userId, {
//         DbConstants.colUserPasswordHash: newPasswordHash,
//       });
//     } catch (e) {
//       throw Exception('Failed to update password: $e');
//     }
//   }

//   @override
//   Future<void> updatePin(String userId, String? newPin) async {
//     try {
//       await _patchUser(userId, {DbConstants.colUserPin: newPin});
//     } catch (e) {
//       throw Exception('Failed to update PIN: $e');
//     }
//   }

//   @override
//   Future<void> toggleBiometric(String userId, bool enabled) async {
//     try {
//       await _patchUser(userId, {
//         DbConstants.colUserUseBiometric: enabled ? 1 : 0,
//       });
//     } catch (e) {
//       throw Exception('Failed to toggle biometric: $e');
//     }
//   }

//   @override
//   Future<void> updateLastLogin(String userId) async {
//     try {
//       await _patchUser(userId, {
//         DbConstants.colUserLastLoginAt: DateTime.now().toIso8601String(),
//       });
//     } catch (e) {
//       throw Exception('Failed to update last login: $e');
//     }
//   }

//   @override
//   Future<UserModel?> getUserByPin(String pin) async {
//     try {
//       final rows = await _db.queryWhere(
//         DbConstants.tableUsers,
//         where: '${DbConstants.colUserPin} = ?',
//         whereArgs: [pin],
//         limit: 1,
//       );
//       if (rows.isEmpty) return null;
//       return UserModel.fromMap(rows.first);
//     } catch (_) {
//       return null;
//     }
//   }
// }
