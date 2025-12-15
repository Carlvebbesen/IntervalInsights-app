import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum NavbarItem { dashboard, activities, agent }

class ScaffoldWithNavbarBottomSheet extends StatelessWidget {
  const ScaffoldWithNavbarBottomSheet(
    this.navigationShell, {
    required this.backgroundColor,
    this.showNavBar = true,
    super.key,
  });
  final StatefulNavigationShell navigationShell;
  final bool showNavBar;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: navigationShell,
      bottomNavigationBar: showNavBar
          ? BottomNavigation(navigationShell: navigationShell)
          : null,
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        labelPadding: EdgeInsets.zero,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
          Set<WidgetState> states,
        ) {
          final isSelected = states.contains(WidgetState.selected);
          final textStyle = isSelected
              ? const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
              : const TextStyle(fontSize: 14);
          return textStyle;
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: NavbarItem.dashboard.name,
          ),
          NavigationDestination(
            icon: const Icon(Icons.run_circle_outlined),
            label: NavbarItem.activities.name,
          ),
          NavigationDestination(
            icon: const Icon(Icons.support_agent_rounded),
            label: NavbarItem.agent.name,
          ),
        ],
        onDestinationSelected: _onTap,
      ),
    );
  }
}
