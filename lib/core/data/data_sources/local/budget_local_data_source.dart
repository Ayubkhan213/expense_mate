import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/services/hive_box_manager.dart';
import 'package:hive/hive.dart';

abstract class BudgetLocalDataSource {
  Future<String> createBudget(BudgetModel budget);
  BudgetModel? getBudgetById(String id);
  List<BudgetModel> getAllBudgets();
  List<BudgetModel> getActiveBudgets();
  List<BudgetModel> getArchivedBudgets();
  List<BudgetModel> getBudgetsByType(BudgetType type);
  List<BudgetModel> getOverBudgets();
  List<BudgetModel> getExpiredBudgets();
  Future<void> updateBudget(BudgetModel budget);
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  );
  Future<void> removeTransactionFromBudget(
    String budgetId,
    String transactionId,
    double amount,
  );
  Future<void> archiveBudget(String id);
  Future<void> deleteBudget(String id);
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  Box<BudgetModel> get _box => HiveBoxManager.budgets;

  @override
  Future<String> createBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget);
    return budget.id;
  }

  @override
  BudgetModel? getBudgetById(String id) {
    return _box.get(id);
  }

  @override
  List<BudgetModel> getAllBudgets() {
    return _box.values.toList();
  }

  @override
  List<BudgetModel> getActiveBudgets() {
    return _box.values
        .where((b) => b.isActive && !b.isArchived && !b.isExpired)
        .toList();
  }

  @override
  List<BudgetModel> getArchivedBudgets() {
    return _box.values.where((b) => b.isArchived).toList();
  }

  @override
  List<BudgetModel> getBudgetsByType(BudgetType type) {
    return _box.values.where((b) => b.type == type && !b.isArchived).toList();
  }

  @override
  List<BudgetModel> getOverBudgets() {
    return _box.values.where((b) => b.isOverBudget && !b.isArchived).toList();
  }

  @override
  List<BudgetModel> getExpiredBudgets() {
    return _box.values.where((b) => b.isExpired && !b.isArchived).toList();
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    final updated = BudgetModel(
      id: budget.id,
      name: budget.name,
      type: budget.type,
      totalAmount: budget.totalAmount,
      spentAmount: budget.spentAmount,
      startDate: budget.startDate,
      endDate: budget.endDate,
      transactionIds: budget.transactionIds,
      category: budget.category,
      icon: budget.icon,
      colorCode: budget.colorCode,
      isActive: budget.isActive,
      isArchived: budget.isArchived,
      createdAt: budget.createdAt,
      updatedAt: DateTime.now(),
    );
    await _box.put(budget.id, updated);
  }

  @override
  Future<void> addTransactionToBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) async {
    final budget = _box.get(budgetId);
    if (budget != null) {
      final updatedTransactionIds = List<String>.from(budget.transactionIds)
        ..add(transactionId);

      final updated = BudgetModel(
        id: budget.id,
        name: budget.name,
        type: budget.type,
        totalAmount: budget.totalAmount,
        spentAmount: budget.spentAmount + amount,
        startDate: budget.startDate,
        endDate: budget.endDate,
        transactionIds: updatedTransactionIds,
        category: budget.category,
        icon: budget.icon,
        colorCode: budget.colorCode,
        isActive: budget.isActive,
        isArchived: budget.isArchived,
        createdAt: budget.createdAt,
        updatedAt: DateTime.now(),
      );
      await _box.put(budgetId, updated);
    }
  }

  @override
  Future<void> removeTransactionFromBudget(
    String budgetId,
    String transactionId,
    double amount,
  ) async {
    final budget = _box.get(budgetId);
    if (budget != null) {
      final updatedTransactionIds = List<String>.from(budget.transactionIds)
        ..remove(transactionId);

      final updated = BudgetModel(
        id: budget.id,
        name: budget.name,
        type: budget.type,
        totalAmount: budget.totalAmount,
        spentAmount: (budget.spentAmount - amount).clamp(0.0, double.infinity),
        startDate: budget.startDate,
        endDate: budget.endDate,
        transactionIds: updatedTransactionIds,
        category: budget.category,
        icon: budget.icon,
        colorCode: budget.colorCode,
        isActive: budget.isActive,
        isArchived: budget.isArchived,
        createdAt: budget.createdAt,
        updatedAt: DateTime.now(),
      );
      await _box.put(budgetId, updated);
    }
  }

  @override
  Future<void> archiveBudget(String id) async {
    final budget = _box.get(id);
    if (budget != null) {
      final updated = BudgetModel(
        id: budget.id,
        name: budget.name,
        type: budget.type,
        totalAmount: budget.totalAmount,
        spentAmount: budget.spentAmount,
        startDate: budget.startDate,
        endDate: budget.endDate,
        transactionIds: budget.transactionIds,
        category: budget.category,
        icon: budget.icon,
        colorCode: budget.colorCode,
        isActive: false,
        isArchived: true,
        createdAt: budget.createdAt,
        updatedAt: DateTime.now(),
      );
      await _box.put(id, updated);
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }
}
