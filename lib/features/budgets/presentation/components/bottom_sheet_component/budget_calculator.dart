import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/core/theme/typography/text_style_extension.dart';
import 'package:expense_mate/core/utils/translation_helper.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget/budget_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_bloc.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_event.dart';
import 'package:expense_mate/features/budgets/presentation/bloc/budget_from/budget_form_state.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetCalculator extends StatefulWidget {
  final BudgetFormState state;

  const BudgetCalculator({super.key, required this.state});

  @override
  State<BudgetCalculator> createState() => _BudgetCalculatorState();
}

class _BudgetCalculatorState extends State<BudgetCalculator> {
  String? _activePanel;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.state.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<BudgetFormBloc>();
    final state = widget.state;

    return Column(
      children: [
        _QuickToolbar(
          state: state,
          activePanel: _activePanel,
          onToggle: (panel) => setState(
            () => _activePanel = _activePanel == panel ? null : panel,
          ),
        ),

        const SizedBox(height: 8),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: _activePanel == null
              ? const SizedBox.shrink()
              : _PanelContent(
                  panel: _activePanel!,
                  state: state,
                  nameController: _nameController,
                  bloc: bloc,
                ),
        ),

        _buildCalcGrid(theme, bloc, state),
      ],
    );
  }

  Widget _buildCalcGrid(
    ThemeData theme,
    BudgetFormBloc bloc,
    BudgetFormState state,
  ) {
    return Column(
      children: [
        _buildRow(['7', '8', '9', 'C'], theme, bloc, state),
        _buildRow(['4', '5', '6', '+'], theme, bloc, state),
        _buildRow(['1', '2', '3', '-'], theme, bloc, state),
        _buildRow(['.', '0', '⌫', '✓'], theme, bloc, state),
      ],
    );
  }

  Widget _buildRow(
    List<String> buttons,
    ThemeData theme,
    BudgetFormBloc bloc,
    BudgetFormState state,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: buttons.map((btn) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _CalcButton(
                label: btn,
                theme: theme,
                state: state,
                onTap: () => _handleButton(btn, bloc, state),
                isSubmit: btn == '✓',
                isDelete: btn == '⌫',
                isClear: btn == 'C',
                isOperator: btn == '+' || btn == '-',
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleButton(String btn, BudgetFormBloc bloc, BudgetFormState state) {
    switch (btn) {
      case '⌫':
        bloc.add(
          BudgetFormAmountChanged(
            state.amount.isNotEmpty
                ? state.amount.substring(0, state.amount.length - 1)
                : '',
          ),
        );
      case 'C':
        bloc.add(BudgetFormAmountChanged(''));
      case '+':
      case '-':
        bloc.add(BudgetFormOperationChanged(btn));
      case '✓':
        _submitBudget(state);
      default:
        final current = state.amount;
        if (btn == '.' && current.contains('.')) return;
        bloc.add(BudgetFormAmountChanged(current + btn));
    }
  }

  void _submitBudget(BudgetFormState state) {
    final t = AppLocalizations.of(context)!;
    final amount = double.tryParse(state.amount);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.pleaseEnterValidAmount,
            style: AppTextStyles.bodySmall,
          ),
        ),
      );
      return;
    }
    if (state.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.pleaseEnterBudgetName,
            style: AppTextStyles.bodySmall,
          ),
        ),
      );
      return;
    }
    print('-------------- Budget -------------');
    context.read<BudgetBloc>().add(
      CreateBudgetEvent(
        name: state.name,
        type: state.selectedType,
        totalAmount: amount,
        startDate: state.startDate,
        endDate: state.endDate,
        category: state.selectedCategory,
        icon: state.selectedIcon.codePoint.toString(),
        colorCode: state.selectedColor.value,
      ),
    );
    Navigator.pop(context);
  }
}

// ── Quick toolbar ──
class _QuickToolbar extends StatelessWidget {
  final BudgetFormState state;
  final String? activePanel;
  final void Function(String) onToggle;

  const _QuickToolbar({
    required this.state,
    required this.activePanel,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final color = state.selectedColor;
    return Row(
      children: [
        _ToolbarChip(
          icon: Icons.label_outline,
          label: state.name.isNotEmpty ? state.name : t.name,
          isActive: activePanel == 'name',
          activeColor: color,
          onTap: () => onToggle('name'),
          maxWidth: 110,
        ),
        const SizedBox(width: 6),
        _ToolbarChip(
          icon: Icons.date_range,
          label: state.durationInDays > 0 ? '${state.durationInDays}d' : t.date,
          isActive: activePanel == 'dates',
          activeColor: color,
          onTap: () => onToggle('dates'),
        ),
        const SizedBox(width: 6),
        _ToolbarChip(
          icon: Icons.palette_outlined,
          label: t.style,
          isActive: activePanel == 'appearance',
          activeColor: color,
          onTap: () => onToggle('appearance'),
        ),
      ],
    );
  }
}

class _ToolbarChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;
  final double? maxWidth;

