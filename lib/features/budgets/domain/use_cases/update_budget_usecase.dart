import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/domain/repository/budget_repository.dart';
import 'package:expense_mate/core/domain/use_cases/use_case.dart';
import 'package:expense_mate/core/error/failure.dart';
import 'package:expense_mate/core/utils/either.dart';

class UpdateBudgetUseCase implements UseCase<BudgetModel, UpdateBudgetParams> {
  final BudgetRepository repository;

  UpdateBudgetUseCase({required this.repository});

  @override
  Future<Either<Failure, BudgetModel>> call(UpdateBudgetParams params) async {
    final budgetResult = repository.getAllBudgets();

    return budgetResult.fold((failure) => Left(failure), (budgets) async {
      final budget = budgets.firstWhere(
        (b) => b.id == params.budgetId,
        orElse: () => throw Exception('Budget not found'),
      );

      final updatedBudget = BudgetModel(
        id: budget.id,
        name: params.name ?? budget.name,
        type: budget.type,
        totalAmount: params.totalAmount ?? budget.totalAmount,
        spentAmount: budget.spentAmount,
        startDate: budget.startDate,
        endDate: budget.endDate,
        transactionIds: budget.transactionIds,
        category: budget.category,
        icon: budget.icon,
        colorCode: budget.colorCode,
        isActive: params.isActive ?? budget.isActive,
        isArchived: params.isArchived ?? budget.isArchived,
        createdAt: budget.createdAt,
        userId: budget.userId,
        updatedAt: DateTime.now(),
      );

      final updateResult = await repository.updateBudget(updatedBudget);

      return updateResult.fold(
        (failure) => Left(failure),
        (_) => Right(updatedBudget), // ✅ THIS IS THE FIX
      );
    });
  }
}

// Update Budget
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
