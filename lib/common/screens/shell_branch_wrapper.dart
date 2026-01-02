import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/pending_review/pending_review_action_button.dart';

enum NavbarItem { dashboard, activities, agent, profile }

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
      resizeToAvoidBottomInset: true,
      // TODO: fix me
      appBar: AppBar(toolbarHeight: 0),
      body: navigationShell,
      floatingActionButton: const PendingReviewActionButton(),
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
        indicatorColor: AppColors.accent,
        backgroundColor: AppColors.primary,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
          Set<WidgetState> states,
        ) {
          final isSelected = states.contains(WidgetState.selected);
          return isSelected
              ? Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: AppColors.textOnDark)
              : Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.textSecondary,
                );
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(
              size: 35,
              Icons.home_outlined,
              color: AppColors.textSecondary,
            ),
            label: NavbarItem.dashboard.name,
            selectedIcon: const Icon(size: 35, Icons.home),
          ),
          NavigationDestination(
            icon: const Icon(
              size: 35,
              Icons.run_circle_outlined,
              color: AppColors.textSecondary,
            ),
            selectedIcon: const Icon(size: 35, Icons.run_circle),
            label: NavbarItem.activities.name,
          ),
          NavigationDestination(
            icon: const Icon(
              size: 35,
              Icons.support_agent_outlined,
              color: AppColors.textSecondary,
            ),
            selectedIcon: const Icon(size: 35, Icons.support_agent_rounded),
            label: NavbarItem.agent.name,
          ),
          NavigationDestination(
            icon: const Icon(
              size: 35,
              Icons.person_outline,
              color: AppColors.textSecondary,
            ),
            selectedIcon: const Icon(size: 35, Icons.person),
            label: NavbarItem.profile.name,
          ),
        ],
        onDestinationSelected: _onTap,
      ),
    );
  }
}
