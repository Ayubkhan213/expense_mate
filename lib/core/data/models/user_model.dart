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
  final String? profilePicturePath; // Local file path

  @HiveField(5)
  final String currency; // "USD", "EUR", "PKR", etc.

  @HiveField(6)
  final String? passwordHash; // For local authentication

  @HiveField(7)
  final bool isLoggedIn;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime lastLoginAt;

  @HiveField(10)
  final String? pin; // 4-digit PIN for quick access

  @HiveField(11)
  final bool useBiometric; // Fingerprint/Face ID

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
  }) : createdAt = createdAt ?? DateTime.now(),
       lastLoginAt = lastLoginAt ?? DateTime.now();
  UserModel copyWith({bool? isLoggedIn, DateTime? lastLoginAt}) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profilePicturePath: profilePicturePath,
      currency: currency,
      passwordHash: passwordHash,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      pin: pin,
      useBiometric: useBiometric,
    );
  }
}
