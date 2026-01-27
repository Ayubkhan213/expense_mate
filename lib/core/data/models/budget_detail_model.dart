import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';

class BudgetDetailsData {
  final BudgetModel budget;
  final List<TransactionModel> transactions;

  BudgetDetailsData({required this.budget, required this.transactions});
}
