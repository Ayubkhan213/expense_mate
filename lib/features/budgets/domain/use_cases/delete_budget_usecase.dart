import 'package:spendio/core/domain/use_cases/use_case.dart';
import 'package:spendio/core/error/failure.dart';
import 'package:spendio/core/utils/either.dart';
import 'package:spendio/features/budgets/domain/repository/budget_repository.dart';

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
