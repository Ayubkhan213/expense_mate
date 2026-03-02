import 'package:expense_mate/core/data/models/budget_model.dart';
import 'package:expense_mate/core/utils/translation_helper.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_state.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Compact row: budget type selector + category picker
class BudgetSettingsRow extends StatelessWidget {
  final BudgetFormState state;

  const BudgetSettingsRow({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Budget type — segmented chips
        Expanded(flex: 3, child: _BudgetTypeChips(state: state)),
        const SizedBox(width: 8),
        // Category dropdown
        Expanded(flex: 2, child: _CategoryDropdown(state: state)),
      ],
    );
  }
}

class _BudgetTypeChips extends StatelessWidget {
  final BudgetFormState state;
  const _BudgetTypeChips({required this.state});

  //  only store key + icon, label comes from translations
  static const _types = [
    ('monthly', Icons.calendar_month),
    ('project', Icons.flag),
    ('custom', Icons.tune),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<BudgetFormBloc>();
    final t = AppLocalizations.of(context)!; // ✅

    //  translated label map
    final labelMap = {
      'monthly': t.monthly,
      'project': t.project,
      'custom': t.custom,
    };

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: _types.map((type) {
          final (typeStr, icon) = type;
          final isSelected = state.selectedType
              .toString()
              .toLowerCase()
              .contains(typeStr);
          final color = theme.primaryColor;

          return Expanded(
            child: GestureDetector(
              onTap: () => bloc.add(BudgetFormTypeChanged(_getType(typeStr))),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      labelMap[typeStr] ?? typeStr, //  translated
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  dynamic _getType(String type) {
    switch (type) {
      case 'monthly':
        return BudgetType.monthly;
      case 'project':
        return BudgetType.project;
      default:
        return BudgetType.custom;
    }
  }
}

class _CategoryDropdown extends StatelessWidget {
  final BudgetFormState state;
  const _CategoryDropdown({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<BudgetFormBloc>();
    final t = AppLocalizations.of(context)!;

    // Always get fresh translated categories from context
    final allPresets = context.budgetCategoryPresets;
    final categories = allPresets[state.selectedType] ?? <String>[];

    // Translate the currently selected category key back to current language
    final translatedSelected = state.selectedCategory != null
        ? context.tr(state.selectedCategory!)
        : null;

    final selectedValue =
        (translatedSelected != null && categories.contains(translatedSelected))
        ? translatedSelected
        : null;

    return Container(
      // ... same decoration ...
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue, // ✅
          hint: Row(
            children: [
              Icon(
                Icons.category_outlined,
                size: 14,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  t.category,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          isExpanded: true,
          isDense: true,
          icon: const Icon(Icons.expand_more, size: 16),
          items: categories.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat, style: theme.textTheme.bodySmall),
            );
          }).toList(),
          onChanged: (cat) {
            if (cat != null) {
              bloc.add(BudgetFormCategorySelected(cat));
              bloc.add(BudgetFormNameChanged(cat));
            }
          },
        ),
      ),
    );
  }
}
