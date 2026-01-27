import 'package:expense_mate/core/data/models/debt_model.dart';
import 'package:expense_mate/core/data/models/debt_payment_model.dart';
import 'package:expense_mate/features/home/data/data_source/home_datasource.dart';
import 'package:expense_mate/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImp extends HomeRepository {
  final HomeDatasource homeDatasource;
  HomeRepositoryImp({required this.homeDatasource});
  @override
  List<DebtPaymentModel> getPaymentsByDebtId(String debtId) {
    return homeDatasource.getPaymentsByDebtId(debtId);
  }

  @override
  List<DebtModel> getAllDebts() {
    // You can sort by creation date if needed
    final debts = homeDatasource.getAllDebts();
    debts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return debts;
  }
}
