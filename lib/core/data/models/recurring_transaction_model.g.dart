// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringTransactionModelAdapter
    extends TypeAdapter<RecurringTransactionModel> {
  @override
  final int typeId = 7;

  @override
  RecurringTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringTransactionModel(
      id: fields[0] as String,
      categoryKey: fields[1] as String,
      amount: fields[2] as double,
      note: fields[3] as String?,
      frequency: fields[4] as RecurrenceFrequency,
      type: fields[5] as TransactionType,
      paymentMethod: fields[6] as PaymentMethod,
      startDate: fields[7] as DateTime,
      endDate: fields[8] as DateTime?,
      nextOccurrence: fields[9] as DateTime,
      generatedTransactionIds: (fields[10] as List).cast<String>(),
      isActive: fields[11] as bool,
      dayOfMonth: fields[12] as int,
      dayOfWeek: fields[13] as int?,
      createdAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringTransactionModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryKey)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.paymentMethod)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.nextOccurrence)
      ..writeByte(10)
      ..write(obj.generatedTransactionIds)
      ..writeByte(11)
      ..write(obj.isActive)
      ..writeByte(12)
      ..write(obj.dayOfMonth)
      ..writeByte(13)
      ..write(obj.dayOfWeek)
      ..writeByte(14)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
