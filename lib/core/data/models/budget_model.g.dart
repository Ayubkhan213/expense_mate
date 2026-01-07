// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetModelAdapter extends TypeAdapter<BudgetModel> {
  @override
  final int typeId = 4;

  @override
  BudgetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as BudgetType,
      totalAmount: fields[3] as double,
      spentAmount: fields[4] as double,
      startDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime,
      transactionIds: (fields[7] as List).cast<String>(),
      category: fields[8] as String?,
      icon: fields[9] as String?,
      colorCode: fields[10] as int?,
      isActive: fields[11] as bool,
      isArchived: fields[12] as bool,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.spentAmount)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.transactionIds)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.icon)
      ..writeByte(10)
      ..write(obj.colorCode)
      ..writeByte(11)
      ..write(obj.isActive)
      ..writeByte(12)
      ..write(obj.isArchived)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetModelAdapter &&
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
