import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_event.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_state.dart';

class RecurringCalculator extends StatelessWidget {
  final AddEditRecurringState state;

  const RecurringCalculator({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<AddEditRecurringBloc>();

    return Column(
      children: [
        _buildCalcRow(['7', '8', '9', 'Date'], theme, bloc, context),
        _buildCalcRow(['4', '5', '6', '+'], theme, bloc, context),
        _buildCalcRow(['1', '2', '3', '-'], theme, bloc, context),

        _buildCalcRow(
          ['.', '0', '⌫', _getActionButton()],
          theme,
          bloc,
          context,
        ),
      ],
    );
  }

  Widget _buildCalcRow(
    List<String> buttons,
    ThemeData theme,
    AddEditRecurringBloc bloc,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: buttons.map((btn) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _buildCalcButton(btn, theme, bloc, context),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalcButton(
    String text,
    ThemeData theme,
    AddEditRecurringBloc bloc,
    BuildContext context,
  ) {
    Color? color;
    VoidCallback? onTap;

    if (text == 'Date') {
      color = Colors.blue;
      onTap = () => _selectDate(bloc, context);
    } else if (text == '+' || text == '-') {
      color = Colors.orange;
      onTap = () => bloc.add(CalculatorOperationPressed(text));
    } else if (text == '⌫') {
      color = Colors.red;
      onTap = () => bloc.add(CalculatorClearPressed());
    } else if (text == '=') {
      color = Colors.orange;
      onTap = () => bloc.add(CalculatorEqualsPressed());
    } else if (text == '✓') {
      color = state.isValid ? Colors.green : Colors.grey;
      onTap = state.isValid ? () => bloc.add(SubmitRecurring()) : null;
    } else {
      onTap = () => bloc.add(CalculatorNumberPressed(text));
    }

    return Material(
      color: color ?? theme.cardColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color != null ? Colors.white : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _getActionButton() {
    if (state.operation.isNotEmpty) return '=';
    if (state.amount.isNotEmpty && state.currentNumber.isNotEmpty) {
      return '✓';
    }
    return '✓';
  }

  Future<void> _selectDate(
    AddEditRecurringBloc bloc,
    BuildContext context,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: state.startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (date != null) bloc.add(StartDateChanged(date));
  }
}
