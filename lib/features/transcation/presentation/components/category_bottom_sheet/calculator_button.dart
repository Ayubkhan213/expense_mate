import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool isFlexible;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.isFlexible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final buttonColor =
        color ?? (isDark ? colorScheme.surface : Colors.grey[200]);
    final textColor = color != null ? Colors.white : colorScheme.onSurface;

    final button = GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: color == null
              ? Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );

    return isFlexible ? Expanded(child: button) : button;
  }
}
