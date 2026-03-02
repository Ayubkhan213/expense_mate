import 'package:expense_mate/core/app_export.dart';

class NoteInputField extends StatefulWidget {
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
  State<NoteInputField> createState() => _NoteInputFieldState();
}

class _NoteInputFieldState extends State<NoteInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note); // ✅ created once
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar' || locale.languageCode == 'ur';
    return TextField(
      controller: _controller, // ✅ stable controller
      onChanged: widget.onNoteChanged,
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      style: TextStyle(color: colorScheme.onSurface),
      textAlign: isRTL ? TextAlign.right : TextAlign.left,
      decoration: InputDecoration(
        hintText: 'Note: Enter a note...',
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: isDark ? colorScheme.surface : Colors.grey[100],
        suffixIcon: IconButton(
          icon: Icon(Icons.image, color: colorScheme.primary),
          onPressed: widget.onImagePick,
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
