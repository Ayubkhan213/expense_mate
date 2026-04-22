// lib/features/profile/presentation/faces/edit_profile_face.dart

import 'dart:io';
import 'package:spendio/core/common/custom_snackbar.dart' show AnimatedSnackbar;
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/core/data/models/currency_model.dart';
import 'package:spendio/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:spendio/features/profile/presentation/bloc/profile_event.dart';
import 'package:spendio/features/profile/presentation/bloc/profile_state.dart';
import 'package:spendio/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileFace extends StatefulWidget {
  const EditProfileFace({super.key});

  @override
  State<EditProfileFace> createState() => _EditProfileFaceState();
}

class _EditProfileFaceState extends State<EditProfileFace> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final s = context.read<ProfileBloc>().state;
    _nameController = TextEditingController(text: s.userName ?? '');
    _emailController = TextEditingController(text: s.userEmail ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ── Image picking ─────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (file != null && mounted) {
        context.read<ProfileBloc>().add(UpdateProfileImage(file.path));
      }
    } catch (_) {}
  }

  void _showImageSheet(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final hasImage =
        context.read<ProfileBloc>().state.profileImagePath?.isNotEmpty == true;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
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
              'Update Photo',
              style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _SheetOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    primary: primary,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    primary: primary,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            if (hasImage) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<ProfileBloc>().add(const UpdateProfileImage(''));
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                label: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  void _save(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final s = context.read<ProfileBloc>().state;
    context.read<ProfileBloc>().add(
      UpdateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        profileImagePath: s.profileImagePath,
        currency: s.userCurrency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (ctx, state) {
        if (state.status == ProfileStatus.updated) {
          AnimatedSnackbar.showSuccess(ctx, t.profileUpdatedSuccess);
          // ScaffoldMessenger.of(ctx).showSnackBar(
          //   SnackBar(
          //     content: const Text('Profile updated successfully ✓'),
          //     backgroundColor: Colors.green.shade600,
          //     behavior: SnackBarBehavior.floating,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          // );
          Navigator.pop(ctx, true); // true = caller should reload
        }
        if (state.status == ProfileStatus.error && state.errorMessage != null) {
          AnimatedSnackbar.showError(
            ctx,
            state.errorMessage ?? t.profileUpdateFailed,
          );
          // ScaffoldMessenger.of(ctx).showSnackBar(
          //   SnackBar(
          //     content: Text(state.errorMessage!),
          //     backgroundColor: theme.colorScheme.error,
          //     behavior: SnackBarBehavior.floating,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          // );
        }
      },
      child: Scaffold(
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
          title: Text(
            t.editProfile,
            style: AppTextStyles.h6.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (p, c) => p.status != c.status,
              builder: (ctx, state) {
                final saving = state.status == ProfileStatus.updating;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: saving
                      ? Padding(
                          padding: const EdgeInsets.all(14),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primary,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () => _save(ctx),
                          child: Text(
                            t.save,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // ── Avatar picker ─────────────────────────────────────────
                BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (p, c) => p.profileImagePath != c.profileImagePath,
                  builder: (ctx, state) {
                    final path = state.profileImagePath;
                    final hasImage = path != null && path.isNotEmpty;

                    return GestureDetector(
                      onTap: () => _showImageSheet(ctx),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primary.withValues(alpha: 0.4),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 56,
                              backgroundColor: primary.withValues(alpha: 0.1),
                              backgroundImage: hasImage
                                  ? FileImage(File(path!))
                                  : null,
                              child: hasImage
                                  ? null
                                  : Icon(
                                      Icons.person_rounded,
                                      size: 52,
                                      color: primary.withValues(alpha: 0.7),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
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
                    );
                  },
                ),

                const SizedBox(height: 8),
                Text(
                  t.tapToChangePhoto,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Section label ─────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    t.personalInfo,
                    style: AppTextStyles.overline.copyWith(
                      color: primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Fields card ───────────────────────────────────────────
                _FieldCard(
                  isDark: isDark,
                  children: [
                    _EditField(
                      controller: _nameController,
                      label: t.fullName,
                      hint: t.enterFullName,
                      icon: Icons.person_outline_rounded,
                      primary: primary,
                      textInputAction: TextInputAction.next,
                      validator: (v) => v == null || v.trim().length < 2
                          ? t.fullNameError
                          : null,
                    ),
                    _FieldDivider(isDark: isDark),
                    _EditField(
                      controller: _emailController,
                      label: t.emailAddress,
                      hint: t.emailHint,
                      icon: Icons.email_outlined,
                      primary: primary,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _save(context),
                      validator: (v) =>
                          v == null || !v.contains('@') || !v.contains('.')
                          ? t.enterValidEmail
                          : null,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Currency section ──────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    t.preferredCurrency,
                    style: AppTextStyles.overline.copyWith(
                      color: primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                _FieldCard(
                  isDark: isDark,
                  children: [
                    BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (p, c) => p.userCurrency != c.userCurrency,
                      builder: (ctx, state) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.userCurrency ?? 'USD',
                            isExpanded: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            icon: Icon(Icons.expand_more_rounded, color: primary),
                            dropdownColor: isDark
                                ? theme.colorScheme.surface
                                : Colors.white,
                            items: CurrencyList.currencies.map((c) {
                              return DropdownMenuItem(
                                value: c.code,
                                child: Text(
                                  '${c.flag}  ${c.code} — ${c.name}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) {
                                ctx.read<ProfileBloc>().add(
                                  ProfileCurrencyChanged(v),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Save button ───────────────────────────────────────────
                BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (ctx, state) {
                    final saving = state.status == ProfileStatus.updating;
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: saving ? null : () => _save(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: saving ? 0 : 3,
                          shadowColor: primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: saving
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
                                  const Icon(Icons.check_rounded, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    t.saveChanges,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _FieldCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;
  const _FieldCard({required this.isDark, required this.children});

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
      child: Column(children: children),
    );
  }
}

class _FieldDivider extends StatelessWidget {
  final bool isDark;
  const _FieldDivider({required this.isDark});

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

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color primary;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  const _EditField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.primary,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
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
        textInputAction: textInputAction,
        validator: validator,
        onFieldSubmitted: onSubmitted,
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

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primary;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
