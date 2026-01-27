import 'package:flutter/material.dart';

class NoteInputField extends StatelessWidget {
  final String note;
  final Function(String) onNoteChanged;
  final VoidCallback onImagePick;

  const NoteInputField({
    super.key,
    required this.note,
    required this.onNoteChanged,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: TextEditingController(text: note),
      onChanged: onNoteChanged,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Note: Enter a note...',
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: isDark ? colorScheme.surface : Colors.grey[100],
        suffixIcon: IconButton(
          icon: Icon(Icons.image, color: colorScheme.primary),
          onPressed: onImagePick,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
