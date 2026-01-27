import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';

abstract class HomeRepository {
  List<DebtPaymentModel> getPaymentsByDebtId(String debtId);
  List<DebtModel> getAllDebts();
}
