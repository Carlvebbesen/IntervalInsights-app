import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_insights_app/common/controllers/auth_controller.dart';
import 'package:interval_insights_app/common/screens/shell_branch_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'routes.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final signinRoutes = [
  const SignInRoute().location,
  const OtpRoute().location,
  const SplashRoute().location,
  const StravaAuthRoute().location,
];

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: const SplashRoute().location,
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError || !authState.hasValue) {
        print("authState is loading");
        return const SplashRoute().location;
      }
      if (authState.unwrapPrevious().hasError) {
        print("Error occurred with authController");
        return const SignInRoute().location;
      }
      return switch (authState.requireValue) {
        Unauthenticated() => const SignInRoute().location,
        VerifyOtpCode() => const OtpRoute().location,
        StravaAuth() => const StravaAuthRoute().location,
        Authenticated() =>
          signinRoutes.contains(state.uri.path)
              ? const DashboardRoute().location
              : null,
      };
    },
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return the widget that implements the custom shell (e.g a BottomNavigationBar).
          // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
          return ScaffoldWithNavbarBottomSheet(
            navigationShell,
            showNavBar: true,
            backgroundColor: Colors.white,
          );
        },
        branches: [
          StatefulShellBranch(routes: <RouteBase>[$dashboardRoute]),
          StatefulShellBranch(routes: <RouteBase>[$activitiesRoute]),
          StatefulShellBranch(routes: <RouteBase>[$agentRoute]),
          StatefulShellBranch(routes: <RouteBase>[$profileRoute]),
        ],
      ),
      $signInRoute,
      $stravaAuthRoute,
      $splashRoute,
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Text(
        "GoRouter errorPage, location: ${state.matchedLocation} and Error: ${state.error?.message}",
      ),
    ),
  );
  ref.onDispose(() {
    print("Disposing goRouter provider");
    return router.dispose();
  }); // always clean up after yourselves (:
  return router;
}
