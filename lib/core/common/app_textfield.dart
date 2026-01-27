import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final ColorScheme colorScheme;
  final bool isDark;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.colorScheme,
    required this.isDark,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: colorScheme.primary),
        filled: true,
        fillColor: isDark
            ? colorScheme.surface
            : colorScheme.primary.withOpacity(0.05),
        border: _border(colorScheme),
        enabledBorder: _border(colorScheme),
        focusedBorder: _focusedBorder(colorScheme),
      ),
    );
  }

  OutlineInputBorder _border(ColorScheme scheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.onSurface.withOpacity(0.2)),
    );
  }

  OutlineInputBorder _focusedBorder(ColorScheme scheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.primary, width: 2),
    );
  }
}
