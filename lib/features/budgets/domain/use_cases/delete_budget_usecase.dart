import 'package:expense_mate/core/domain/use_cases/use_case.dart';
import 'package:expense_mate/core/error/failure.dart';
import 'package:expense_mate/core/utils/either.dart';
import 'package:expense_mate/features/budgets/domain/repository/budget_repository.dart';

class DeleteBudgetUseCase implements UseCase<void, String> {
  final BudgetRepository repository;

  DeleteBudgetUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(String id) async {
    try {
      await repository.deleteBudget(id);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
