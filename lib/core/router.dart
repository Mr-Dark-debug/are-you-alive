import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/home/home_screen.dart';
import '../features/safety/alert_screen.dart';
import '../features/safety/fake_call_screen.dart';
import '../features/safety/walk_with_me_screen.dart';
import '../features/contacts/contacts_screen.dart';
import '../features/settings/settings_screen.dart';
import '../services/local_storage_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/alert',
        name: 'alert',
        builder: (context, state) => const AlertScreen(),
      ),
      GoRoute(
        path: '/contacts',
        name: 'contacts',
        builder: (context, state) => const ContactsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'settings-profile',
            builder: (context, state) => const ProfileSettingsScreen(),
          ),
          GoRoute(
            path: 'medical',
            name: 'settings-medical',
            builder: (context, state) => const MedicalSettingsScreen(),
          ),
          GoRoute(
            path: 'safety',
            name: 'settings-safety',
            builder: (context, state) => const SafetySettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/fake-call',
        name: 'fake-call',
        builder: (context, state) => const FakeCallScreen(),
      ),
      GoRoute(
        path: '/walk-with-me',
        name: 'walk-with-me',
        builder: (context, state) => const WalkWithMeScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
    redirect: (context, state) {
      final hasSeenOnboarding = localStorage.hasSeenOnboarding;
      final path = state.matchedLocation;

      // First time — go to onboarding
      if (!hasSeenOnboarding && path != '/onboarding') {
        return '/onboarding';
      }

      // After onboarding, go to auth (but let auth "skip" to home)
      if (hasSeenOnboarding && path == '/onboarding') {
        return '/auth';
      }

      return null; // no redirect
    },
  );
});

class AppNavigation {
  AppNavigation._();
  static void goToOnboarding(BuildContext context) => context.go('/onboarding');
  static void goToAuth(BuildContext context) => context.go('/auth');
  static void goToHome(BuildContext context) => context.go('/home');
  static void goToAlert(BuildContext context) => context.go('/alert');
  static void goToContacts(BuildContext context) => context.push('/contacts');
  static void goToSettings(BuildContext context) => context.push('/settings');
  static void goToFakeCall(BuildContext context) => context.push('/fake-call');
  static void goToWalkWithMe(BuildContext context) =>
      context.push('/walk-with-me');
}
