import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtDetailsSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: isDebt
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
                    debtType.toString().contains('borrowed')
                        ? '💰 Borrowed From'
                        : '💸 Lent To',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Person Name Field
                  TextField(
                    controller: TextEditingController(text: personName),
                    onChanged: onPersonNameChanged,
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
                    onTap: onDatePressed,
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
                              expectedReturnDate != null
                                  ? 'Return by: ${DateFormat('dd MMM yyyy').format(expectedReturnDate!)}'
                                  : 'Set expected return date',
                              style: TextStyle(
                                color: expectedReturnDate != null
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
