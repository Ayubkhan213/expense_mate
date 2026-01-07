// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 10;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.income;
      case 1:
        return TransactionType.expense;
      default:
        return TransactionType.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.income:
        writer.writeByte(0);
        break;
      case TransactionType.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DebtTypeAdapter extends TypeAdapter<DebtType> {
  @override
  final int typeId = 11;

  @override
  DebtType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DebtType.borrowed;
      case 1:
        return DebtType.lent;
      default:
        return DebtType.borrowed;
    }
  }

  @override
  void write(BinaryWriter writer, DebtType obj) {
    switch (obj) {
      case DebtType.borrowed:
        writer.writeByte(0);
        break;
      case DebtType.lent:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentMethodAdapter extends TypeAdapter<PaymentMethod> {
  @override
  final int typeId = 12;

  @override
  PaymentMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentMethod.cash;
      case 1:
        return PaymentMethod.card;
      case 2:
        return PaymentMethod.bank;
      case 3:
        return PaymentMethod.wallet;
      default:
        return PaymentMethod.cash;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentMethod obj) {
    switch (obj) {
      case PaymentMethod.cash:
        writer.writeByte(0);
        break;
      case PaymentMethod.card:
        writer.writeByte(1);
        break;
      case PaymentMethod.bank:
        writer.writeByte(2);
        break;
      case PaymentMethod.wallet:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BudgetTypeAdapter extends TypeAdapter<BudgetType> {
  @override
  final int typeId = 13;

  @override
  BudgetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BudgetType.monthly;
      case 1:
        return BudgetType.project;
      case 2:
        return BudgetType.custom;
      default:
        return BudgetType.monthly;
    }
  }

  @override
  void write(BinaryWriter writer, BudgetType obj) {
    switch (obj) {
      case BudgetType.monthly:
        writer.writeByte(0);
        break;
      case BudgetType.project:
        writer.writeByte(1);
        break;
      case BudgetType.custom:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceFrequencyAdapter extends TypeAdapter<RecurrenceFrequency> {
  @override
  final int typeId = 15;

  @override
  RecurrenceFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurrenceFrequency.daily;
      case 1:
        return RecurrenceFrequency.weekly;
      case 2:
        return RecurrenceFrequency.biweekly;
      case 3:
        return RecurrenceFrequency.monthly;
      case 4:
        return RecurrenceFrequency.quarterly;
      case 5:
        return RecurrenceFrequency.yearly;
      default:
        return RecurrenceFrequency.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RecurrenceFrequency obj) {
    switch (obj) {
      case RecurrenceFrequency.daily:
        writer.writeByte(0);
        break;
      case RecurrenceFrequency.weekly:
        writer.writeByte(1);
        break;
      case RecurrenceFrequency.biweekly:
        writer.writeByte(2);
        break;
      case RecurrenceFrequency.monthly:
        writer.writeByte(3);
        break;
      case RecurrenceFrequency.quarterly:
        writer.writeByte(4);
        break;
      case RecurrenceFrequency.yearly:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
