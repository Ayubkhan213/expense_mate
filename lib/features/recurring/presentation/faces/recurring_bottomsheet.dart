import 'package:expense_mate/core/data/data_sources/local/recurring_local_data_source.dart';
import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/features/recurring/data/data_source/recurring_local_data_source.dart';
import 'package:expense_mate/features/recurring/data/repositort_imp/recurring_repo_impl.dart';
import 'package:expense_mate/features/recurring/domain/repository.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_event.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_state.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_calculator.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_compact_display.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_date_row.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_frequency_dropdown.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_note_field.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_payment_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC-based Recurring Transaction Bottom Sheet
class RecurringTransactionBottomSheet {
  static void show(
    BuildContext context,
    CategoryHiveModel category, {
    RecurringTransactionModel? existingRecurring,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider<AddEditRecurringBloc>(
        create: (_) => AddEditRecurringBloc(
          repository: RecurringRepositoryImpl(
            localDataSource: RecurringLocalDataSourceImpl(),
          ),
        )..add(InitializeForm(category: category, existing: existingRecurring)),
        child: _RecurringBottomSheetContent(
          category: category,
          isEdit: existingRecurring != null,
        ),
      ),
    );
  }
}

class _RecurringBottomSheetContent extends StatelessWidget {
  final CategoryHiveModel category;
  final bool isEdit;

  const _RecurringBottomSheetContent({
    required this.category,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<AddEditRecurringBloc, AddEditRecurringState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.background : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(theme),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RecurringCompactDisplay(category: category, state: state),
                      const SizedBox(height: 12),
                      _buildSettingsRow(state),
                      const SizedBox(height: 8),
                      RecurringDateRow(state: state),
                      const SizedBox(height: 8),
                      const RecurringNoteField(),
                      const SizedBox(height: 16),
                      RecurringCalculator(state: state),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSettingsRow(AddEditRecurringState state) {
    return Row(
      children: [
        Expanded(child: RecurringFrequencyDropdown(frequency: state.frequency)),
        const SizedBox(width: 8),
        Expanded(child: RecurringPaymentDropdown(payment: state.paymentMethod)),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, AddEditRecurringState state) {
    if (state.status == RecurringFormStatus.success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Recurring transaction updated!'
                : 'Recurring transaction created!',
          ),
        ),
      );
    } else if (state.status == RecurringFormStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
