import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/intro/presentation/intro_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/planner/presentation/planner_screen.dart';
import '../../features/tracking/presentation/tracking_screen.dart';
import '../../features/assistance/presentation/assistance_screen.dart';
import '../../features/stops/presentation/accessible_stops_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/shell/passenger_shell_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Introduction & Onboarding
      GoRoute(
        path: '/',
        builder: (context, state) => const IntroScreen(),
      ),

      // Shell with Persistent Bottom Navigation Bar
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => PassengerShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const PassengerHomeScreen(),
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const JourneyPlannerScreen(),
          ),
          GoRoute(
            path: '/tracking',
            builder: (context, state) => const LiveTrackingScreen(),
          ),
          GoRoute(
            path: '/assistance',
            builder: (context, state) => const AssistanceScreen(),
          ),
          GoRoute(
            path: '/stops',
            builder: (context, state) => const AccessibleStopsScreen(),
          ),
        ],
      ),

      // Full-screen Modals & Utility Views
      GoRoute(
        path: '/history',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TripHistoryScreen(),
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
