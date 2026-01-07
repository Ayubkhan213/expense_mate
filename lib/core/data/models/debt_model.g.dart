// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtModelAdapter extends TypeAdapter<DebtModel> {
  @override
  final int typeId = 3;

  @override
  DebtModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtModel(
      id: fields[0] as String,
      transactionId: fields[1] as String,
      personName: fields[2] as String,
      totalAmount: fields[3] as double,
      debtType: fields[4] as DebtType,
      expectedReturnDate: fields[5] as DateTime,
      isReturned: fields[6] as bool,
      paymentIds: (fields[7] as List).cast<String>(),
      paidAmount: fields[8] as double,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
      personPhone: fields[11] as String?,
      personImage: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DebtModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.transactionId)
      ..writeByte(2)
      ..write(obj.personName)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.debtType)
      ..writeByte(5)
      ..write(obj.expectedReturnDate)
      ..writeByte(6)
      ..write(obj.isReturned)
      ..writeByte(7)
      ..write(obj.paymentIds)
      ..writeByte(8)
      ..write(obj.paidAmount)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.personPhone)
      ..writeByte(12)
      ..write(obj.personImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
