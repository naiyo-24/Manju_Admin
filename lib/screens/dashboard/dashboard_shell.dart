import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../themes/app_theme.dart';

class DashboardShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardShell({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine if we should show a sidebar or bottom nav based on screen width
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              color: AppTheme.backgroundColor,
              child: Column(
                children: [
                  Expanded(
                    child: NavigationRail(
                      selectedIndex: navigationShell.currentIndex,
                      onDestinationSelected: _goBranch,
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.dashboard),
                          label: Text('Overview'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.health_and_safety),
                          label: Text('Doctors'),
                        ),
                        // NavigationRailDestination(
                        //   icon: Icon(Icons.medication),
                        //   label: Text('Medicines'),
                        // ),
                        NavigationRailDestination(
                          icon: Icon(Icons.event_available),
                          label: Text('Appointments'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.science_outlined),
                          label: Text('Lab Bookings'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.biotech),
                          label: Text('Lab Tests'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: AppTheme.pricePink),
                      tooltip: 'Logout',
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: 'Overview',
            ),
            NavigationDestination(
              icon: Icon(Icons.health_and_safety),
              label: 'Doctors',
            ),
            // NavigationDestination(
            //   icon: Icon(Icons.medication),
            //   label: 'Medicines',
            // ),
            NavigationDestination(
              icon: Icon(Icons.event_available),
              label: 'Appointments',
            ),
            NavigationDestination(
              icon: Icon(Icons.science_outlined),
              label: 'Lab Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.biotech),
              label: 'Lab Tests',
            ),
          ],
        ),
      );
    }
  }
}

