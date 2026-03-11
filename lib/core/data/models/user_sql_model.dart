import 'dart:convert';

import 'package:expense_mate/core/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.profilePicturePath,
    required super.currency,
    super.passwordHash,
    required super.isLoggedIn,
    required super.lastLoginAt,
    super.pin,
    required super.useBiometric,
    super.securityQuestion1,
    super.securityAnswer1,
    super.securityQuestion2,
    super.securityAnswer2,
    super.recoveryKeys,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] as String,
    name: map['name'] as String,
    email: map['email'] as String,
    phoneNumber: map['phone_number'] as String?,
    profilePicturePath: map['profile_picture_path'] as String?,
    currency: map['currency'] as String? ?? 'USD',
    passwordHash: map['password_hash'] as String?,
    isLoggedIn: (map['is_logged_in'] as int? ?? 0) == 1,
    lastLoginAt: DateTime.parse(map['last_login_at'] as String),
    pin: map['pin'] as String?,
    useBiometric: (map['use_biometric'] as int? ?? 0) == 1,
    securityQuestion1: map['security_question_1'] as String?,
    securityAnswer1: map['security_answer_1'] as String?,
    securityQuestion2: map['security_question_2'] as String?,
    securityAnswer2: map['security_answer_2'] as String?,
    recoveryKeys: map['recovery_keys'] != null
        ? List<String>.from(jsonDecode(map['recovery_keys'] as String))
        : null,
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'phone_number': phoneNumber,
    'profile_picture_path': profilePicturePath,
    'currency': currency,
    'password_hash': passwordHash,
    'is_logged_in': isLoggedIn ? 1 : 0,
    'last_login_at': lastLoginAt.toIso8601String(),
    'pin': pin,
    'use_biometric': useBiometric ? 1 : 0,
    'security_question_1': securityQuestion1,
    'security_answer_1': securityAnswer1,
    'security_question_2': securityQuestion2,
    'security_answer_2': securityAnswer2,
    'recovery_keys': recoveryKeys != null ? jsonEncode(recoveryKeys) : null,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory UserModel.fromEntity(UserEntity e) => UserModel(
    id: e.id,
    name: e.name,
    email: e.email,
    phoneNumber: e.phoneNumber,
    profilePicturePath: e.profilePicturePath,
    currency: e.currency,
    passwordHash: e.passwordHash,
    isLoggedIn: e.isLoggedIn,
    lastLoginAt: e.lastLoginAt,
    pin: e.pin,
    useBiometric: e.useBiometric,
    securityQuestion1: e.securityQuestion1,
    securityAnswer1: e.securityAnswer1,
    securityQuestion2: e.securityQuestion2,
    securityAnswer2: e.securityAnswer2,
    recoveryKeys: e.recoveryKeys,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
  );
}
