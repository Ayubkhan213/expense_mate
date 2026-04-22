// Get All Budgets
import 'package:spendio/core/data/models/budget_model.dart';

import 'package:spendio/core/domain/use_cases/use_case.dart';
import 'package:spendio/core/error/failure.dart';
import 'package:spendio/core/utils/either.dart';
import 'package:spendio/features/budgets/domain/repository/budget_repository.dart';

class GetAllBudgetsUseCase implements UseCase<List<BudgetModel>, NoParams> {
  final BudgetRepository repository;

  GetAllBudgetsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<BudgetModel>>> call(NoParams params) async {
    return repository.getAllBudgets();
  }
}
