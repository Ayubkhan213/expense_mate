import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/services/hive_box_manager.dart';
import 'package:hive/hive.dart';

abstract class HomeDatasource {
  List<DebtPaymentModel> getPaymentsByDebtId(String debtId);
  List<DebtModel> getAllDebts();
}

class HomeDatasourceImp extends HomeDatasource {
  Box<DebtPaymentModel> get _debtpaymentBox => HiveBoxManager.debtPayments;
  Box<DebtModel> get _debtBox => HiveBoxManager.debts;
  @override
  List<DebtPaymentModel> getPaymentsByDebtId(String debtId) {
    return _debtpaymentBox.values.where((p) => p.debtId == debtId).toList()
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  @override
  List<DebtModel> getAllDebts() {
    return _debtBox.values.toList();
  }
}
