import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/yatra_colors.dart';

class PassengerShellScaffold extends StatelessWidget {
  final Widget child;

  const PassengerShellScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/planner')) return 1;
    if (location.startsWith('/tracking')) return 2;
    if (location.startsWith('/assistance')) return 3;
    if (location.startsWith('/stops')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/planner');
        break;
      case 2:
        context.go('/tracking');
        break;
      case 3:
        context.go('/assistance');
        break;
      case 4:
        context.go('/stops');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: YatraColors.surfaceCream,
          border: Border(top: BorderSide(color: YatraColors.softBorder, width: 1.0)),
        ),
        child: NavigationBar(
          backgroundColor: YatraColors.surfaceCream,
          indicatorColor: YatraColors.navyDeep.withOpacity(0.12),
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _onItemTapped(index, context),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: YatraColors.navyDeep),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.alt_route_outlined),
              selectedIcon: Icon(Icons.alt_route, color: YatraColors.navyDeep),
              label: 'Planner',
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_bus_outlined),
              selectedIcon: Icon(Icons.directions_bus, color: YatraColors.navyDeep),
              label: 'Live',
            ),
            NavigationDestination(
              icon: Icon(Icons.sensors_outlined),
              selectedIcon: Icon(Icons.sensors, color: YatraColors.terracotta),
              label: 'Handshake',
            ),
            NavigationDestination(
              icon: Icon(Icons.accessible_forward_outlined),
              selectedIcon: Icon(Icons.accessible_forward, color: YatraColors.heritageGreen),
              label: 'Stops',
            ),
          ],
        ),
      ),
    );
  }
}
