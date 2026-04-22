import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/domain/use_cases/use_case.dart';
import 'package:spendio/core/error/failure.dart';
import 'package:spendio/core/utils/either.dart';
import 'package:spendio/features/budgets/domain/repository/budget_repository.dart';

class UpdateBudgetUseCase implements UseCase<BudgetModel, UpdateBudgetParams> {
  final BudgetRepository repository;

  UpdateBudgetUseCase({required this.repository});

  @override
  Future<Either<Failure, BudgetModel>> call(UpdateBudgetParams params) async {
    final budgetResult = await repository.getAllBudgets();

    return budgetResult.fold((failure) => Left(failure), (budgets) async {
      final list = budgets ?? <BudgetModel>[];

      BudgetModel? budget;
      try {
        budget = list.firstWhere((b) => b.id == params.budgetId);
      } catch (_) {
        return Left(CacheFailure('Budget not found'));
      }

      // ✅ Build directly — no copyWith needed
      final updatedBudget = BudgetModel(
        id: budget.id,
        userId: budget.userId,
        name: params.name ?? budget.name,
        type: budget.type,
        totalAmount: params.totalAmount ?? budget.totalAmount,
        spentAmount: budget.spentAmount, // ✅ locked
        startDate: budget.startDate,
        endDate: budget.endDate,
        transactionIds: budget.transactionIds,
        category: budget.category,
        icon: budget.icon,
        colorCode: budget.colorCode,
        isActive: params.isActive ?? budget.isActive,
        isArchived: params.isArchived ?? budget.isArchived,
        createdAt: budget.createdAt,
        updatedAt: DateTime.now(),
      );

      final updateResult = await repository.updateBudget(updatedBudget);

      return updateResult.fold(
        (failure) => Left(failure),
        (_) => Right(updatedBudget),
      );
    });
  }
}

class UpdateBudgetParams {
  final String budgetId;
  final String? name;
  final double? totalAmount;
  final bool? isActive;
  final bool? isArchived;

  UpdateBudgetParams({
    required this.budgetId,
    this.name,
    this.totalAmount,
    this.isActive,
    this.isArchived,
  });
}
