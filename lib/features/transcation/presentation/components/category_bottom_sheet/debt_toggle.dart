import 'package:flutter/material.dart';
import 'package:spendio/core/data/models/enums.dart';

class DebtToggleButton extends StatelessWidget {
  final DebtType type;
  final DebtType? selectedType;
  final String label;
  final VoidCallback onTap;

  const DebtToggleButton({
    super.key,
    required this.type,
    required this.label,
    required this.selectedType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
