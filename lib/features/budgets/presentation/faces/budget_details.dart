import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/transaction_model.dart';
import 'package:expense_mate/core/utils/enum.dart';

import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_detail_state.dart';

import 'package:intl/intl.dart';

class BudgetDetailsFace extends StatefulWidget {
  final BudgetModel budget;

  const BudgetDetailsFace({super.key, required this.budget});

  @override
  State<BudgetDetailsFace> createState() => _BudgetDetailsFaceState();
}

class _BudgetDetailsFaceState extends State<BudgetDetailsFace> {
  @override
  void initState() {
    super.initState();
    // Load budget details when screen opens
    context.read<BudgetDetailsBloc>().add(
      LoadBudgetDetailsEvent(widget.budget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.budget.name),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BudgetDetailsBloc>().add(
                RefreshBudgetDetailsEvent(widget.budget.id),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: BlocConsumer<BudgetDetailsBloc, BudgetDetailsState>(
        listener: (context, state) {
          if (state.status == BudgetDetailsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == BudgetDetailsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == BudgetDetailsStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'An error occurred'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BudgetDetailsBloc>().add(
                        LoadBudgetDetailsEvent(widget.budget.id),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Budget Summary Card
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Budget',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rs ${widget.budget.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: state.progressPercentage,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            state.progressPercentage > 0.9
                                ? Colors.red
                                : Colors.white,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Spent',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs ${state.totalSpent.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Remaining',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs ${state.remainingAmount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: state.remainingAmount < 0
                                      ? Colors.red.shade200
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Filter Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          isSelected:
                              state.selectedFilter == TransactionFilter.all,
                          onTap: () {
                            context.read<BudgetDetailsBloc>().add(
                              const FilterBudgetTransactionsEvent(
                                TransactionFilter.all,
                              ),
                            );
                          },
                        ),
                        _FilterChip(
                          label: 'This Week',
                          isSelected:
                              state.selectedFilter ==
                              TransactionFilter.thisWeek,
                          onTap: () {
                            context.read<BudgetDetailsBloc>().add(
                              const FilterBudgetTransactionsEvent(
                                TransactionFilter.thisWeek,
                              ),
                            );
                          },
                        ),
                        _FilterChip(
                          label: 'This Month',
                          isSelected:
                              state.selectedFilter ==
                              TransactionFilter.thisMonth,
                          onTap: () {
                            context.read<BudgetDetailsBloc>().add(
                              const FilterBudgetTransactionsEvent(
                                TransactionFilter.thisMonth,
                              ),
                            );
                          },
                        ),
                        _FilterChip(
                          label: 'Custom',
                          isSelected:
                              state.selectedFilter == TransactionFilter.custom,
                          onTap: () {
                            context.read<BudgetDetailsBloc>().add(
                              const FilterBudgetTransactionsEvent(
                                TransactionFilter.custom,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Transactions List
              state.filteredTransactions.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to add your first transaction',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final transaction = state.filteredTransactions[index];
                          return _TransactionCard(transaction: transaction);
                        }, childCount: state.filteredTransactions.length),
                      ),
                    ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteName.addRecord,
            arguments: {
              'flowType': TransactionSource.budget,
              'budget': widget.budget,
            },
          ).then((value) {
            if (value == true) {
              context.read<BudgetDetailsBloc>().add(
                RefreshBudgetDetailsEvent(widget.budget.id),
              );
            }
          });
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Transaction',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[300]!,
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Get first item for display
    final firstItem = transaction.items.isNotEmpty
        ? transaction.items.first
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to transaction detail
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getIconColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_getIcon(), color: _getIconColor(), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstItem.toString() ?? 'Transaction',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${transaction.paymentMethod.name} • ${DateFormat('MMM dd').format(transaction.date)}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${transaction.type == TransactionType.expense ? '-' : '+'} Rs ${transaction.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: transaction.type == TransactionType.expense
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    if (transaction.items.length > 1)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '+${transaction.items.length - 1} more',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (transaction.paymentMethod) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.bank:
        return Icons.account_balance;
      default:
        return Icons.receipt;
    }
  }

  Color _getIconColor() {
    return transaction.type == TransactionType.expense
        ? Colors.red
        : Colors.green;
  }
}
