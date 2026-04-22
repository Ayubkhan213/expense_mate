// lib/features/auth/presentation/pages/forgot_password_face.dart

import 'package:spendio/core/common/custom_snackbar.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/features/auth/presentation/bloc/forget_password_bloc/forget_password_bloc.dart';
import 'package:spendio/features/auth/presentation/bloc/forget_password_bloc/forget_password_event.dart';
import 'package:spendio/features/auth/presentation/bloc/forget_password_bloc/forget_password_state.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ForgotPasswordFace — entry point
// ─────────────────────────────────────────────────────────────────────────────

class ForgotPasswordFace extends StatelessWidget {
  const ForgotPasswordFace({super.key});

  @override
  Widget build(BuildContext context) {
    return _ForgotPasswordView();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal view — reads bloc
// ─────────────────────────────────────────────────────────────────────────────

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _recoveryKeyController = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _recoveryKeyController.dispose();
    _answer1Controller.dispose();
    _answer2Controller.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (p, c) => p.status != c.status || p.step != c.step,
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.error &&
            state.errorMessage != null) {
          AnimatedSnackbar.showError(context, state.errorMessage!);
        }
        if (state.step == ForgotPasswordStep.done) {
          AnimatedSnackbar.showSuccess(
            context,
            'Password reset successfully! Please log in.',
          );
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: isDark
                ? theme.colorScheme.background
                : const Color(0xFFF2F4F8),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Header ──────────────────────────────────────
                    _FpHeader(state: state, primary: primary),

                    const SizedBox(height: 32),

                    // ── Step content ────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(state.step),
                        child: _buildStepContent(
                          context,
                          state,
                          isDark,
                          primary,
                          theme,
                          t,
                        ),
                      ),
                    ),

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

  Widget _buildStepContent(
    BuildContext context,
    ForgotPasswordState state,
    bool isDark,
    Color primary,
    ThemeData theme,
    AppLocalizations t,
  ) {
    switch (state.step) {
      case ForgotPasswordStep.enterEmail:
        return _StepEnterEmail(
          formKey: _emailFormKey,
          controller: _emailController,
          isDark: isDark,
          primary: primary,
          isLoading: state.status == ForgotPasswordStatus.loading,
          t: t,
        );

      case ForgotPasswordStep.chooseMethod:
        return _StepChooseMethod(
          state: state,
          isDark: isDark,
          primary: primary,
          recoveryKeyController: _recoveryKeyController,
          answer1Controller: _answer1Controller,
          answer2Controller: _answer2Controller,
          t: t,
        );

      case ForgotPasswordStep.verifyRecoveryKey:
      case ForgotPasswordStep.verifySecurityQuestions:
        // Handled inside chooseMethod step
        return const SizedBox.shrink();

      case ForgotPasswordStep.setNewPassword:
        return _StepSetNewPassword(
          state: state,
          isDark: isDark,
          primary: primary,
          newPasswordController: _newPasswordController,
          confirmPasswordController: _confirmPasswordController,
          t: t,
        );

      case ForgotPasswordStep.done:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header — adapts to current step
// ─────────────────────────────────────────────────────────────────────────────

class _FpHeader extends StatelessWidget {
  final ForgotPasswordState state;
  final Color primary;

  const _FpHeader({required this.state, required this.primary});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final (icon, title, subtitle) = switch (state.step) {
      ForgotPasswordStep.enterEmail => (
        Icons.email_outlined,
        t.forgotPassword,
        t.enterEmailToFind,
      ),
      ForgotPasswordStep.chooseMethod => (
        Icons.lock_reset_rounded,
        t.verifyIdentity,
        t.chooseRecoveryMethod,
      ),
      ForgotPasswordStep.setNewPassword => (
        Icons.lock_outline_rounded,
        t.setNewPassword,
        t.chooseStrongPassword,
      ),
      _ => (
        Icons.check_circle_outline_rounded,
        t.allDone,
        t.passwordResetSuccess,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon badge
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: primary, size: 28),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 20),
        // Progress indicator
        _StepProgressBar(step: state.step, primary: primary, t: t),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step progress bar
// ─────────────────────────────────────────────────────────────────────────────

class _StepProgressBar extends StatelessWidget {
  final ForgotPasswordStep step;
  final Color primary;
  final AppLocalizations t;

  const _StepProgressBar({
    required this.step,
    required this.primary,
    required this.t,
  });

  double get _progress => switch (step) {
    ForgotPasswordStep.enterEmail => 0.25,
    ForgotPasswordStep.chooseMethod => 0.60,
    ForgotPasswordStep.verifyRecoveryKey => 0.60,
    ForgotPasswordStep.verifySecurityQuestions => 0.60,
    ForgotPasswordStep.setNewPassword => 0.85,
    ForgotPasswordStep.done => 1.0,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.12),
            color: primary,
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          switch (step) {
            ForgotPasswordStep.enterEmail => t.step1of3,
            ForgotPasswordStep.chooseMethod => t.step2of3,
            ForgotPasswordStep.verifyRecoveryKey => t.step2of3,
            ForgotPasswordStep.verifySecurityQuestions => t.step2of3,
            ForgotPasswordStep.setNewPassword => t.step3of3,
            ForgotPasswordStep.done => t.complete,
          },
          style: AppTextStyles.captionSmall.copyWith(
            color: primary.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Enter Email
// ─────────────────────────────────────────────────────────────────────────────

class _StepEnterEmail extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isDark;
  final Color primary;
  final bool isLoading;
  final AppLocalizations t;

  const _StepEnterEmail({
    required this.formKey,
    required this.controller,
    required this.isDark,
    required this.primary,
    required this.isLoading,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FpCard(
            isDark: isDark,
            child: _FpTextField(
              controller: controller,
              label: t.emailAddress,
              hint: t.emailHint,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              primary: primary,
              validator: (v) =>
                  v == null || !v.contains('@') || !v.contains('.')
                  ? t.enterValidEmail
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          _FpButton(
            label: t.findMyAccount,
            icon: Icons.search_rounded,
            primary: primary,
            isLoading: isLoading,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordEmailSubmitted(controller.text.trim()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 — Choose Method + inline verification
// ─────────────────────────────────────────────────────────────────────────────

class _StepChooseMethod extends StatelessWidget {
  final ForgotPasswordState state;
  final bool isDark;
  final Color primary;
  final TextEditingController recoveryKeyController;
  final TextEditingController answer1Controller;
  final TextEditingController answer2Controller;
  final AppLocalizations t;

  const _StepChooseMethod({
    required this.state,
    required this.isDark,
    required this.primary,
    required this.recoveryKeyController,
    required this.answer1Controller,
    required this.answer2Controller,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = state.status == ForgotPasswordStatus.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Method selector ─────────────────────────────────────────────────
        if (state.userHasRecoveryKeys && state.userHasSecurityQuestions) ...[
          _SectionLabel(label: t.recoveryMethod, primary: primary),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MethodTile(
                  icon: Icons.key_rounded,
                  label: t.recoveryKey,
                  selected:
                      state.selectedMethod == ForgotPasswordMethod.recoveryKey,
                  primary: primary,
                  isDark: isDark,
                  onTap: () => context.read<ForgotPasswordBloc>().add(
                    ForgotPasswordMethodChanged(
                      ForgotPasswordMethod.recoveryKey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MethodTile(
                  icon: Icons.help_outline_rounded,
                  label: t.securityQA,
                  selected:
                      state.selectedMethod ==
                      ForgotPasswordMethod.securityQuestions,
                  primary: primary,
                  isDark: isDark,
                  onTap: () => context.read<ForgotPasswordBloc>().add(
                    ForgotPasswordMethodChanged(
                      ForgotPasswordMethod.securityQuestions,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],

        // ── Method content ──────────────────────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: state.selectedMethod == ForgotPasswordMethod.recoveryKey
              ? KeyedSubtree(
                  key: const ValueKey('key'),
                  child: _RecoveryKeyPanel(
                    state: state,
                    isDark: isDark,
                    primary: primary,
                    controller: recoveryKeyController,
                    isLoading: isLoading,
                    t: t,
                  ),
                )
              : KeyedSubtree(
                  key: const ValueKey('qa'),
                  child: _SecurityQaPanel(
                    state: state,
                    isDark: isDark,
                    primary: primary,
                    answer1Controller: answer1Controller,
                    answer2Controller: answer2Controller,
                    isLoading: isLoading,
                    t: t,
                  ),
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recovery Key Panel
// ─────────────────────────────────────────────────────────────────────────────

class _RecoveryKeyPanel extends StatelessWidget {
  final ForgotPasswordState state;
  final bool isDark;
  final Color primary;
  final TextEditingController controller;
  final bool isLoading;
  final AppLocalizations t;

  const _RecoveryKeyPanel({
    required this.state,
    required this.isDark,
    required this.primary,
    required this.controller,
    required this.isLoading,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info banner
        _InfoBanner(
          icon: Icons.info_outline_rounded,
          message: t.enterRecoveryKeyHint,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),

        _SectionLabel(label: t.recoveryKey, primary: primary),
        const SizedBox(height: 10),

        _FpCard(
          isDark: isDark,
          child: _FpTextField(
            controller: controller,
            label: t.recoveryKey,
            hint: t.recoveryKeyHint,
            icon: Icons.key_rounded,
            primary: primary,
            textCapitalization: TextCapitalization.characters,
            onChanged: (v) => context.read<ForgotPasswordBloc>().add(
              ForgotPasswordKeyChanged(v),
            ),
          ),
        ),

        const SizedBox(height: 24),

        _FpButton(
          label: t.verifyKey,
          icon: Icons.verified_rounded,
          primary: primary,
          isLoading: isLoading,
          onPressed: state.recoveryKeyInput.isEmpty
              ? null
              : () => context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordVerifyKey(),
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Security Q&A Panel
// ─────────────────────────────────────────────────────────────────────────────

class _SecurityQaPanel extends StatelessWidget {
  final ForgotPasswordState state;
  final bool isDark;
  final Color primary;
  final TextEditingController answer1Controller;
  final TextEditingController answer2Controller;
  final bool isLoading;
  final AppLocalizations t;

  const _SecurityQaPanel({
    required this.state,
    required this.isDark,
    required this.primary,
    required this.answer1Controller,
    required this.answer2Controller,
    required this.isLoading,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info banner
        _InfoBanner(
          icon: Icons.info_outline_rounded,
          message: t.answerAtLeastOne,
          color: Colors.amber,
        ),
        const SizedBox(height: 16),

        // Question 1
        _SectionLabel(label: t.question1, primary: primary),
        const SizedBox(height: 8),
        _FpCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Text(
                  state.securityQuestion1 ?? '—',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outline.withValues(
                  alpha: isDark ? 0.12 : 0.07,
                ),
              ),
              _FpTextField(
                controller: answer1Controller,
                label: t.yourAnswer,
                hint: t.typeYourAnswer,
                icon: Icons.edit_note_rounded,
                primary: primary,
                onChanged: (v) => context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordAnswerChanged(1, v),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Question 2
        _SectionLabel(label: t.question2, primary: primary),
        const SizedBox(height: 8),
        _FpCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Text(
                  state.securityQuestion2 ?? '—',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outline.withValues(
                  alpha: isDark ? 0.12 : 0.07,
                ),
              ),
              _FpTextField(
                controller: answer2Controller,
                label: t.yourAnswer,
                hint: t.typeYourAnswer,
                icon: Icons.edit_note_rounded,
                primary: primary,
                onChanged: (v) => context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordAnswerChanged(2, v),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _FpButton(
          label: t.verifyAnswers,
          icon: Icons.fact_check_rounded,
          primary: primary,
          isLoading: isLoading,
          onPressed: (state.answer1.isEmpty && state.answer2.isEmpty)
              ? null
              : () => context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordVerifyAnswers(),
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 — Set New Password
// ─────────────────────────────────────────────────────────────────────────────

class _StepSetNewPassword extends StatelessWidget {
  final ForgotPasswordState state;
  final bool isDark;
  final Color primary;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final AppLocalizations t;

  const _StepSetNewPassword({
    required this.state,
    required this.isDark,
    required this.primary,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = state.status == ForgotPasswordStatus.loading;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success verification badge
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_rounded, color: Colors.green, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  t.identityVerified,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _SectionLabel(label: t.newPassword, primary: primary),
        const SizedBox(height: 10),

        _FpCard(
          isDark: isDark,
          child: Column(
            children: [
              _FpTextField(
                controller: newPasswordController,
                label: t.newPassword,
                hint: t.minimumSixChars,
                icon: Icons.lock_outline_rounded,
                primary: primary,
                obscureText: state.obscureNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureNewPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  onPressed: () => context.read<ForgotPasswordBloc>().add(
                    ForgotPasswordToggleNewPasswordVisibility(),
                  ),
                ),
                onChanged: (v) => context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordNewPasswordChanged(v),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.outline.withValues(
                  alpha: isDark ? 0.12 : 0.07,
                ),
              ),
              _FpTextField(
                controller: confirmPasswordController,
                label: t.confirmPassword,
                hint: t.reEnterPassword,
                icon: Icons.lock_outline_rounded,
                primary: primary,
                obscureText: state.obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  onPressed: () => context.read<ForgotPasswordBloc>().add(
                    ForgotPasswordToggleConfirmPasswordVisibility(),
                  ),
                ),
                onChanged: (v) => context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordConfirmPasswordChanged(v),
                ),
              ),
            ],
          ),
        ),

        // Password match indicator
        if (state.newPassword.isNotEmpty && state.confirmPassword.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                Icon(
                  state.newPassword == state.confirmPassword
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  size: 14,
                  color: state.newPassword == state.confirmPassword
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  state.newPassword == state.confirmPassword
                      ? t.passwordsMatch
                      : t.passwordsDoNotMatch,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: state.newPassword == state.confirmPassword
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 28),

        _FpButton(
          label: t.resetPassword,
          icon: Icons.lock_reset_rounded,
          primary: primary,
          isLoading: isLoading,
          onPressed:
              state.newPassword.length < 6 ||
                  state.newPassword != state.confirmPassword
              ? null
              : () => context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordResetSubmitted(),
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _MethodTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color primary;
  final bool isDark;
  final VoidCallback onTap;

  const _MethodTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.primary,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.08)
              : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? primary.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.12),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 26,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.captionSmall.copyWith(
                color: selected
                    ? primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.55),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _InfoBanner({
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.captionSmall.copyWith(
                color: color == Colors.amber
                    ? Colors.amber.shade800
                    : color.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FpCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _FpCard({required this.child, required this.isDark});

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

class _FpTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color primary;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const _FpTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.primary,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.validator,
    this.onChanged,
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
        textCapitalization: textCapitalization,
        validator: validator,
        onChanged: onChanged,
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

class _FpButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color primary;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _FpButton({
    required this.label,
    required this.icon,
    required this.primary,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null && !isLoading;
    return AnimatedOpacity(
      opacity: isDisabled ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
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
      ),
    );
  }
}

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
