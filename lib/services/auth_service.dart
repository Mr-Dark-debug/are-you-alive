import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import 'supabase_service.dart';

/// Auth state for the app
enum AuthStatus { uninitialized, authenticated, unauthenticated }

/// Auth state class
class AuthState {
  final AuthStatus status;
  final User? supabaseUser;
  final UserProfile? profile;
  final String? error;

  const AuthState({
    required this.status,
    this.supabaseUser,
    this.profile,
    this.error,
  });

  factory AuthState.uninitialized() =>
      const AuthState(status: AuthStatus.uninitialized);

  factory AuthState.authenticated(User user, {UserProfile? profile}) =>
      AuthState(
        status: AuthStatus.authenticated,
        supabaseUser: user,
        profile: profile,
      );

  factory AuthState.unauthenticated({String? error}) =>
      AuthState(status: AuthStatus.unauthenticated, error: error);

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasProfile => profile != null;
  String get userId => supabaseUser?.id ?? '';
  String get email => supabaseUser?.email ?? '';
  String get name => profile?.name ?? supabaseUser?.userMetadata?['name'] ?? '';
}

/// Authentication service provider
final authServiceProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState.uninitialized()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;

      if (currentUser != null) {
        await _fetchUserProfile(currentUser.id);
      } else {
        state = AuthState.unauthenticated();
      }

      // Listen to auth state changes
      supabase.auth.onAuthStateChange.listen((data) {
        final event = data.event;
        final session = data.session;

        if (event == AuthChangeEvent.signedIn && session != null) {
          _fetchUserProfile(session.user.id);
        } else if (event == AuthChangeEvent.signedOut) {
          state = AuthState.unauthenticated();
        }
      });
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> _fetchUserProfile(String userId) async {
    try {
      final supabaseService = _ref.read(supabaseServiceProvider);
      final profile = await supabaseService.getUserById(userId);

      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;

      if (currentUser != null) {
        if (profile != null) {
          state = AuthState.authenticated(currentUser, profile: profile);
        } else {
          await _createUserProfile(userId);
        }
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  Future<void> _createUserProfile(String userId) async {
    try {
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return;

      final supabaseService = _ref.read(supabaseServiceProvider);
      final profile = await supabaseService.createUserProfile(
        clerkId: userId,
        email: currentUser.email ?? '',
        name: currentUser.userMetadata?['name'] ?? 'User',
      );

      state = AuthState.authenticated(currentUser, profile: profile);
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  /// Sign in with Google OAuth
  Future<bool> signInWithGoogle() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'are-you-alive://auth-callback',
      );
      return true;
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
      return false;
    }
  }

  /// Sign in with email (magic link)
  Future<bool> signInWithEmail(String email) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithOtp(email: email);
      return true;
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _createUserProfile(response.user!.id);
        return true;
      }
      return false;
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _fetchUserProfile(response.user!.id);
        return true;
      }
      return false;
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  /// Update user profile
  Future<void> updateProfile(UserProfile profile) async {
    try {
      final supabase = Supabase.instance.client;
      final supabaseService = _ref.read(supabaseServiceProvider);
      await supabaseService.updateUserProfile(profile);

      final currentUser = supabase.auth.currentUser;
      if (currentUser != null) {
        state = AuthState.authenticated(currentUser, profile: profile);
      }
    } catch (e) {
      // Keep current state but could show error
    }
  }

  /// Check if user has completed onboarding
  bool get hasCompletedOnboarding => state.profile != null;

  /// Get current user ID
  String? get currentUserId => state.supabaseUser?.id;
}

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authServiceProvider);
  return authState.isAuthenticated;
});

/// Provider for current user profile
final userProfileProvider = Provider<UserProfile?>((ref) {
  final authState = ref.watch(authServiceProvider);
  return authState.profile;
});
