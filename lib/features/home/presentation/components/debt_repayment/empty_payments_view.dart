import 'package:flutter/material.dart';

class EmptyPaymentsView extends StatelessWidget {
  const EmptyPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.payments_outlined,
                size: 64,
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'No Payments Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              'Tap the + button below to add\nyour first payment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Hint Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surface
                    : colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Track your debt repayments easily',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
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
