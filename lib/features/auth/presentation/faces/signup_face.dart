import 'dart:io';

import 'package:spendio/core/common/custom_snackbar.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';

import 'package:spendio/features/auth/presentation/bloc/signup_bloc/signup_bloc.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Security question banks
// ─────────────────────────────────────────────────────────────────────────────
// const List<String> _kSecurityQuestions1 = [
//   'What was the name of your first pet?',
//   'What is the name of the city where you were born?',
//   'What was the make of your first car?',
//   'What is your mother\'s maiden name?',
//   'What was the name of your elementary school?',
//   'What was your childhood nickname?',
//   'What is the name of the street you grew up on?',
// ];

// const List<String> _kSecurityQuestions2 = [
//   'What is the name of your oldest sibling?',
//   'What was the first concert you attended?',
//   'What was the name of your favorite teacher?',
//   'In what city did you meet your spouse/partner?',
//   'What was the first album you purchased?',
//   'What is your oldest cousin\'s first name?',
//   'What was the name of your first stuffed animal or toy?',
// ];
// REMOVE the two const lists at the top and REPLACE WITH:
List<String> _getSecurityQuestions1(AppLocalizations t) => [
  t.secQ1_1,
  t.secQ1_2,
  t.secQ1_3,
  t.secQ1_4,
  t.secQ1_5,
  t.secQ1_6,
  t.secQ1_7,
];

List<String> _getSecurityQuestions2(AppLocalizations t) => [
  t.secQ2_1,
  t.secQ2_2,
  t.secQ2_3,
  t.secQ2_4,
  t.secQ2_5,
  t.secQ2_6,
  t.secQ2_7,
];

// ─────────────────────────────────────────────────────────────────────────────
// SignupFace
// ─────────────────────────────────────────────────────────────────────────────
class SignupFace extends StatefulWidget {
  const SignupFace({super.key});

  @override
  State<SignupFace> createState() => _SignupFaceState();
}

