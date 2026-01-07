import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 10)
enum TransactionType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

@HiveType(typeId: 11)
enum DebtType {
  @HiveField(0)
  borrowed,

  @HiveField(1)
  lent,
}

@HiveType(typeId: 12)
enum PaymentMethod {
  @HiveField(0)
  cash,

  @HiveField(1)
  card,

  @HiveField(2)
  bank,

  @HiveField(3)
  wallet,
}

@HiveType(typeId: 13)
enum BudgetType {
  @HiveField(0)
  monthly,

  @HiveField(1)
  project,

  @HiveField(2)
  custom,
}

@HiveType(typeId: 15)
enum RecurrenceFrequency {
  @HiveField(0)
  daily,

  @HiveField(1)
  weekly,

  @HiveField(2)
  biweekly, // Every 2 weeks

  @HiveField(3)
  monthly,

  @HiveField(4)
  quarterly, // Every 3 months

  @HiveField(5)
  yearly,
}
