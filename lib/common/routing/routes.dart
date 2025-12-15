import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_insights_app/common/screens/activities_screen.dart';
import 'package:interval_insights_app/common/screens/agent_screen.dart';
import 'package:interval_insights_app/common/screens/dashboard_screen.dart';
import 'package:interval_insights_app/common/screens/otp_screen.dart';
import 'package:interval_insights_app/common/screens/sign_in_screen.dart';
import 'package:interval_insights_app/common/screens/splash_screen.dart';
import 'package:interval_insights_app/common/screens/strava_auth_screen.dart';

part 'routes.g.dart';

//NavBar Routes
@TypedGoRoute<DashboardRoute>(path: '/')
class DashboardRoute extends GoRouteData with $DashboardRoute {
  const DashboardRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      key: ValueKey(state.matchedLocation),
      name: "dashboard",
      child: build(context, state),
    );
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DashboardScreen();
  }
}

@TypedGoRoute<ActivitiesRoute>(path: '/activities')
class ActivitiesRoute extends GoRouteData with $ActivitiesRoute {
  const ActivitiesRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      key: ValueKey(state.matchedLocation),
      name: "activities",
      child: build(context, state),
    );
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ActivitiesScreen();
  }
}

@TypedGoRoute<AgentRoute>(path: '/agent')
class AgentRoute extends GoRouteData with $AgentRoute {
  const AgentRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      key: ValueKey(state.matchedLocation),
      name: "agent",
      child: build(context, state),
    );
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AgentScreen();
  }
}

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: ValueKey(state.matchedLocation),
      name: "splash",
      child: build(context, state),
    );
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<SignInRoute>(
  path: '/sign-in',
  routes: [TypedGoRoute<OtpRoute>(path: 'otp')],
)
class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: ValueKey(state.matchedLocation),
      name: "signin",
      child: build(context, state),
    );
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInScreen();
  }
}

class OtpRoute extends GoRouteData with $OtpRoute {
  const OtpRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OtpScreen();
  }
}

@TypedGoRoute<StravaAuthRoute>(path: "/strava-auth")
class StravaAuthRoute extends GoRouteData with $StravaAuthRoute {
  const StravaAuthRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StravaAuthScreen();
  }
}
