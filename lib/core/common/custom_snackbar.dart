import 'package:flutter/material.dart';

// ============================================================================
// FIXED COLORS — independent of app theme
// success = green, error = red, warning = orange, info = theme primary
// ============================================================================

enum SnackbarType { success, error, warning, info }

// Fixed palette — never changes regardless of theme
class _FixedColors {
  // Success — green
  static const Color successLight = Color(0xFF2E7D32);
  static const Color successDark = Color(0xFF4CAF50);
  static const Color successBgLight = Color(0xFFE8F5E9);
  static const Color successBgDark = Color(0xFF1B3A1F);

  // Error — red
  static const Color errorLight = Color(0xFFC62828);
  static const Color errorDark = Color(0xFFEF5350);
  static const Color errorBgLight = Color(0xFFFFEBEE);
  static const Color errorBgDark = Color(0xFF3A1A1A);

  // Warning — orange/amber
  static const Color warningLight = Color(0xFFE65100);
  static const Color warningDark = Color(0xFFFFA726);
  static const Color warningBgLight = Color(0xFFFFF3E0);
  static const Color warningBgDark = Color(0xFF3A2510);
}

class CustomSnackbar {
  CustomSnackbar._();

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) => _show(
    context,
    message: message,
    type: SnackbarType.success,
    duration: duration,
    action: action,
  );

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) => _show(
    context,
    message: message,
    type: SnackbarType.error,
    duration: duration,
    action: action,
  );

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) => _show(
    context,
    message: message,
    type: SnackbarType.warning,
    duration: duration,
    action: action,
  );

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) => _show(
    context,
    message: message,
    type: SnackbarType.info,
    duration: duration,
    action: action,
  );

  static void _show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final config = _config(type, Theme.of(context));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(config.icon, color: config.iconColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: config.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: config.borderColor, width: 1.5),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: duration,
        action: action,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static _SnackbarConfig _config(SnackbarType type, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case SnackbarType.success:
        final color = isDark
            ? _FixedColors.successDark
            : _FixedColors.successLight;
        return _SnackbarConfig(
          icon: Icons.check_circle_rounded,
          iconColor: color,
          backgroundColor: isDark
              ? _FixedColors.successBgDark
              : _FixedColors.successBgLight,
          borderColor: color,
          textColor: isDark ? Colors.white : const Color(0xFF1B5E20),
        );

      case SnackbarType.error:
        final color = isDark ? _FixedColors.errorDark : _FixedColors.errorLight;
        return _SnackbarConfig(
          icon: Icons.error_rounded,
          iconColor: color,
          backgroundColor: isDark
              ? _FixedColors.errorBgDark
              : _FixedColors.errorBgLight,
          borderColor: color,
          textColor: isDark ? Colors.white : const Color(0xFF7F0000),
        );

      case SnackbarType.warning:
        final color = isDark
            ? _FixedColors.warningDark
            : _FixedColors.warningLight;
        return _SnackbarConfig(
          icon: Icons.warning_rounded,
          iconColor: color,
          backgroundColor: isDark
              ? _FixedColors.warningBgDark
              : _FixedColors.warningBgLight,
          borderColor: color,
          textColor: isDark ? Colors.white : const Color(0xFFBF360C),
        );

      case SnackbarType.info:
        // Info is the ONLY type that uses theme color — intentional
        final color = theme.colorScheme.primary;
        final bg = isDark
            ? Color.alphaBlend(color.withOpacity(0.18), const Color(0xFF121212))
            : color.withOpacity(0.10);
        return _SnackbarConfig(
          icon: Icons.info_rounded,
          iconColor: color,
          backgroundColor: bg,
          borderColor: color,
          textColor: isDark ? Colors.white : theme.colorScheme.onSurface,
        );
    }
  }
}

class _SnackbarConfig {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _SnackbarConfig({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

// ============================================================================
// ANIMATED OVERLAY VERSION — same fixed colors
// ============================================================================

class AnimatedSnackbar {
  AnimatedSnackbar._();

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) => _show(
    context,
    message: message,
    type: SnackbarType.success,
    duration: duration,
    onDismissed: onDismissed,
  );

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismissed,
  }) => _show(
    context,
    message: message,
    type: SnackbarType.error,
    duration: duration,
    onDismissed: onDismissed,
  );

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) => _show(
    context,
    message: message,
    type: SnackbarType.warning,
    duration: duration,
    onDismissed: onDismissed,
  );

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) => _show(
    context,
    message: message,
    type: SnackbarType.info,
    duration: duration,
    onDismissed: onDismissed,
  );

  static void _show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) {
    final overlay = Overlay.of(context);
    // Capture theme BEFORE the OverlayEntry builder — context may be
    // deactivated by the time the builder lambda runs on next frame.
    final theme = Theme.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _AnimatedSnackbarWidget(
        message: message,
        type: type,
        duration: duration,
        theme: theme,
        onDismissed: () {
          if (entry.mounted) entry.remove();
          onDismissed?.call();
        },
      ),
    );

    overlay.insert(entry);
  }
}

class _AnimatedSnackbarWidget extends StatefulWidget {
  final String message;
  final SnackbarType type;
  final Duration duration;
  final ThemeData theme;
  final VoidCallback onDismissed;

  const _AnimatedSnackbarWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.theme,
    required this.onDismissed,
  });

  @override
  State<_AnimatedSnackbarWidget> createState() =>
      _AnimatedSnackbarWidgetState();
}

class _AnimatedSnackbarWidgetState extends State<_AnimatedSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 380),
      vsync: this,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    // Auto-dismiss
    Future.delayed(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final config = CustomSnackbar._config(widget.type, widget.theme);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: GestureDetector(
            onHorizontalDragEnd: (d) {
              if (d.velocity.pixelsPerSecond.dx.abs() > 500) _dismiss();
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: config.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: config.borderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (_, v, __) => Transform.scale(
                        scale: v,
                        child: Icon(
                          config.icon,
                          color: config.iconColor,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: config.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Icon(
                        Icons.close,
                        color: config.textColor.withOpacity(0.6),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extension kept for other uses — no longer affects snackbar colors
extension CustomColorScheme on ColorScheme {
  Color get success => brightness == Brightness.dark
      ? const Color(0xFF4CAF50)
      : const Color(0xFF2E7D32);
  Color get warning => brightness == Brightness.dark
      ? const Color(0xFFFFA726)
      : const Color(0xFFF57C00);
  Color get info => primary;
}