  const _ToolbarChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        constraints: maxWidth != null
            ? BoxConstraints(maxWidth: maxWidth!)
            : null,
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.15)
              : cs.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? activeColor
                : cs.onSurface.withValues(alpha: 0.12),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isActive
                  ? activeColor
                  : cs.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.labelSmall
                    .withColor(
                      isActive
                          ? activeColor
                          : cs.onSurface.withValues(alpha: 0.6),
                    )
                    .copyWith(
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Panel container ──
class _PanelContent extends StatelessWidget {
  final String panel;
  final BudgetFormState state;
  final TextEditingController nameController;
  final BudgetFormBloc bloc;

  const _PanelContent({
    required this.panel,
    required this.state,
    required this.nameController,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: switch (panel) {
        'name' => _NamePanel(
          state: state,
          nameController: nameController,
          bloc: bloc,
        ),
        'dates' => _DatesPanel(state: state, bloc: bloc),
        'appearance' => _AppearancePanel(state: state, bloc: bloc),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

// ── Name panel ──
class _NamePanel extends StatelessWidget {
  final BudgetFormState state;
  final TextEditingController nameController;
  final BudgetFormBloc bloc;

  const _NamePanel({
    required this.state,
    required this.nameController,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final color = state.selectedColor;
    final cs = Theme.of(context).colorScheme;

    //  always get fresh translated categories
    final categories =
        context.budgetCategoryPresets[state.selectedType] ?? <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.budgetName, style: AppTextStyles.labelMedium.semiBold),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          autofocus: true,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: t.budgetNameHint,
            hintStyle: AppTextStyles.inputHint.withColor(
              cs.onSurface.withValues(alpha: 0.4),
            ),
            prefixIcon: Icon(Icons.label_outline, size: 18, color: color),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: cs.onSurface.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: color),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            isDense: true,
          ),
          onChanged: (v) => bloc.add(BudgetFormNameChanged(v)),
        ),
        if (categories.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: categories.map((cat) {
              // compare using translated value
              final isSel = state.selectedCategory == cat;
              return GestureDetector(
                onTap: () {
                  bloc.add(
                    BudgetFormCategorySelected(cat),
                  ); //  stores translated
                  bloc.add(BudgetFormNameChanged(cat));
                  nameController.text = cat;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSel
                        ? color.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSel
                          ? color
                          : cs.onSurface.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    cat, //  already translated
                    style: AppTextStyles.categoryLabel
                        .withColor(isSel ? color : cs.onSurface)
                        .copyWith(
                          fontWeight: isSel
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// ── Dates panel ──
class _DatesPanel extends StatelessWidget {
  final BudgetFormState state;
  final BudgetFormBloc bloc;

  const _DatesPanel({required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final color = state.selectedColor;
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.dateRange, style: AppTextStyles.labelMedium.semiBold),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _DateTile(
                label: t.start,
                date: state.startDate,
                icon: Icons.calendar_today,
                color: color,
                onTap: () => _pickDate(context, true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
            Expanded(
              child: _DateTile(
                label: t.end,
                date: state.endDate,
                icon: Icons.event,
                color: color,
                onTap: () => _pickDate(context, false),
              ),
            ),
          ],
        ),
        if (state.durationInDays > 0) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  '${state.durationInDays} ${t.days} ',
                  style: AppTextStyles.captionSmall.withColor(color).semiBold,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? state.startDate : state.endDate,
      firstDate: isStart ? DateTime.now() : state.startDate,
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      bloc.add(
        isStart
            ? BudgetFormStartDateChanged(picked)
            : BudgetFormEndDateChanged(picked),
      );
    }
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.date,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: cs.onSurface.withValues(alpha: 0.15)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.captionSmall.withColor(
                      cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    date != null
                        ? '${date!.day}/${date!.month}/${date!.year}'
                        : '--',
                    style: AppTextStyles.timestamp.semiBold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Appearance panel ──
class _AppearancePanel extends StatelessWidget {
  final BudgetFormState state;
  final BudgetFormBloc bloc;

  const _AppearancePanel({required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final selectedColor = state.selectedColor;
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.color, style: AppTextStyles.labelMedium.semiBold),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: state.colorOptions.map((color) {
            final isSel = color == selectedColor;
            return GestureDetector(
              onTap: () => bloc.add(BudgetFormColorChanged(color)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSel ? cs.onSurface : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: isSel
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        Text(t.icon, style: AppTextStyles.labelMedium.semiBold),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.iconOptions.map((icon) {
            final isSel = icon == state.selectedIcon;
            return GestureDetector(
              onTap: () => bloc.add(BudgetFormIconChanged(icon)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSel
                      ? selectedColor.withValues(alpha: 0.15)
                      : cs.onSurface.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSel
                        ? selectedColor
                        : cs.onSurface.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSel
                      ? selectedColor
                      : cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Calculator button ──
class _CalcButton extends StatelessWidget {
  final String label;
  final ThemeData theme;
  final BudgetFormState state;
  final VoidCallback onTap;
  final bool isSubmit;
  final bool isDelete;
  final bool isClear;
  final bool isOperator;

  const _CalcButton({
    required this.label,
    required this.theme,
    required this.state,
    required this.onTap,
    this.isSubmit = false,
    this.isDelete = false,
    this.isClear = false,
    this.isOperator = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color? bgColor = _buttonColor();
    final bool enabled = isSubmit
        ? ((double.tryParse(state.amount) ?? 0) > 0 && state.name.isNotEmpty)
        : true;

    return Material(
      color: bgColor ?? theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: isSubmit
              ? Icon(
                  Icons.check_rounded,
                  color: enabled ? Colors.white : Colors.white54,
                  size: 22,
                )
              : isDelete
              ? const Icon(
                  Icons.backspace_outlined,
                  color: Colors.white,
                  size: 18,
                )
              : Text(
                  label,
                  style: AppTextStyles.h6.copyWith(
                    fontWeight: FontWeight.w600,
                    color: bgColor != null
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                  ),
                ),
        ),
      ),
    );
  }

  Color? _buttonColor() {
    if (isSubmit) {
      final hasAmount = (double.tryParse(state.amount) ?? 0) > 0;
      return (hasAmount && state.name.isNotEmpty)
          ? Colors.green
          : Colors.grey.shade400;
    }
    if (isDelete) return Colors.redAccent;
    if (isClear) return Colors.orange;
    if (isOperator) return Colors.blue;
    return null;
  }
}
