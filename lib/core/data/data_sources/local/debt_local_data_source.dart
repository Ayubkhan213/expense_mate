import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/services/hive_box_manager.dart';
import 'package:hive/hive.dart';

abstract class DebtLocalDataSource {
  Future<String> createDebt(DebtModel debt);
  DebtModel? getDebtById(String id);
  DebtModel? getDebtByTransactionId(String transactionId);
  List<DebtModel> getAllDebts();
  List<DebtModel> getActiveDebts();
  List<DebtModel> getSettledDebts();
  List<DebtModel> getDebtsByType(DebtType type);
  List<DebtModel> getOverdueDebts();
  Future<void> updateDebt(DebtModel debt);
  Future<void> addPayment(DebtPaymentModel payment);
  List<DebtPaymentModel> getPaymentsForDebt(String debtId);
  Future<void> deleteDebt(String id);
}

class DebtLocalDataSourceImpl implements DebtLocalDataSource {
  Box<DebtModel> get _debtBox => HiveBoxManager.debts;
  Box<DebtPaymentModel> get _paymentBox => HiveBoxManager.debtPayments;

  @override
  Future<String> createDebt(DebtModel debt) async {
    await _debtBox.put(debt.id, debt);
    return debt.id;
  }

  @override
  DebtModel? getDebtById(String id) {
    return _debtBox.get(id);
  }

  @override
  DebtModel? getDebtByTransactionId(String transactionId) {
    try {
      return _debtBox.values.firstWhere(
        (d) => d.transactionId == transactionId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  List<DebtModel> getAllDebts() {
    return _debtBox.values.toList();
  }

  @override
  List<DebtModel> getActiveDebts() {
    return _debtBox.values.where((d) => !d.isReturned).toList();
  }

  @override
  List<DebtModel> getSettledDebts() {
    return _debtBox.values.where((d) => d.isReturned).toList();
  }

  @override
  List<DebtModel> getDebtsByType(DebtType type) {
    return _debtBox.values.where((d) => d.debtType == type).toList();
  }

  @override
  List<DebtModel> getOverdueDebts() {
    return _debtBox.values.where((d) => d.isOverdue).toList();
  }

  @override
  Future<void> updateDebt(DebtModel debt) async {
    debt.updatedAt = DateTime.now();
    await debt.save();
  }

  @override
  Future<void> addPayment(DebtPaymentModel payment) async {
    await _paymentBox.put(payment.id, payment);

    final debt = _debtBox.get(payment.debtId);
    if (debt != null) {
      debt.paidAmount += payment.amount;
      debt.paymentIds.add(payment.id);

      // Check if fully paid
      if (debt.paidAmount >= debt.totalAmount) {
        debt.isReturned = true;
      }

      debt.updatedAt = DateTime.now();
      await debt.save();
    }
  }

  @override
  List<DebtPaymentModel> getPaymentsForDebt(String debtId) {
    return _paymentBox.values.where((p) => p.debtId == debtId).toList();
  }

  @override
  Future<void> deleteDebt(String id) async {
    await _debtBox.delete(id);
  }
}
