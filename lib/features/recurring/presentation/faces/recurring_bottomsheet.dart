// lib/features/recurring/presentation/faces/recurring_bottomsheet.dart

import 'package:expense_mate/core/common/custom_snackbar.dart';
import 'package:expense_mate/core/data/models/category_hive_model.dart';
import 'package:expense_mate/core/data/models/recurring_transaction_model.dart';
import 'package:expense_mate/features/recurring/data/data_source/recurring_local_data_source.dart';
import 'package:expense_mate/features/recurring/data/repositort_imp/recurring_repo_impl.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_event.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_state.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/recurring/recurring_list_event.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_calculator.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_compact_display.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_date_row.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_frequency_dropdown.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_note_field.dart';
import 'package:expense_mate/features/recurring/presentation/component/recurring_bottomsheet/recurring_payment_dropdown.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecurringTransactionBottomSheet {
  /// [isCreating] = true  → came from RecurringCategorySelector (2 pops needed)
  /// [isCreating] = false → came from RecurringFace edit button  (1 pop needed)
  static void show(
    BuildContext context,
    CategoryHiveModel category, {
    RecurringTransactionModel? existingRecurring,
  }) {
    final isCreating = existingRecurring == null;

    // Capture the RecurringListBloc from the parent context BEFORE the sheet
    // opens — the sheet's own context won't have access to it otherwise.
    final recurringListBloc = context.read<RecurringListBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider<AddEditRecurringBloc>(
        create: (_) => AddEditRecurringBloc(
          repository: RecurringRepositoryImpl(
            localDataSource: RecurringLocalDataSourceImpl(),
          ),
        )..add(InitializeForm(category: category, existing: existingRecurring)),
        child: _RecurringBottomSheetContent(
          category: category,
          isCreating: isCreating,
          recurringListBloc: recurringListBloc,
        ),
      ),
    );
  }
}

class _RecurringBottomSheetContent extends StatelessWidget {
  final CategoryHiveModel category;
  final bool isCreating;
  final RecurringListBloc recurringListBloc;

  const _RecurringBottomSheetContent({
    required this.category,
    required this.isCreating,
    required this.recurringListBloc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

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
                      _buildSettingsRow(state, t),
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

  Widget _buildSettingsRow(AddEditRecurringState state, AppLocalizations t) {
    return Row(
      children: [
        Expanded(child: RecurringFrequencyDropdown(frequency: state.frequency)),
        const SizedBox(width: 8),
        Expanded(child: RecurringPaymentDropdown(payment: state.paymentMethod)),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, AddEditRecurringState state) {
    final t = AppLocalizations.of(context)!;
    if (state.status == RecurringFormStatus.success) {
      if (isCreating) {
        // Pop the bottom sheet
        Navigator.pop(context);
        // Pop the category selector screen beneath it
        Navigator.pop(context);
      } else {
        // Edit — only the bottom sheet is on the stack
        Navigator.pop(context);
      }

      // Reload the RecurringFace list (use captured bloc — context is gone)
      recurringListBloc.add(LoadRecurringList());

      AnimatedSnackbar.showSuccess(
        context,
        isCreating ? t.recurringCreated : t.recurringUpdated,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       isCreating
      //           ? 'Recurring transaction created!'
      //           : 'Recurring transaction updated!',
      //     ),
      //     backgroundColor: Colors.green,
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //   ),
      // );
    } else if (state.status == RecurringFormStatus.error) {
      AnimatedSnackbar.showError(
        context,
        state.errorMessage ?? t.anErrorOccurred,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(state.errorMessage ?? 'An error occurred'),
      //     backgroundColor: Colors.red,
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //   ),
      // );
    }
  }
}
