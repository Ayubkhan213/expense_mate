// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 6;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      phoneNumber: fields[3] as String?,
      profilePicturePath: fields[4] as String?,
      currency: fields[5] as String,
      passwordHash: fields[6] as String?,
      isLoggedIn: fields[7] as bool,
      createdAt: fields[8] as DateTime?,
      lastLoginAt: fields[9] as DateTime?,
      pin: fields[10] as String?,
      useBiometric: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.profilePicturePath)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.passwordHash)
      ..writeByte(7)
      ..write(obj.isLoggedIn)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.lastLoginAt)
      ..writeByte(10)
      ..write(obj.pin)
      ..writeByte(11)
      ..write(obj.useBiometric);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