class _SignupFaceState extends State<SignupFace> {
  // Controllers — StatefulWidget only for dispose(), zero setState calls
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _pinController = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pinController.dispose();
    _answer1Controller.dispose();
    _answer2Controller.dispose();
    super.dispose();
  }

  void _handleSignUp(SignupState state, AppLocalizations t) {
    if (!state.agreedToTerms) {
      AnimatedSnackbar.showError(context, t.pleaseAgreeToTerms);
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (state.securityQuestionsEnabled) {
      if (state.selectedSecurityQ1 == null ||
          state.selectedSecurityQ2 == null) {
        AnimatedSnackbar.showError(context, t.pleasSelectBothQuestions);
        return;
      }
      print(state.securityAnswer1.trim());
      print(state.securityAnswer2.trim());
      if (state.securityAnswer1.trim().isEmpty ||
          state.securityAnswer2.trim().isEmpty) {
        AnimatedSnackbar.showError(context, t.pleaseAnswerBothQuestions);
        return;
      }
    }

    context.read<SignupBloc>().add(
      SignupSubmitted(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        pin: _pinController.text.trim().isEmpty
            ? null
            : _pinController.text.trim(),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (file != null && context.mounted) {
        context.read<SignupBloc>().add(SignupProfileImageChanged(file.path));
      }
    } catch (_) {}
  }

  void _showImageSourceSheet(BuildContext context, AppLocalizations t) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              t.choosePhoto,
              style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SheetOption(
                    icon: Icons.camera_alt_rounded,
                    label: t.camera,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(context, ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetOption(
                    icon: Icons.photo_library_rounded,
                    label: t.gallery,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(context, ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.recoveryKeys != c.recoveryKeys,
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          if (state.recoveryKeys != null && state.recoveryKeys!.isNotEmpty) {
            // Show recovery keys dialog FIRST, then navigate on close
            _showRecoveryKeysDialog(context, state.recoveryKeys!, t);
          } else {
            AnimatedSnackbar.showSuccess(context, t.accountCreatedSuccessfully);
            Navigator.pop(context);
          }
        }
        if (state.status == SignupStatus.error) {
          AnimatedSnackbar.showError(
            context,
            state.errorMessage ?? t.somethingWentWrong,
          );
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        buildWhen: (p, c) =>
            p.obscurePassword != c.obscurePassword ||
            p.obscureConfirmPassword != c.obscureConfirmPassword ||
            p.selectedCurrency != c.selectedCurrency ||
            p.currencies != c.currencies ||
            p.status != c.status ||
            p.pendingProfileImagePath != c.pendingProfileImagePath ||
            p.securityQuestionsEnabled != c.securityQuestionsEnabled ||
            p.selectedSecurityQ1 != c.selectedSecurityQ1 ||
            p.selectedSecurityQ2 != c.selectedSecurityQ2 ||
            p.agreedToTerms != c.agreedToTerms,
        builder: (context, state) {
          final isLoading = state.status == SignupStatus.loading;

          return Scaffold(
            backgroundColor: isDark
                ? theme.colorScheme.background
                : const Color(0xFFF2F4F8),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // ── Profile image picker ──────────────────────
                        _ProfileImagePicker(
                          imagePath: state.pendingProfileImagePath,
                          primary: primary,
                          onTap: () => _showImageSourceSheet(context, t),
                          onClear: () => context.read<SignupBloc>().add(
                            SignupProfileImageChanged(null),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Section: Personal Info ────────────────────
                        _SectionLabel(label: t.personalInfo, primary: primary),
                        const SizedBox(height: 12),

                        _SignupCard(
                          isDark: isDark,
                          child: Column(
                            children: [
                              _FormField(
                                controller: _nameController,
                                label: t.fullName,
                                hint: t.enterFullName,
                                icon: Icons.person_outline_rounded,
                                validator: (v) =>
                                    v == null || v.trim().length < 3
                                    ? t.enterValidName
                                    : null,
                              ),
                              _Divider(isDark: isDark),
                              _FormField(
                                controller: _emailController,
                                label: t.emailAddress,
                                hint: t.emailHint,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) =>
                                    v == null ||
                                        !v.contains('@') ||
                                        !v.contains('.')
                                    ? t.emailError
                                    : null,
                              ),
                              _Divider(isDark: isDark),
                              _FormField(
                                controller: _phoneController,
                                label: t.phoneNumber,
                                hint: t.optional,
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Section: Currency ─────────────────────────
                        _SectionLabel(
                          label: t.preferredCurrency,
                          primary: primary,
                        ),
                        const SizedBox(height: 12),

                        _SignupCard(
                          isDark: isDark,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: state.isLoadingCurrencies
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: state.selectedCurrency,
                                      isExpanded: true,
                                      icon: Icon(
                                        Icons.expand_more_rounded,
                                        color: primary,
                                      ),
                                      dropdownColor: isDark
                                          ? theme.colorScheme.surface
                                          : Colors.white,
                                      items: state.currencies.map((c) {
                                        return DropdownMenuItem(
                                          value: c.code,
                                          child: Text(
                                            '${c.flag}  ${c.code} — ${c.name}',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        if (v != null) {
                                          context.read<SignupBloc>().add(
                                            SignupCurrencyChanged(v),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Section: Security ─────────────────────────
                        _SectionLabel(label: t.security, primary: primary),
                        const SizedBox(height: 12),

                        _SignupCard(
                          isDark: isDark,
                          child: Column(
                            children: [
                              // Password
                              _FormField(
                                controller: _passwordController,
                                label: t.password,
                                hint: t.minimumSixChars,
                                icon: Icons.lock_outline_rounded,
                                obscureText: state.obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                  onPressed: () => context
                                      .read<SignupBloc>()
                                      .add(SignupTogglePasswordVisibility()),
                                ),
                                validator: (v) => v != null && v.length >= 6
                                    ? null
                                    : t.passwordMinSix,
                              ),
                              _Divider(isDark: isDark),
                              // Confirm Password
                              _FormField(
                                controller: _confirmPasswordController,
                                label: t.confirmPassword,
                                hint: t.reEnterPassword,
                                icon: Icons.lock_outline_rounded,
                                obscureText: state.obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                  onPressed: () =>
                                      context.read<SignupBloc>().add(
                                        SignupToggleConfirmPasswordVisibility(),
                                      ),
                                ),
                                validator: (v) => v == _passwordController.text
                                    ? null
                                    : t.passwordsDoNotMatch,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Section: Quick Login PIN ──────────────────
                        _SectionLabel(label: t.quickLoginPin, primary: primary),
                        const SizedBox(height: 12),

                        _SignupCard(
                          isDark: isDark,
                          child: _FormField(
                            controller: _pinController,
                            label: t.pin,
                            hint: t.pinHint,
                            icon: Icons.dialpad_rounded,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 4,
                            validator: (v) {
                              if (v == null || v.isEmpty) return null;
                              if (v.length != 4) return t.pinMustBeFourDigits;
                              if (!RegExp(r'^\d{4}$').hasMatch(v))
                                return t.pinMustBeNumeric;
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Section: Security Questions ───────────────
                        _SecurityQuestionsSection(
                          state: state,
                          isDark: isDark,
                          primary: primary,
                          answer1Controller: _answer1Controller,
                          answer2Controller: _answer2Controller,
                        ),

                        const SizedBox(height: 28),

                        // ── Terms & Conditions checkbox ───────────────
                        _TermsCheckbox(
                          agreed: state.agreedToTerms,
                          primary: primary,
                          isDark: isDark,
                          onToggle: () => context.read<SignupBloc>().add(
                            SignupToggleTerms(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Sign up button ────────────────────────────
                        AnimatedOpacity(
                          opacity: state.agreedToTerms ? 1.0 : 0.55,
                          duration: const Duration(milliseconds: 200),
                          child: SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _handleSignUp(state, t),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.person_add_rounded,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          t.createAccount,
                                          style: AppTextStyles.labelLarge
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Login link ────────────────────────────────
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t.alreadyHaveAccount,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.55,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  t.login,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Recovery keys dialog ───────────────────────────────────────────────────
  void _showRecoveryKeysDialog(
    BuildContext context,
    List<String> keys,
    AppLocalizations t,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.key_rounded, color: primary, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                t.saveYourRecoveryKeys,
                style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                t.recoveryKeysWarning,
                style: AppTextStyles.bodySmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Keys grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: keys.map((key) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: primary.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      key,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontFamily: 'monospace',
                        color: primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Action buttons
              Row(
                children: [
                  // Copy single
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final singleKey = keys.first;
                        Clipboard.setData(ClipboardData(text: singleKey));
                        AnimatedSnackbar.showSuccess(context, 'Key copied!');
                      },
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: Text(t.copyOne),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: BorderSide(color: primary.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Copy all
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: keys.join('\n')));
                        AnimatedSnackbar.showSuccess(context, t.allKeysCopied);
                      },
                      icon: const Icon(Icons.content_copy_rounded, size: 16),
                      label: Text(t.copyAll),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: BorderSide(color: primary.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    AnimatedSnackbar.showSuccess(context, t.keyCopied);
                    Navigator.pop(context); // back to login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    t.iHaveSavedMyKeys,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SliverAppBar Header
// ─────────────────────────────────────────────────────────────────────────────
class _SignupSliverAppBar extends StatelessWidget {
  final Color primary;
  final bool isDark;

  const _SignupSliverAppBar({required this.primary, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    const expandedHeight = 180.0;
    final collapsedHeight = 64.0 + topPad;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: 64,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (ctx, constraints) {
          final current = constraints.maxHeight;
          final progress =
              ((expandedHeight - current) / (expandedHeight - collapsedHeight))
                  .clamp(0.0, 1.0);
          final expandedOpacity = (1.0 - progress).clamp(0.0, 1.0);
          final collapsedOpacity = ((progress - 0.2) / 0.3).clamp(0.0, 1.0);

          return ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Expanded
                if (expandedOpacity > 0)
                  Opacity(
                    opacity: expandedOpacity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primary, primary.withValues(alpha: 0.82)],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: current,
                        child: OverflowBox(
                          maxHeight: double.infinity,
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              52,
                              topPad + 12,
                              16,
                              0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Create Account',
                                  style: AppTextStyles.h2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Fill in your details to get started',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.72),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Step pills
                                Row(
                                  children: [
                                    _StepPill(
                                      icon: Icons.person_outline_rounded,
                                      label: 'Profile',
                                    ),
                                    const SizedBox(width: 8),
                                    _StepPill(
                                      icon: Icons.lock_outline_rounded,
                                      label: 'Security',
                                    ),
                                    const SizedBox(width: 8),
                                    _StepPill(
                                      icon: Icons.check_circle_outline_rounded,
                                      label: 'Done',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Collapsed
                if (collapsedOpacity > 0)
                  Opacity(
                    opacity: collapsedOpacity,
                    child: Container(
                      color: primary,
                      padding: EdgeInsets.only(top: topPad),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 52, right: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Create Account',
                                style: AppTextStyles.h5.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.person_add_rounded,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Image Picker
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileImagePicker extends StatelessWidget {
  final String? imagePath;
  final Color primary;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _ProfileImagePicker({
    required this.imagePath,
    required this.primary,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: hasImage
                          ? primary.withValues(alpha: 0.5)
                          : primary.withValues(alpha: 0.2),
                      width: 2.5,
                    ),
                    image: hasImage
                        ? DecorationImage(
                            image: FileImage(File(imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasImage
                      ? null
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_rounded,
                              color: primary,
                              size: 28,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t.addPhoto,
                              style: AppTextStyles.captionSmall.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
                // Camera badge
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasImage) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onClear,
              child: Text(
                t.removePhoto,
                style: AppTextStyles.captionSmall.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            t.profilePhotoOptional,
            style: AppTextStyles.captionSmall.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Security Questions Section
// ─────────────────────────────────────────────────────────────────────────────
class _SecurityQuestionsSection extends StatelessWidget {
  final SignupState state;
  final bool isDark;
  final Color primary;
  final TextEditingController answer1Controller;
  final TextEditingController answer2Controller;

  const _SecurityQuestionsSection({
    required this.state,
    required this.isDark,
    required this.primary,
    required this.answer1Controller,
    required this.answer2Controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle row
        _SignupCard(
          isDark: isDark,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.securityQuestions,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        t.extraRecoveryOption,
                        style: AppTextStyles.captionSmall.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: state.securityQuestionsEnabled,
                  activeColor: primary,
                  onChanged: (_) => context.read<SignupBloc>().add(
                    SignupToggleSecurityQuestions(),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable questions panel
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: state.securityQuestionsEnabled
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Info banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
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
                        t.recoveryKeysInfo,
                        style: AppTextStyles.captionSmall.copyWith(
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Question 1
              _SectionLabel(label: t.securityQuestion1, primary: primary),
              const SizedBox(height: 8),
              _SignupCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.selectedSecurityQ1,
                          isExpanded: true,
                          hint: Text(
                            t.selectAQuestion,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          icon: Icon(Icons.expand_more_rounded, color: primary),
                          dropdownColor: isDark
                              ? theme.colorScheme.surface
                              : Colors.white,
                          items: _getSecurityQuestions1(t).map((q) {
                            return DropdownMenuItem(
                              value: q,
                              child: Text(
                                q,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) {
                              context.read<SignupBloc>().add(
                                SignupSecurityQ1Selected(v),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    if (state.selectedSecurityQ1 != null) ...[
                      _Divider(isDark: isDark),
                      _FormField(
                        controller: answer1Controller,
                        label: t.yourAnswer,
                        hint: t.typeYourAnswer,
                        icon: Icons.edit_note_rounded,
                        onChanged: (v) => context.read<SignupBloc>().add(
                          SignupSecurityA1Changed(v),
                        ),
                        validator: state.securityQuestionsEnabled
                            ? (v) => v == null || v.trim().isEmpty
                                  ? t.answerCannotBeEmpty
                                  : null
                            : null,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Question 2
              _SectionLabel(label: t.securityQuestion2, primary: primary),
              const SizedBox(height: 8),
              _SignupCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.selectedSecurityQ2,
                          isExpanded: true,
                          hint: Text(
                            t.selectAQuestion,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          icon: Icon(Icons.expand_more_rounded, color: primary),
                          dropdownColor: isDark
                              ? theme.colorScheme.surface
                              : Colors.white,
                          items: _getSecurityQuestions2(t).map((q) {
                            return DropdownMenuItem(
                              value: q,
                              child: Text(
                                q,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) {
                              context.read<SignupBloc>().add(
                                SignupSecurityQ2Selected(v),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    if (state.selectedSecurityQ2 != null) ...[
                      _Divider(isDark: isDark),
                      _FormField(
                        controller: answer2Controller,
                        label: t.yourAnswer,
                        hint: t.typeYourAnswer,
                        icon: Icons.edit_note_rounded,
                        onChanged: (v) => context.read<SignupBloc>().add(
                          SignupSecurityA2Changed(v),
                        ),
                        validator: state.securityQuestionsEnabled
                            ? (v) => v == null || v.trim().isEmpty
                                  ? t.answerCannotBeEmpty
                                  : null
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Terms Checkbox
// ─────────────────────────────────────────────────────────────────────────────
class _TermsCheckbox extends StatelessWidget {
  final bool agreed;
  final Color primary;
  final bool isDark;
  final VoidCallback onToggle;

  const _TermsCheckbox({
    required this.agreed,
    required this.primary,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: agreed
              ? primary.withValues(alpha: 0.07)
              : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: agreed
                ? primary.withValues(alpha: 0.4)
                : theme.colorScheme.outline.withValues(alpha: 0.15),
            width: agreed ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: agreed ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: agreed
                      ? primary
                      : theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: agreed
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                  children: [
                    TextSpan(text: t.agreeToTerms),
                    TextSpan(
                      text: t.termsAndConditions,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' ${t.and} '),
                    TextSpan(
                      text: t.privacyPolicy,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SignupCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _SignupCard({required this.child, required this.isDark});

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

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

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

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLength,
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
        onChanged: onChanged,
        maxLength: maxLength,
        style: AppTextStyles.bodySmall.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          prefixIcon: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
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

class _StepPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StepPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.overline.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
