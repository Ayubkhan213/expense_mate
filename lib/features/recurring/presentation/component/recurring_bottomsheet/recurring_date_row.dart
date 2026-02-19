import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_event.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_state.dart';
import 'package:intl/intl.dart';

/// Date range selector (Start and End dates)
class RecurringDateRow extends StatelessWidget {
  final AddEditRecurringState state;

  const RecurringDateRow({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateButton(
            label: 'Start',
            date: state.startDate,
            icon: Icons.calendar_today,
            onTap: () => _selectStartDate(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _DateButton(
            label: state.endDate == null ? 'No End' : 'End',
            date: state.endDate,
            icon: state.endDate == null ? Icons.all_inclusive : Icons.event,
            onTap: () => _selectEndDate(context),
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: state.startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (date != null) {
      context.read<AddEditRecurringBloc>().add(StartDateChanged(date));
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          state.endDate ?? state.startDate.add(const Duration(days: 365)),
      firstDate: state.startDate,
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    context.read<AddEditRecurringBloc>().add(EndDateChanged(date));
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final IconData icon;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.date,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: theme.primaryColor),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    date != null
                        ? DateFormat('MMM d').format(date ?? DateTime.now())
                        : '--',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
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
