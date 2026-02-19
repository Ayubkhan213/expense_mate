import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/data/models/enums.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';
import 'package:expense_mate/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_event.dart';

/// Frequency selector dropdown
class RecurringFrequencyDropdown extends StatelessWidget {
  final RecurrenceFrequency frequency;

  const RecurringFrequencyDropdown({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<AddEditRecurringBloc>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RecurrenceFrequency>(
          value: frequency,
          isExpanded: true,
          isDense: true,
          icon: const Icon(Icons.expand_more, size: 18),
          items: _buildItems(theme),
          onChanged: (val) {
            if (val != null) bloc.add(FrequencyChanged(val));
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<RecurrenceFrequency>> _buildItems(ThemeData theme) {
    return [
      RecurrenceFrequency.daily,
      RecurrenceFrequency.weekly,
      RecurrenceFrequency.monthly,
      RecurrenceFrequency.quarterly,
      RecurrenceFrequency.yearly,
    ].map((freq) {
      return DropdownMenuItem(
        value: freq,
        child: Row(
          children: [
            Icon(Icons.repeat, size: 14, color: theme.primaryColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                _getFrequencyLabel(freq),
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getFrequencyLabel(RecurrenceFrequency freq) {
    switch (freq) {
      case RecurrenceFrequency.daily:
        return 'Daily';
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.biweekly:
        return 'Bi-weekly';
      case RecurrenceFrequency.monthly:
        return 'Monthly';
      case RecurrenceFrequency.quarterly:
        return 'Quarterly';
      case RecurrenceFrequency.yearly:
        return 'Yearly';
    }
  }
}
