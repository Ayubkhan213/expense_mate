import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:expense_mate/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickLoginComponent extends StatelessWidget {
  final Color primary;
  final bool isDark;

  const QuickLoginComponent({
    super.key,
    required this.primary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // Wrap in Directionality so it always renders LTR (same as original)
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (p, c) =>
            p.enteredPin != c.enteredPin ||
            p.status != c.status ||
            p.storedAccount != c.storedAccount,
        builder: (context, state) {
          final isLoading = state.status == LoginStatus.loading;
          final hasError =
              state.status == LoginStatus.unauthenticated &&
              state.errorMessage != null;
          final theme = Theme.of(context);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Account avatar + name ───────────────────────────
              if (state.storedAccount != null) ...[
                _PinAccountHeader(
                  account: state.storedAccount!,
                  primary: primary,
                  t: t,
                ),
                const SizedBox(height: 28),
              ] else ...[
                Text(
                  t.enterPin,
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t.usePin,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // ── PIN dots ────────────────────────────────────────
              _PinDots(
                pin: state.enteredPin,
                primary: primary,
                hasError: hasError,
                isLoading: isLoading,
              ),

              const SizedBox(height: 10),

              // ── Error label ─────────────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: hasError
                    ? Padding(
                        key: const ValueKey('err'),
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          state.errorMessage!,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox(key: ValueKey('no-err'), height: 18),
              ),

              const SizedBox(height: 12),

              // ── Number pad ──────────────────────────────────────
              _NumberPad(primary: primary, isLoading: isLoading),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Account header shown above PIN dots
// ─────────────────────────────────────────────────────────────────────────────

class _PinAccountHeader extends StatelessWidget {
  final dynamic account;
  final Color primary;
  final AppLocalizations t;

  const _PinAccountHeader({
    required this.account,
    required this.primary,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 4),
        Text(
          t.enterYour4DigitPin,
          style: AppTextStyles.captionSmall.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PIN dots row
// ─────────────────────────────────────────────────────────────────────────────

class _PinDots extends StatelessWidget {
  final String pin;
  final Color primary;
  final bool hasError;
  final bool isLoading;

  const _PinDots({
    required this.pin,
    required this.primary,
    required this.hasError,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotColor = hasError ? theme.colorScheme.error : primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final filled = i < pin.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? dotColor : Colors.transparent,
            border: Border.all(
              color: filled
                  ? dotColor
                  : theme.colorScheme.outline.withValues(alpha: 0.35),
              width: 2,
            ),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: dotColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Number pad
// ─────────────────────────────────────────────────────────────────────────────

class _NumberPad extends StatelessWidget {
  final Color primary;
  final bool isLoading;

  const _NumberPad({required this.primary, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              if (key.isEmpty) {
                return const SizedBox(width: 80, height: 70);
              }
              return _NumKey(
                label: key,
                primary: primary,
                isLoading: isLoading,
                onTap: () {
                  if (isLoading) return;
                  HapticFeedback.lightImpact();
                  if (key == 'del') {
                    context.read<LoginBloc>().add(LoginPinDigitDeleted());
                  } else {
                    context.read<LoginBloc>().add(LoginPinDigitEntered(key));
                  }
                },
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final Color primary;
  final bool isLoading;
  final VoidCallback onTap;

  const _NumKey({
    required this.label,
    required this.primary,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDel = label == 'del';

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 78,
        height: 68,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isDel ? Colors.transparent : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDel
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: isDel
              ? null
              : Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.08),
                ),
        ),
        child: Center(
          child: isDel
              ? Icon(
                  Icons.backspace_outlined,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  size: 22,
                )
              : Text(
                  label,
                  style: AppTextStyles.h5.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
