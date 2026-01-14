// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      type: fields[1] as TransactionType,
      items: (fields[2] as List).cast<TransactionItem>(),
      totalAmount: fields[3] as double,
      paymentMethod: fields[4] as PaymentMethod,
      date: fields[5] as DateTime,
      isDebt: fields[6] as bool,
      debtId: fields[7] as String?,
      tags: (fields[8] as List?)?.cast<String>(),
      attachmentPath: fields[9] as String?,
      isRecurring: fields[10] as bool,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
      isDeleted: fields[13] as bool,
      budgetId: fields[14] as String?,
      userId: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.paymentMethod)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.isDebt)
      ..writeByte(7)
      ..write(obj.debtId)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.attachmentPath)
      ..writeByte(10)
      ..write(obj.isRecurring)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.isDeleted)
      ..writeByte(14)
      ..write(obj.budgetId)
      ..writeByte(15)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
