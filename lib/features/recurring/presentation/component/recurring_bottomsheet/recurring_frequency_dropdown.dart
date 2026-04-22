import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/data/models/enums.dart';
import 'package:spendio/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_bloc.dart';
import 'package:spendio/features/recurring/presentation/bloc/add_recurring/add_edit_recurring_event.dart';
import 'package:spendio/l10n/app_localizations.dart';

/// Frequency selector dropdown
class RecurringFrequencyDropdown extends StatelessWidget {
  final RecurrenceFrequency frequency;

  const RecurringFrequencyDropdown({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<AddEditRecurringBloc>();
    final tr = AppLocalizations.of(context)!;
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
          items: _buildItems(theme, tr),
          onChanged: (val) {
            if (val != null) bloc.add(FrequencyChanged(val));
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<RecurrenceFrequency>> _buildItems(
    ThemeData theme,
    AppLocalizations tr,
  ) {
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
                _getFrequencyLabel(freq, tr),
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getFrequencyLabel(RecurrenceFrequency freq, AppLocalizations t) {
    switch (freq) {
      case RecurrenceFrequency.daily:
        return t.daily;
      case RecurrenceFrequency.weekly:
        return t.weekly;
      case RecurrenceFrequency.biweekly:
        return t.biweekly;
      case RecurrenceFrequency.monthly:
        return t.monthly;
      case RecurrenceFrequency.quarterly:
        return t.quarterly;
      case RecurrenceFrequency.yearly:
        return t.yearly;
    }
  }
}
