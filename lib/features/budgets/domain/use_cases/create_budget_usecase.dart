import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/core/domain/repository/budget_repository.dart';
import 'package:spendio/core/domain/use_cases/use_case.dart';
import 'package:spendio/core/error/failure.dart';
import 'package:spendio/core/services/app_prefs.dart';
import 'package:spendio/core/utils/either.dart';

import 'package:spendio/features/budgets/domain/repository/budget_repository.dart';
import 'package:uuid/uuid.dart';

class CreateBudgetUseCase implements UseCase<BudgetModel, CreateBudgetParams> {
  final BudgetRepository repository;

  CreateBudgetUseCase({required this.repository});

  @override
  Future<Either<Failure, BudgetModel>> call(CreateBudgetParams params) {
    final budget = BudgetModel(
      id: const Uuid().v4(),
      name: params.name,
      type: params.type,
      totalAmount: params.totalAmount,
      startDate: params.startDate,
      endDate: params.endDate,
      category: params.category,
      icon: params.icon,
      colorCode: params.colorCode,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: AppPrefs.instance.userId,
    );
    return repository.createBudget(budget);
  }
}

// Create Budget
class CreateBudgetParams {
  final String name;
  final BudgetType type;
  final double totalAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String? category;
  final String? icon;
  final int? colorCode;

  CreateBudgetParams({
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.startDate,
    required this.endDate,
    this.category,
    this.icon,
    this.colorCode,
  });
}
