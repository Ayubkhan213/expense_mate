import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double width;
  final IconData? icon;
  final bool outlined;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height = 56,
    this.width = double.infinity,
    this.icon,
    this.outlined = false,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = backgroundColor ?? const Color(0xFF6C5CE7);
    final Color buttonTextColor = textColor ?? Colors.white;

    final VoidCallback? action = isLoading
        ? null
        : onPressed; // prevent double tap

    return SizedBox(
      width: width,
      height: height,
      child: outlined
          ? OutlinedButton(
              onPressed: action,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: action == null ? Colors.grey[300]! : buttonColor,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: _buildChild(buttonColor),
            )
          : ElevatedButton(
              onPressed: action,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                disabledBackgroundColor: Colors.grey[300],
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: _buildChild(buttonTextColor),
            ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
    );
  }
}
