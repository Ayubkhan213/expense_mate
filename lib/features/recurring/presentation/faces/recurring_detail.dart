import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/features/recurring/data/data_source/recurring_local_data_source.dart';
import 'package:expense_mate/features/recurring/data/repositort_imp/recurring_repo_impl.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring_detail/recurring_detail_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring_detail/recurring_detail_event.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring_detail/recurring_detail_state.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_detail_header.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_detail_info.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_detail_monthly_estimate.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_detail_stats.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_detail/recurring_generated_transactions_list.dart';
import 'package:expense_mate/features/recurring/presentation/faces/recurring_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecurringDetailPage extends StatelessWidget {
  final String recurringId;

  const RecurringDetailPage({super.key, required this.recurringId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecurringDetailBloc(
        repository: RecurringRepositoryImpl(
          localDataSource: RecurringLocalDataSourceImpl(),
        ),
      )..add(LoadRecurringDetail(recurringId)),
      child: _RecurringDetailView(),
    );
  }
}

class _RecurringDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Details'),
        actions: [
          BlocBuilder<RecurringDetailBloc, RecurringDetailState>(
            builder: (context, state) {
              if (state is RecurringDetailLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditSheet(context, state.recurring),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<RecurringDetailBloc, RecurringDetailState>(
        builder: (context, state) {
          if (state is RecurringDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecurringDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (state is RecurringDetailLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RecurringDetailBloc>().add(
                  RefreshRecurringDetail(state.recurring.id),
                );
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  RecurringDetailHeader(transaction: state.recurring),
                  const SizedBox(height: 16),
                  RecurringDetailInfo(transaction: state.recurring),
                  const SizedBox(height: 16),
                  RecurringDetailStats(
                    transactionCount: state.generatedTransactions.length,
                    totalSpent: state.totalSpent,
                    isIncome: state.recurring.type == TransactionType.income,
                  ),
                  const SizedBox(height: 16),
                  RecurringDetailMonthlyEstimate(
                    monthlyAmount: state.monthlyEstimate,
                    isIncome: state.recurring.type == TransactionType.income,
                  ),
                  const SizedBox(height: 16),
                  RecurringGeneratedTransactionsList(
                    transactions: state.generatedTransactions,
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showEditSheet(
    BuildContext context,
    RecurringTransactionModel recurring,
  ) {
    final category = CategoryHiveModel(
      key: recurring.categoryKey,
      isIncome: recurring.type == TransactionType.income,
      colorValue: 0xFF6200EA,
      iconCode: Icons.category.codePoint,
    );

    RecurringTransactionBottomSheet.show(
      context,
      category,
      existingRecurring: recurring,
    );
  }
}
