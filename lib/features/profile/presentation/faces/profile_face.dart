import 'dart:io';
import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/core/theme/typography/app_text_styles.dart';
import 'package:expense_mate/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_mate/features/profile/presentation/bloc/profile_event.dart';
import 'package:expense_mate/features/profile/presentation/bloc/profile_state.dart';
import 'package:expense_mate/features/profile/presentation/faces/daily_notification_face.dart';
import 'package:expense_mate/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:expense_mate/features/profile/presentation/widgets/profile_section_header.dart';

class ProfileFace extends StatelessWidget {
  const ProfileFace({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfile()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
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
              // ── Hero SliverAppBar ──
              _ProfileSliverAppBar(state: state, isDark: isDark),

              // ── Menu content ──
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
                            onChanged: (value) => context.read<ThemeBloc>().add(
                              ToggleDarkModeEvent(value),
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
                      onTap: () => _showEditNameDialog(context, state.userName),
                    ),
                    ProfileMenuItem(
                      icon: Icons.security_outlined,
                      title: t.menuPrivacy,
                      subtitle: t.menuPrivacySubtitle,
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.notifications_outlined,
                      title: t.menuNotifications,
                      subtitle: t.menuNotificationsSubtitle,
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.notifications_active_outlined,
                      title: t.menuDailyNotification,
                      subtitle: t.menuDailyNotificationSubtitle,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DailyNotificationFace(),
                        ),
                      ),
                    ),

                    // ── DATA ──
                    ProfileSectionHeader(title: t.sectionData),
                    ProfileMenuItem(
                      icon: Icons.backup_outlined,
                      title: t.menuBackup,
                      subtitle: t.menuBackupSubtitle,
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.download_outlined,
                      title: t.menuExport,
                      subtitle: t.menuExportSubtitle,
                      onTap: () {},
                    ),

                    // ── SUPPORT ──
                    ProfileSectionHeader(title: t.sectionSupport),
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: t.menuHelp,
                      subtitle: t.menuHelpSubtitle,
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.info_outline,
                      title: t.menuAbout,
                      subtitle: '${t.menuAboutVersion} 1.0.0',
                      onTap: () => _showAboutDialog(context),
                    ),

                    const SizedBox(height: 24),

                    // ── Logout ──
                    BlocListener<AuthBloc, AuthState>(
                      listenWhen: (p, c) => p.status != c.status,
                      listener: (context, authState) {
                        if (authState.status == AuthStatus.unauthenticated) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteName.login,
                            (_) => false,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton.icon(
                          onPressed: () => _showLogoutDialog(context),
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
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Dialogs & sheets ──────────────────────────────────────────────────────

  void _handleImagePick(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                context.read<ProfileBloc>().add(const UpdateProfileImage(''));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, String? currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ProfileBloc>().add(
                  UpdateProfileName(controller.text),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
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

// ─────────────────────────────────────────
// Hero SliverAppBar
// ─────────────────────────────────────────
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
                      onEditImage: () {},
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

// ── Expanded header — centered avatar · name · email ──
class _ExpandedHeader extends StatelessWidget {
  final ProfileState state;
  final Color primary;
  final double topPad;
  final double availableHeight;
  final VoidCallback onEditImage;

  const _ExpandedHeader({
    required this.state,
    required this.primary,
    required this.topPad,
    required this.availableHeight,
    required this.onEditImage,
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
                // ── Top row: settings icon on right ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                  child: Row(
                    children: [
                      const Spacer(),
                      // Edit profile quick-action
                      GestureDetector(
                        onTap: () => _showEditNameDialogDirect(context),
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

                // ── Avatar ──
                GestureDetector(
                  onTap: onEditImage,
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
                      // Camera badge
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

                // ── Name ──
                Text(
                  state.userName ?? 'Guest User',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 4),

                // ── Email ──
                Text(
                  state.userEmail ?? 'email@example.com',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Stats row ──
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
                      _StatItem(label: 'Member since', value: '2024'),
                      _Divider(),
                      _StatItem(label: t.transactions, value: '128'),
                      _Divider(),
                      _StatItem(label: t.budgets, value: '5'),
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

  void _showEditNameDialogDirect(BuildContext context) {
    final controller = TextEditingController(text: state.userName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<ProfileBloc>().add(
                  UpdateProfileName(controller.text),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ── Collapsed header — avatar · name · email in the bar ──
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
            // Small circular avatar
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

            // Name + email stacked
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

            // Edit icon on right
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

// ── Small stat item inside the frosted card ──
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
