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

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),

      // Home / Dashboard
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Alert (Grace Period)
      GoRoute(
        path: '/alert',
        name: 'alert',
        builder: (context, state) => const AlertScreen(),
      ),

      // Contacts
      GoRoute(
        path: '/contacts',
        name: 'contacts',
        builder: (context, state) => const ContactsScreen(),
      ),

      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          // Profile Settings
          GoRoute(
            path: 'profile',
            name: 'settings-profile',
            builder: (context, state) => const ProfileSettingsScreen(),
          ),
          // Medical Settings
          GoRoute(
            path: 'medical',
            name: 'settings-medical',
            builder: (context, state) => const MedicalSettingsScreen(),
          ),
          // Safety Settings
          GoRoute(
            path: 'safety',
            name: 'settings-safety',
            builder: (context, state) => const SafetySettingsScreen(),
          ),
        ],
      ),

      // Female Safety Features
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
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
    redirect: (context, state) {
      final hasSeenOnboarding = localStorage.hasSeenOnboarding;
      final hasCompletedSetup = localStorage.hasCompletedSetup;
      final currentPath = state.matchedLocation;

      // If onboarding not seen, stay on onboarding
      if (!hasSeenOnboarding && currentPath != '/onboarding') {
        return '/onboarding';
      }

      // If onboarding complete but setup not done, go to auth
      if (hasSeenOnboarding && !hasCompletedSetup && currentPath != '/auth') {
        return '/auth';
      }

      // If all setup complete, go to home
      if (hasSeenOnboarding && hasCompletedSetup && currentPath == '/onboarding') {
        return '/home';
      }

      return null;
    },
  );
});

/// Navigation helpers
class AppNavigation {
  AppNavigation._();

  static void goToOnboarding(BuildContext context) {
    context.go('/onboarding');
  }

  static void goToAuth(BuildContext context) {
    context.go('/auth');
  }

  static void goToHome(BuildContext context) {
    context.go('/home');
  }

  static void goToAlert(BuildContext context) {
    context.go('/alert');
  }

  static void goToContacts(BuildContext context) {
    context.push('/contacts');
  }

  static void goToSettings(BuildContext context) {
    context.push('/settings');
  }

  static void goToFakeCall(BuildContext context) {
    context.push('/fake-call');
  }

  static void goToWalkWithMe(BuildContext context) {
    context.push('/walk-with-me');
  }
}
