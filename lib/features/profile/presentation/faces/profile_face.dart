// lib/features/profile/presentation/faces/profile_face.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/common/custom_snackbar.dart';
import 'package:spendio/core/database/sqflite_helper.dart';
import 'package:spendio/core/navigation/route_name.dart';
import 'package:spendio/core/theme/bloc/theme_bloc.dart';
import 'package:spendio/core/theme/bloc/theme_event.dart';
import 'package:spendio/core/theme/bloc/theme_state.dart';

import 'package:spendio/core/theme/typography/app_text_styles.dart';

import 'package:spendio/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:spendio/features/profile/presentation/bloc/profile_event.dart';
import 'package:spendio/features/profile/presentation/bloc/profile_state.dart';
import 'package:spendio/features/profile/presentation/faces/daily_notification_face.dart';
import 'package:spendio/features/profile/presentation/faces/edit_profile_face.dart';
import 'package:spendio/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:spendio/features/profile/presentation/widgets/profile_section_header.dart';
import 'package:spendio/features/splah/presentation/bloc/splash_bloc.dart';
import 'package:spendio/features/splah/presentation/bloc/splash_event.dart';
import 'package:spendio/features/splah/presentation/bloc/splash_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spendio/l10n/app_localizations.dart';

class ProfileFace extends StatelessWidget {
  const ProfileFace({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;

    // Listen to the SINGLETON SplashBloc for logout navigation
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (ctx, state) {
        if (state.status == SplashStatus.unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(ctx, RouteName.login, (_) => false);
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? theme.colorScheme.background
            : const Color(0xFFF2F4F8),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                  strokeWidth: 2.5,
                ),
              );
            }

            return CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                _ProfileSliverAppBar(state: state, isDark: isDark),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── APPEARANCE ──
                      ProfileSectionHeader(title: t.sectionAppearance),
                      ProfileMenuItem(
                        icon: Icons.palette_outlined,
                        title: t.menuTheme,
                        subtitle: t.menuThemeSubtitle,
                        onTap: () =>
                            Navigator.pushNamed(context, RouteName.template),
                      ),
                      ProfileMenuItem(
                        icon: Icons.language_outlined,
                        title: t.menuLanguage,
                        subtitle: t.menuLanguageSubtitle,
                        onTap: () =>
                            Navigator.pushNamed(context, RouteName.language),
                      ),
                      BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, themeState) {
                          return ProfileMenuItem(
                            icon: themeState.isDark
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            title: t.menuDarkMode,
                            subtitle: themeState.isDark
                                ? t.menuDarkModeEnabled
                                : t.menuDarkModeDisabled,
                            onTap: () {},
                            trailing: Switch(
                              value: themeState.isDark,
                              onChanged: (v) => context.read<ThemeBloc>().add(
                                ToggleDarkModeEvent(v),
                              ),
                            ),
                          );
                        },
                      ),

                      // ── ACCOUNT ──
                      ProfileSectionHeader(title: t.sectionAccount),
                      ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: t.menuEditProfile,
                        subtitle: t.menuEditProfileSubtitle,
                        onTap: () => _navigateToEditProfile(context),
                      ),
                      ProfileMenuItem(
                        icon: Icons.security_outlined,
                        title: t.menuPrivacy,
                        subtitle: t.menuPrivacySubtitle,
                        onTap: () => _showPrivacySheet(context, t), // ← add
                      ),
                      // ProfileMenuItem(
                      //   icon: Icons.notifications_outlined,
                      //   title: t.menuNotifications,
                      //   subtitle: t.menuNotificationsSubtitle,
                      //   onTap: () {},
                      // ),
                      // ProfileMenuItem(
                      //   icon: Icons.notifications_active_outlined,
                      //   title: t.menuDailyNotification,
                      //   subtitle: t.menuDailyNotificationSubtitle,
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) => const DailyNotificationFace(),
                      //     ),
                      //   ),
                      // ),

                      // ── DATA ──
                      // ProfileMenuItem(
                      //   icon: Icons.backup_outlined,
                      //   title: t.menuBackup,
                      //   subtitle: t.menuBackupSubtitle,
                      //   onTap: () => _handleBackup(context, t), // ← add
                      // ),
                      // ProfileMenuItem(
                      //   icon: Icons.download_outlined,
                      //   title: t.menuExport,
                      //   subtitle: t.menuExportSubtitle,
                      //   onTap: () => _handleExport(context), // ← add
                      // ),

                      // ── SUPPORT ──
                      ProfileSectionHeader(title: t.sectionSupport),
                      ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: t.menuHelp,
                        subtitle: t.menuHelpSubtitle,
                        onTap: () => _showHelpSheet(context), // ← add
                      ),
                      ProfileMenuItem(
                        icon: Icons.info_outline,
                        title: t.menuAbout,
                        subtitle: '${t.menuAboutVersion} 1.0.0',
                        onTap: () => _showAboutDialog(context),
                      ),

                      const SizedBox(height: 24),

                      // ── Logout ─────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton.icon(
                          onPressed: () => _showLogoutDialog(context, t),
                          icon: const Icon(Icons.logout),
                          label: Text(t.btnLogout),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Navigate to EditProfileFace sharing the same ProfileBloc ─────────────

  void _navigateToEditProfile(BuildContext context) async {
    final bloc = context.read<ProfileBloc>();
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: bloc, child: const EditProfileFace()),
      ),
    );
    // Reload from Hive to show updated name/email/image in the header
    if (updated == true && context.mounted) {
      bloc.add(LoadProfile());
    }
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.logout),
        content: Text(t.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Uses singleton SplashBloc — clears AppPrefs + Hive
              context.read<SplashBloc>().add(SplashLogout());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(t.logout, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Expense Mate',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.account_balance_wallet, size: 48),
      children: [const Text('A professional expense tracking application')],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero SliverAppBar
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileSliverAppBar extends StatelessWidget {
  final ProfileState state;
  final bool isDark;
  const _ProfileSliverAppBar({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final topPad = MediaQuery.of(context).padding.top;
    final collapsedHeight = 64.0 + topPad;
    const expandedHeight = 340.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: 64,
      pinned: true,
      stretch: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final current = constraints.maxHeight;
          final progress =
              ((expandedHeight - current) / (expandedHeight - collapsedHeight))
                  .clamp(0.0, 1.0);
          final expandedOpacity = (1.0 - progress).clamp(0.0, 1.0);
          final collapsedOpacity = ((progress - 0.20) / 0.30).clamp(0.0, 1.0);

          return ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (expandedOpacity > 0)
                  Opacity(
                    opacity: expandedOpacity,
                    child: _ExpandedHeader(
                      state: state,
                      primary: primary,
                      topPad: topPad,
                      availableHeight: current,
                    ),
                  ),
                if (collapsedOpacity > 0)
                  Opacity(
                    opacity: collapsedOpacity,
                    child: _CollapsedHeader(
                      state: state,
                      primary: primary,
                      topPad: topPad,
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

// ── Expanded header ──────────────────────────────────────────────────────────

class _ExpandedHeader extends StatelessWidget {
  final ProfileState state;
  final Color primary;
  final double topPad;
  final double availableHeight;

  const _ExpandedHeader({
    required this.state,
    required this.primary,
    required this.topPad,
    required this.availableHeight,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withValues(alpha: 0.82)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        height: availableHeight,
        child: OverflowBox(
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: topPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                  child: Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _navigateToEditFromHeader(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Avatar
                GestureDetector(
                  onTap: () => _navigateToEditFromHeader(context),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                            width: 3.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.22),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          backgroundImage:
                              state.profileImagePath != null &&
                                  state.profileImagePath!.isNotEmpty
                              ? FileImage(File(state.profileImagePath!))
                              : null,
                          child:
                              state.profileImagePath == null ||
                                  state.profileImagePath!.isEmpty
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 52,
                                  color: Colors.white.withValues(alpha: 0.9),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Name — reads from ProfileBloc state (updated immediately)
                Text(
                  state.userName ?? 'Guest User',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 4),

                // Email
                Text(
                  state.userEmail ?? 'email@example.com',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        label: t.memberSince,
                        value: state.memberSince.isEmpty
                            ? '—'
                            : state.memberSince, // ← real
                      ),
                      _Divider(),
                      _StatItem(
                        label: t.transactions,
                        value: '${state.totalTransactions}', // ← real
                      ),
                      _Divider(),
                      _StatItem(
                        label: t.budgets,
                        value: '${state.totalBudgets}', // ← real
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEditFromHeader(BuildContext context) async {
    final bloc = context.read<ProfileBloc>();
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: bloc, child: const EditProfileFace()),
      ),
    );
    if (updated == true && context.mounted) {
      bloc.add(LoadProfile());
    }
  }
}

// ── Collapsed header ─────────────────────────────────────────────────────────

class _CollapsedHeader extends StatelessWidget {
  final ProfileState state;
  final Color primary;
  final double topPad;

  const _CollapsedHeader({
    required this.state,
    required this.primary,
    required this.topPad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      padding: EdgeInsets.only(top: topPad),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.7),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                backgroundImage:
                    state.profileImagePath != null &&
                        state.profileImagePath!.isNotEmpty
                    ? FileImage(File(state.profileImagePath!))
                    : null,
                child:
                    state.profileImagePath == null ||
                        state.profileImagePath!.isEmpty
                    ? Icon(
                        Icons.person_rounded,
                        size: 20,
                        color: Colors.white.withValues(alpha: 0.9),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.userName ?? 'Guest User',
                    style: AppTextStyles.h6.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    state.userEmail ?? 'email@example.com',
                    style: AppTextStyles.captionSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h5.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.overline.copyWith(
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}

void _showPrivacySheet(BuildContext context, AppLocalizations t) {
  final theme = Theme.of(context);
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.security_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                'Privacy & Security',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _PrivacyRow(
            icon: Icons.lock_outline,
            label: 'Data Storage',
            value: 'Local only — never uploaded',
          ),
          _PrivacyRow(
            icon: Icons.cloud_off_outlined,
            label: 'Cloud Sync',
            value: 'Disabled — fully offline',
          ),
          _PrivacyRow(
            icon: Icons.fingerprint,
            label: 'Biometric',
            value: 'Protected by device security',
          ),
          _PrivacyRow(
            icon: Icons.pin_outlined,
            label: 'PIN Lock',
            value: 'Encrypted hash stored',
          ),
          _PrivacyRow(
            icon: Icons.delete_outline,
            label: 'Data Deletion',
            value: 'Logout clears all sessions',
          ),
        ],
      ),
    ),
  );
}

class _PrivacyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PrivacyRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// void _handleBackup(BuildContext context, AppLocalizations t) async {
//   final theme = Theme.of(context);

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => const Center(child: CircularProgressIndicator()),
//   );

//   try {
//     final path = await SqliteHelper.instance.exportDatabaseToDownloads();
//     if (context.mounted) Navigator.pop(context); // close loader

//     if (path != null && context.mounted) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               Icon(Icons.check_circle_outline, color: Colors.green),
//               const SizedBox(width: 10),
//               const Text('Backup Successful'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Your data has been exported to:'),
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.surface,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   path,
//                   style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Done'),
//             ),
//           ],
//         ),
//       );
//     } else if (context.mounted) {
//       AnimatedSnackbar.showError(context, 'Backup failed — permission denied');
//     }
//   } catch (e) {
//     if (context.mounted) {
//       Navigator.pop(context);
//       AnimatedSnackbar.showError(context, 'Backup failed: $e');
//     }
//   }
// }

// void _handleExport(BuildContext context) async {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => const Center(child: CircularProgressIndicator()),
//   );

//   try {
//     final db = await SqliteHelper.instance.database;

//     // Fetch all transactions with category key
//     final rows = await db.rawQuery('''
//       SELECT t.amount, t.type, t.category_key, t.note, t.payment_method, t.created_at
//       FROM transactions t
//       ORDER BY t.created_at DESC
//     ''');

//     // Build CSV
//     final buffer = StringBuffer();
//     buffer.writeln('Date,Type,Category,Amount,Payment Method,Note');
//     for (final row in rows) {
//       final date = row['created_at'].toString().split('T').first;
//       final type = row['type'];
//       final category = row['category_key'] ?? '';
//       final amount = row['amount'];
//       final method = row['payment_method'] ?? '';
//       final note = (row['note'] ?? '').toString().replaceAll(',', ';');
//       buffer.writeln('$date,$type,$category,$amount,$method,$note');
//     }

//     // Save to temp dir and share
//     final dir = await getTemporaryDirectory();
//     final fileName = 'spendio_${DateTime.now().millisecondsSinceEpoch}.csv';
//     final file = File('${dir.path}/$fileName');
//     await file.writeAsString(buffer.toString());

//     if (context.mounted) Navigator.pop(context); // close loader

//     await Share.shareXFiles([
//       XFile(file.path),
//     ], subject: 'Expense Mate — Transaction Export');
//   } catch (e) {
//     if (context.mounted) {
//       Navigator.pop(context);
//       AnimatedSnackbar.showError(context, 'Export failed: $e');
//     }
//   }
// }

void _showHelpSheet(BuildContext context) {
  final theme = Theme.of(context);
  final faqs = [
    (
      'How do I add a transaction?',
      'Tap any category on the home screen to open the calculator and log your expense or income.',
    ),
    (
      'How do I set a budget?',
      'Go to the Budgets tab and tap the + button to create a monthly, project, or custom budget.',
    ),
    (
      'How do I track debts?',
      'On the home screen, select a category and toggle the Debt switch to mark it as borrowed or lent.',
    ),
    (
      'Is my data safe?',
      'All data is stored locally on your device. Nothing is sent to any server.',
    ),
    (
      'How do I backup my data?',
      'Go to Profile → Backup to export your database to your Downloads folder.',
    ),
    (
      'How do I change the currency?',
      'Currency is set during signup. Contact support to reset it.',
    ),
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.help_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  'Help & FAQ',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                controller: controller,
                itemCount: faqs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 12),
                  title: Text(
                    faqs[i].$1,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Text(
                      faqs[i].$2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
