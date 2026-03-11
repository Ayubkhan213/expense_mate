class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profilePicturePath;
  final String currency;
  final String? passwordHash;
  final bool isLoggedIn;
  final DateTime lastLoginAt;
  final String? pin;
  final bool useBiometric;
  final String? securityQuestion1;
  final String? securityAnswer1;
  final String? securityQuestion2;
  final String? securityAnswer2;
  final List<String>? recoveryKeys;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePicturePath,
    required this.currency,
    this.passwordHash,
    required this.isLoggedIn,
    required this.lastLoginAt,
    this.pin,
    required this.useBiometric,
    this.securityQuestion1,
    this.securityAnswer1,
    this.securityQuestion2,
    this.securityAnswer2,
    this.recoveryKeys,
    required this.createdAt,
    required this.updatedAt,
  });

  UserEntity copyWith({
    String? profilePicturePath,
    bool? isLoggedIn,
    DateTime? lastLoginAt,
    String? securityQuestion1,
    String? securityAnswer1,
    String? securityQuestion2,
    String? securityAnswer2,
    List<String>? recoveryKeys,
    DateTime? updatedAt,
  }) => UserEntity(
    id: id,
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    profilePicturePath: profilePicturePath ?? this.profilePicturePath,
    currency: currency,
    passwordHash: passwordHash,
    isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    pin: pin,
    useBiometric: useBiometric,
    securityQuestion1: securityQuestion1 ?? this.securityQuestion1,
    securityAnswer1: securityAnswer1 ?? this.securityAnswer1,
    securityQuestion2: securityQuestion2 ?? this.securityQuestion2,
    securityAnswer2: securityAnswer2 ?? this.securityAnswer2,
    recoveryKeys: recoveryKeys ?? this.recoveryKeys,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
