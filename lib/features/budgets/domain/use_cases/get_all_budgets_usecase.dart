// Get All Budgets
import 'package:expense_mate/core/data/models/budget_model.dart';

import 'package:expense_mate/core/domain/use_cases/use_case.dart';
import 'package:expense_mate/core/error/failure.dart';
import 'package:expense_mate/core/utils/either.dart';
import 'package:expense_mate/features/budgets/domain/repository/budget_repository.dart';

class GetAllBudgetsUseCase implements UseCase<List<BudgetModel>, NoParams> {
  final BudgetRepository repository;

  GetAllBudgetsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<BudgetModel>>> call(NoParams params) async {
    return repository.getAllBudgets();
  }
}
