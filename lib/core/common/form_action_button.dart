import 'package:flutter/material.dart';

class FormActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final Color submitColor;
  final ColorScheme colorScheme;
  final String submitText;

  const FormActionButtons({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.submitColor,
    required this.colorScheme,
    this.submitText = 'Submit',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: submitColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              submitText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
