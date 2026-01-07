import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  final String text;
  final double fontSize;
  const ButtonComponent({
    super.key,
    required this.onTap,
    this.color,
    required this.text,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color ?? Colors.grey[850],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: color != null ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
