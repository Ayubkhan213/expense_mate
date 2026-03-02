import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtDetailsSection extends StatefulWidget {
  final bool isDebt;
  final dynamic debtType; // DebtType enum
  final String personName;
  final DateTime? expectedReturnDate;
  final Function(String) onPersonNameChanged;
  final VoidCallback onDatePressed;

  const DebtDetailsSection({
    super.key,
    required this.isDebt,
    required this.debtType,
    required this.personName,
    required this.expectedReturnDate,
    required this.onPersonNameChanged,
    required this.onDatePressed,
  });

  @override
  State<DebtDetailsSection> createState() => _DebtDetailsSectionState();
}

class _DebtDetailsSectionState extends State<DebtDetailsSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.personName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar' || locale.languageCode == 'ur';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: widget.isDebt
          ? Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surface : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.debtType.toString().contains('borrowed')
                        ? '💰 ${t.borrowedFrom} '
                        : '💸 ${t.lentTo}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Person Name Field
                  TextField(
                    controller: _controller,
                    onChanged: widget.onPersonNameChanged,
                    // textDirection: isRTL
                    //     ? TextDirection.rtl
                    //     : TextDirection.ltr,
                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Person name...',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: isDark ? colorScheme.background : Colors.white,
                      prefixIcon: Icon(
                        Icons.person,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Expected Return Date
                  GestureDetector(
                    onTap: widget.onDatePressed,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.background : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.expectedReturnDate != null
                                  ? 'Return by: ${DateFormat('dd MMM yyyy').format(widget.expectedReturnDate!)}'
                                  : 'Set expected return date',
                              style: TextStyle(
                                color: widget.expectedReturnDate != null
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
