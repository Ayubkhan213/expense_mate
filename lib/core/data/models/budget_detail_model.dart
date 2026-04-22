import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/transcation_sql_model.dart';

class BudgetDetailsData {
  final BudgetModel budget;
  final List<TransactionModel> transactions;

  BudgetDetailsData({required this.budget, required this.transactions});
}
