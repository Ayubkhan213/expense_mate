import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 6)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? profilePicturePath; // Permanent local path inside app storage

  @HiveField(5)
  final String currency;

  @HiveField(6)
  final String? passwordHash;

  @HiveField(7)
  final bool isLoggedIn;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime lastLoginAt;

  @HiveField(10)
  final String? pin;

  @HiveField(11)
  final bool useBiometric;

  // ── Security Questions (fields 12-15) ──────────────────────────────────────
  @HiveField(12)
  final String? securityQuestion1;

  @HiveField(13)
  final String? securityAnswer1; // stored as plain text (hash later if needed)

  @HiveField(14)
  final String? securityQuestion2;

  @HiveField(15)
  final String? securityAnswer2;

  // ── Recovery Keys (field 16) ───────────────────────────────────────────────
  // List of 8 × 8-char alphanumeric keys, generated at signup
  @HiveField(16)
  final List<String>? recoveryKeys;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePicturePath,
    this.currency = 'USD',
    this.passwordHash,
    this.isLoggedIn = false,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    this.pin,
    this.useBiometric = false,
    this.securityQuestion1,
    this.securityAnswer1,
    this.securityQuestion2,
    this.securityAnswer2,
    this.recoveryKeys,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastLoginAt = lastLoginAt ?? DateTime.now();

  UserModel copyWith({
    bool? isLoggedIn,
    DateTime? lastLoginAt,
    String? profilePicturePath,
    String? securityQuestion1,
    String? securityAnswer1,
    String? securityQuestion2,
    String? securityAnswer2,
    List<String>? recoveryKeys,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      currency: currency,
      passwordHash: passwordHash,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      pin: pin,
      useBiometric: useBiometric,
      securityQuestion1: securityQuestion1 ?? this.securityQuestion1,
      securityAnswer1: securityAnswer1 ?? this.securityAnswer1,
      securityQuestion2: securityQuestion2 ?? this.securityQuestion2,
      securityAnswer2: securityAnswer2 ?? this.securityAnswer2,
      recoveryKeys: recoveryKeys ?? this.recoveryKeys,
    );
  }
}
