import 'package:spendio/core/data/models/budget_model.dart';
import 'package:spendio/core/utils/translation_helper.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget/budget_bloc.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_from/budget_form_bloc.dart';
import 'package:spendio/features/budgets/presentation/bloc/budget_from/budget_form_state.dart';
import 'package:spendio/features/budgets/presentation/components/bottom_sheet_component/budget_setting_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/features/budgets/presentation/components/bottom_sheet_component/budget_compact_display.dart';
import 'package:spendio/features/budgets/presentation/components/bottom_sheet_component/budget_calculator.dart';

class AddBudgetBottomSheet extends StatelessWidget {
  const AddBudgetBottomSheet({super.key});

  // ✅ Updated show() — accepts optional existingBudget for edit mode
  static Future<void> show(
    BuildContext context, {
    BudgetModel? existingBudget,
  }) {
    final presets = context.budgetCategoryPresets;
    final budgetBloc = context
        .read<BudgetBloc>(); // ✅ read before showModalBottomSheet

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: budgetBloc, // ✅ typed BudgetBloc passed in
        child: BlocProvider(
          create: (_) => BudgetFormBloc(
            categoryPresets: presets,
            existingBudget: existingBudget,
          ),
          child: const AddBudgetBottomSheet(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<BudgetFormBloc, BudgetFormState>(
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.background : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DragHandle(theme: theme),
              // ✅ Show "Edit Budget" label in edit mode
              if (state.isEditMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Edit Budget',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: state.selectedColor,
                    ),
                  ),
                ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BudgetCompactDisplay(state: state),
                      const SizedBox(height: 12),
                      BudgetSettingsRow(state: state),
                      const SizedBox(height: 8),
                      BudgetCalculator(state: state),
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
}

class _DragHandle extends StatelessWidget {
  final ThemeData theme;
  const _DragHandle({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 10, bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
