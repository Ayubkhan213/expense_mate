// lib/features/auth/presentation/pages/login_face.dart

import 'package:spendio/core/common/custom_snackbar.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/features/auth/domain/repository/auth_repository.dart';
import 'package:spendio/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:spendio/features/auth/presentation/widgets/login_flip_card.dart';
import 'package:spendio/features/auth/presentation/widgets/login_header.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFace extends StatefulWidget {
  const LoginFace({super.key});

  @override
  State<LoginFace> createState() => _LoginFaceState();
}

class _LoginFaceState extends State<LoginFace>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLoginMode(BuildContext context, LoginState state) {
    if (state.isAnimating) return;

    context.read<LoginBloc>().add(LoginToggleMode());

    final animation = state.mode == LoginMode.emailPassword
        ? _animationController.forward
        : _animationController.reverse;

    animation().then((_) {
      context.read<LoginBloc>().add(LoginSetAnimating(false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (ctx, state) {
        if (state.status == LoginStatus.authenticated) {
          AnimatedSnackbar.showSuccess(ctx, t.loginSuccessful);
          Navigator.pushReplacementNamed(ctx, 'home');
        }
        if (state.status == LoginStatus.error && state.errorMessage != null) {
          AnimatedSnackbar.showError(ctx, state.errorMessage!);
        }
        if (state.status == LoginStatus.unauthenticated &&
            state.errorMessage != null) {
          AnimatedSnackbar.showError(ctx, state.errorMessage!);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (p, c) =>
            p.mode != c.mode ||
            p.isAnimating != c.isAnimating ||
            p.storedAccount != c.storedAccount ||
            // rebuild when canUsePinLogin changes (account loaded with/without PIN)
            (p.storedAccount?.pin != c.storedAccount?.pin),
        builder: (context, state) {
          return Scaffold(
            backgroundColor: isDark
                ? theme.colorScheme.background
                : const Color(0xFFF2F4F8),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // ── Logo ─────────────────────────────────────
                    _LoginLogo(primary: primary),

                    const SizedBox(height: 28),

                    // ── Header + mode toggle ──────────────────────
                    LoginHeader(
                      state: state,
                      primary: primary,
                      isDark: isDark,
                      onToggle: () => _toggleLoginMode(context, state),
                    ),

                    const SizedBox(height: 32),

                    // ── Flip card ─────────────────────────────────
                    LoginFlipCard(
                      animation: _flipAnimation,
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      primary: primary,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 24),

                    // ── Bottom section ────────────────────────────
                    _BottomSection(primary: primary, isDark: isDark),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo widget
// ─────────────────────────────────────────────────────────────────────────────

class _LoginLogo extends StatelessWidget {
  final Color primary;
  const _LoginLogo({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withValues(alpha: 0.72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.account_balance_wallet_rounded,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom — sign-up link OR single-account notice
// ─────────────────────────────────────────────────────────────────────────────

class _BottomSection extends StatelessWidget {
  final Color primary;
  final bool isDark;
  const _BottomSection({required this.primary, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p, c) => p.storedAccount != c.storedAccount,
      builder: (ctx, state) {
        // Account exists — single-account notice
        if (state.storedAccount != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t.singleAccountNotice,
                    style: AppTextStyles.captionSmall.copyWith(
                      color: Colors.amber.shade800,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // No account — show sign-up link
        return Container(
          padding: const EdgeInsets.all(16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                t.dontHaveAccount,
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(ctx, 'signup'),
                child: Text(
                  t.createAccount,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
