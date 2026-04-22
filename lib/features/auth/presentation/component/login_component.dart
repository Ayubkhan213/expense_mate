import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:spendio/l10n/app_localizations.dart';

class LoginComponent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Color primary;
  final bool isDark;

  const LoginComponent({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.primary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p, c) =>
          p.obscurePassword != c.obscurePassword || p.status != c.status,
      builder: (context, state) {
        final isLoading = state.status == LoginStatus.loading;

        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section label ───────────────────────────────────
              _SectionLabel(label: t.signIn, primary: primary),
              const SizedBox(height: 10),

              // ── Fields card ─────────────────────────────────────
              _LoginCard(
                isDark: isDark,
                child: Column(
                  children: [
                    _LoginField(
                      controller: emailController,
                      label: t.emailAddress,
                      hint: t.emailHint,
                      icon: Icons.email_outlined,
                      primary: primary,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v == null || !v.contains('@') || !v.contains('.')
                          ? t.enterValidEmail
                          : null,
                    ),
                    _LoginDivider(isDark: isDark),
                    _LoginField(
                      controller: passwordController,
                      label: t.password,
                      hint: t.enterYourPassword,
                      icon: Icons.lock_outline_rounded,
                      primary: primary,
                      obscureText: state.obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        onPressed: () => context.read<LoginBloc>().add(
                          LoginTogglePasswordVisibility(),
                        ),
                      ),
                      validator: (v) =>
                          v != null && v.length >= 6 ? null : t.passwordMinSix,
                    ),
                  ],
                ),
              ),

              // ── Forgot password ─────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteName.forgotPassword),
                  child: Text(
                    t.forgotPassword,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // ── Sign in button ──────────────────────────────────
              _LoginButton(
                label: t.signIn,
                icon: Icons.login_rounded,
                primary: primary,
                isLoading: isLoading,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(
                      LoginSubmitted(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

//
// ─────────────────────────────────────────────────────────────────────────────
// Reusable small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color primary;
  const _SectionLabel({required this.label, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.overline.copyWith(
        color: primary.withValues(alpha: 0.8),
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _LoginCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      child: child,
    );
  }
}

class _LoginDivider extends StatelessWidget {
  final bool isDark;
  const _LoginDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(
        context,
      ).colorScheme.outline.withValues(alpha: isDark ? 0.12 : 0.07),
    );
  }
}

class _LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color primary;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _LoginField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.primary,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: AppTextStyles.bodySmall.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            size: 20,
            color: primary.withValues(alpha: 0.6),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          labelStyle: AppTextStyles.captionSmall.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          errorStyle: AppTextStyles.captionSmall.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color primary;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _LoginButton({
    required this.label,
    required this.icon,
    required this.primary,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: isLoading ? 0 : 3,
          shadowColor: primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
