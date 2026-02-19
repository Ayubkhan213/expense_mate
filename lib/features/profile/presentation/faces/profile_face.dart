import 'package:expense_mate/core/app_export.dart';
import 'package:expense_mate/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_mate/features/profile/presentation/bloc/profile_event.dart';
import 'package:expense_mate/features/profile/presentation/bloc/profile_state.dart';
import 'package:expense_mate/features/profile/presentation/faces/daily_notification_face.dart';

import 'package:expense_mate/features/profile/presentation/widgets/profile_header.dart';
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
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    userName: state.userName,
                    userEmail: state.userEmail,
                    imagePath: state.profileImagePath,
                    onEditImage: () => _handleImagePick(context),
                  ),
                  const SizedBox(height: 16),

                  // Appearance Section
                  const ProfileSectionHeader(title: 'APPEARANCE'),
                  ProfileMenuItem(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: 'Customize app appearance',
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.template);
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'Change app language',
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.language);
                    },
                  ),
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      return ProfileMenuItem(
                        icon: themeState.isDark
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: themeState.isDark ? 'Enabled' : 'Disabled',
                        onTap: () {},
                        trailing: Switch(
                          value: themeState.isDark,
                          onChanged: (value) {
                            context.read<ThemeBloc>().add(
                              ToggleDarkModeEvent(value),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Account Section
                  const ProfileSectionHeader(title: 'ACCOUNT'),
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: 'Update your information',
                    onTap: () => _showEditNameDialog(context, state.userName),
                  ),
                  ProfileMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your privacy settings',
                    onTap: () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Configure notification preferences',
                    onTap: () {
                      // TODO: Navigate to notifications
                    },
                  ),

                  // Data Section
                  const ProfileSectionHeader(title: 'DATA'),
                  ProfileMenuItem(
                    icon: Icons.backup_outlined,
                    title: 'Backup & Restore',
                    subtitle: 'Backup your data',
                    onTap: () {
                      // TODO: Navigate to backup
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.download_outlined,
                    title: 'Export Data',
                    subtitle: 'Download your data',
                    onTap: () {
                      // TODO: Export data
                    },
                  ),

                  // Support Section
                  const ProfileSectionHeader(title: 'SUPPORT'),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help with the app',
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  // Add this in the ACCOUNT section
                  ProfileMenuItem(
                    icon: Icons.notifications_active_outlined,
                    title: 'Daily Notification',
                    subtitle: 'Set daily reminder',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DailyNotificationFace(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Logout Button
                  BlocListener<AuthBloc, AuthState>(
                    listenWhen: (p, c) => p.status != c.status,
                    listener: (context, state) {
                      if (state.status == AuthStatus.unauthenticated) {
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
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Log Out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery picker
              },
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
