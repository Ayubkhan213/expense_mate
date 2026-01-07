// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtPaymentModelAdapter extends TypeAdapter<DebtPaymentModel> {
  @override
  final int typeId = 8;

  @override
  DebtPaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtPaymentModel(
      id: fields[0] as String,
      debtId: fields[1] as String,
      amount: fields[2] as double,
      paymentDate: fields[3] as DateTime,
      note: fields[4] as String?,
      paymentMethod: fields[5] as PaymentMethod,
      transactionId: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DebtPaymentModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.debtId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.paymentDate)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.paymentMethod)
      ..writeByte(6)
      ..write(obj.transactionId)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtPaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
