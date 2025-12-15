import 'package:expense_mate/core/app_export.dart';

class MainFrame extends StatelessWidget {
  const MainFrame({super.key});

  final List<Widget> pages = const [
    HomeFace(),
    RecordsFace(),
    AnalyticsFace(),
    ProfileFace(),
  ];
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => NavBloc(),
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          return Scaffold(
            body: pages[state.index],
            floatingActionButton: FloatingActionButton(
              elevation: 8,
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => context.read<NavBloc>().add(ChangeTabEvent(1)),
              child: const Icon(Icons.add, size: 28),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 6,
              elevation: 1,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              child: SizedBox(
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: t.home,
                      isActive: state.index == 0,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(0)),
                    ),
                    _NavItem(
                      icon: Icons.list_alt_rounded,
                      label: t.records,
                      isActive: state.index == 1,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(1)),
                    ),
                    const SizedBox(width: 40), // Space for FAB
                    _NavItem(
                      icon: Icons.bar_chart_rounded,
                      label: t.analytics,
                      isActive: state.index == 2,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(2)),
                    ),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: t.profile,
                      isActive: state.index == 3,
                      onTap: () =>
                          context.read<NavBloc>().add(ChangeTabEvent(3)),
                    ),
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).primaryColor
        : Colors.grey.shade600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
