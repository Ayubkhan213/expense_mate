import 'package:flutter/material.dart';

// ============================================================================
// THEME-AWARE CUSTOM SNACKBAR
// Works with any theme automatically using ColorScheme
// ============================================================================

enum SnackbarType { success, error, warning, info }

class CustomSnackbar {
  CustomSnackbar._();

  /// Show Success Snackbar
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context,
      message: message,
      type: SnackbarType.success,
      duration: duration,
      action: action,
    );
  }

  /// Show Error Snackbar
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context,
      message: message,
      type: SnackbarType.error,
      duration: duration,
      action: action,
    );
  }

  /// Show Warning Snackbar
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
      action: action,
    );
  }

  /// Show Info Snackbar
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackbar(
      context,
      message: message,
      type: SnackbarType.info,
      duration: duration,
      action: action,
    );
  }

  /// Internal method to show snackbar
  static void _showSnackbar(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final snackbarConfig = _getSnackbarConfig(type, colorScheme, theme);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _SnackbarContent(
          message: message,
          icon: snackbarConfig.icon,
          iconColor: snackbarConfig.iconColor,
          textColor: snackbarConfig.textColor,
        ),
        backgroundColor: snackbarConfig.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: snackbarConfig.borderColor, width: 1.5),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: duration,
        action: action,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Get configuration based on type and current theme
  static _SnackbarConfig _getSnackbarConfig(
    SnackbarType type,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case SnackbarType.success:
        // Use theme's success color or fallback to green
        final successColor = _getSuccessColor(colorScheme, isDark);
        return _SnackbarConfig(
          icon: Icons.check_circle_rounded,
          iconColor: successColor,
          // ✅ Darker, more opaque background
          backgroundColor: isDark
              ? const Color(0xFF1E3A1E) // Dark green background
              : successColor.withOpacity(0.15),
          borderColor: successColor,
          textColor: isDark ? Colors.white : colorScheme.onSurface,
        );

      case SnackbarType.error:
        // Use theme's error color
        return _SnackbarConfig(
          icon: Icons.error_rounded,
          iconColor: colorScheme.error,
          // ✅ Darker, more opaque background
          backgroundColor: isDark
              ? const Color(0xFF3A1E1E) // Dark red background
              : colorScheme.error.withOpacity(0.15),
          borderColor: colorScheme.error,
          textColor: isDark ? Colors.white : colorScheme.onSurface,
        );

      case SnackbarType.warning:
        // Use theme's tertiary or create warning color
        final warningColor = _getWarningColor(colorScheme, isDark);
        return _SnackbarConfig(
          icon: Icons.warning_rounded,
          iconColor: warningColor,
          // ✅ Darker, more opaque background
          backgroundColor: isDark
              ? const Color(0xFF3A2E1E) // Dark orange background
              : warningColor.withOpacity(0.15),
          borderColor: warningColor,
          textColor: isDark ? Colors.white : colorScheme.onSurface,
        );

      case SnackbarType.info:
        // Use theme's primary color for info
        return _SnackbarConfig(
          icon: Icons.info_rounded,
          iconColor: colorScheme.primary,
          // ✅ Darker, more opaque background
          backgroundColor: isDark
              ? const Color(0xFF1E2A3A) // Dark blue background
              : colorScheme.primary.withOpacity(0.15),
          borderColor: colorScheme.primary,
          textColor: isDark ? Colors.white : colorScheme.onSurface,
        );
    }
  }

  /// Get success color from theme or default
  static Color _getSuccessColor(ColorScheme colorScheme, bool isDark) {
    // Try to use tertiary as success, or fallback to green
    if (colorScheme.tertiary != colorScheme.primary) {
      return colorScheme.tertiary;
    }
    return isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);
  }

  /// Get warning color from theme or default
  static Color _getWarningColor(ColorScheme colorScheme, bool isDark) {
    // Use a blend of primary and error, or default orange
    return isDark ? const Color(0xFFFFA726) : const Color(0xFFF57C00);
  }
}

/// Snackbar Configuration Model
class _SnackbarConfig {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  _SnackbarConfig({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

/// Snackbar Content Widget
class _SnackbarContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  const _SnackbarContent({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ENHANCED ANIMATED VERSION - Theme Aware
// ============================================================================

class AnimatedSnackbar {
  AnimatedSnackbar._();

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) {
    _showAnimatedSnackbar(
      context,
      message: message,
      type: SnackbarType.success,
      duration: duration,
      onDismissed: onDismissed,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismissed,
  }) {
    _showAnimatedSnackbar(
      context,
      message: message,
      type: SnackbarType.error,
      duration: duration,
      onDismissed: onDismissed,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) {
    _showAnimatedSnackbar(
      context,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
      onDismissed: onDismissed,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) {
    _showAnimatedSnackbar(
      context,
      message: message,
      type: SnackbarType.info,
      duration: duration,
      onDismissed: onDismissed,
    );
  }

  static void _showAnimatedSnackbar(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackbarWidget(
        message: message,
        type: type,
        duration: duration,
        onDismissed: () {
          overlayEntry.remove();
          onDismissed?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        onDismissed?.call();
      }
    });
  }
}

/// Animated Snackbar Widget - Theme Aware
class _AnimatedSnackbarWidget extends StatefulWidget {
  final String message;
  final SnackbarType type;
  final Duration duration;
  final VoidCallback onDismissed;

  const _AnimatedSnackbarWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_AnimatedSnackbarWidget> createState() =>
      _AnimatedSnackbarWidgetState();
}

class _AnimatedSnackbarWidgetState extends State<_AnimatedSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final config = CustomSnackbar._getSnackbarConfig(
      widget.type,
      colorScheme,
      theme,
    );

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx.abs() > 500) {
                _dismiss();
              }
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
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon with animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 600),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            config.icon,
                            color: config.iconColor,
                            size: 24,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),

                    // Message
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Close button
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        // color: config.textColor.withOpacity(0.6),
                        size: 20,
                      ),
                      onPressed: _dismiss,
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      constraints: const BoxConstraints(),
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

// ============================================================================
// OPTIONAL: Enhanced Theme Extension for Custom Colors
// Add this to your theme files for better control
// ============================================================================

extension CustomColorScheme on ColorScheme {
  // Success color
  Color get success => brightness == Brightness.dark
      ? const Color(0xFF4CAF50)
      : const Color(0xFF2E7D32);

  // Warning color
  Color get warning => brightness == Brightness.dark
      ? const Color(0xFFFFA726)
      : const Color(0xFFF57C00);

  // Info color (uses primary by default)
  Color get info => primary;
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

class SnackbarExamples extends StatelessWidget {
  const SnackbarExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                CustomSnackbar.showSuccess(context, 'Success message!');
              },
              child: const Text('Show Success'),
            ),
            ElevatedButton(
              onPressed: () {
                CustomSnackbar.showError(context, 'Error message!');
              },
              child: const Text('Show Error'),
            ),
            ElevatedButton(
              onPressed: () {
                CustomSnackbar.showWarning(context, 'Warning message!');
              },
              child: const Text('Show Warning'),
            ),
            ElevatedButton(
              onPressed: () {
                CustomSnackbar.showInfo(context, 'Info message!');
              },
              child: const Text('Show Info'),
            ),
            const SizedBox(height: 40),
            const Text('--- Animated Versions ---'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AnimatedSnackbar.showSuccess(context, 'Animated Success!');
              },
              child: const Text('Animated Success'),
            ),
          ],
        ),
      ),
    );
  }
}
