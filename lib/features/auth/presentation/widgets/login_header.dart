// lib/features/auth/presentation/component/login_header.dart

import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final LoginState state;
  final Color primary;
  final bool isDark;
  final VoidCallback onToggle;

  const LoginHeader({
    super.key,
    required this.state,
    required this.primary,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        // Title
        Text(
          t.welcomeBack,
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          t.signInToContinue,
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),

        // Always show toggle — same as original behaviour
        const SizedBox(height: 24),
        _ModeTogglePill(
          mode: state.mode,
          primary: primary,
          isDark: isDark,
          onToggle: onToggle,
          t: t,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toggle pill — Password | Quick PIN
// ─────────────────────────────────────────────────────────────────────────────

class _ModeTogglePill extends StatelessWidget {
  final LoginMode mode;
  final Color primary;
  final bool isDark;
  final VoidCallback onToggle;
  final AppLocalizations t;

  const _ModeTogglePill({
    required this.mode,
    required this.primary,
    required this.isDark,
    required this.onToggle,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoginToggleButton(
            icon: Icons.login_rounded,
            label: t.password,
            isSelected: mode == LoginMode.emailPassword,
            primary: primary,
            onTap: mode == LoginMode.emailPassword ? null : onToggle,
          ),
          const SizedBox(width: 4),
          LoginToggleButton(
            icon: Icons.pin_rounded,
            label: t.quickPin,
            isSelected: mode == LoginMode.pin,
            primary: primary,
            onTap: mode == LoginMode.pin ? null : onToggle,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual toggle button — replaces old ToggleButtonComponent
// ─────────────────────────────────────────────────────────────────────────────

class LoginToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color primary;
  final VoidCallback? onTap;

  const LoginToggleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
