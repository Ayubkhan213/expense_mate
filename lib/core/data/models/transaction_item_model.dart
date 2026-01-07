import 'package:hive/hive.dart';

part 'transaction_item_model.g.dart';

@HiveType(typeId: 2)
class TransactionItem {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String? note;

  TransactionItem({required this.category, required this.amount, this.note});
}
