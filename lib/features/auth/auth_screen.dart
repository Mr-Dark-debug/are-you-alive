import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../services/auth_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authNotifier = ref.read(authServiceProvider.notifier);
    bool success;

    if (_isSignUp) {
      success = await authNotifier.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await authNotifier.signInWithEmail(
        _emailController.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/home');
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    final authNotifier = ref.read(authServiceProvider.notifier);
    final success = await authNotifier.signInWithGoogle();
    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDesignTokens.spacing24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Title
                  Icon(
                    Icons.favorite_rounded,
                    size: 64,
                    color: AppColors.primary,
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.5, 0.5)),

                  const SizedBox(height: AppDesignTokens.spacing16),

                  Text(
                    'Are You Alive',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineMedium(),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: AppDesignTokens.spacing8),

                  Text(
                    'Your safety, our priority',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium(color: AppColors.grey500),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: AppDesignTokens.spacing48),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                  const SizedBox(height: AppDesignTokens.spacing16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),

                  const SizedBox(height: AppDesignTokens.spacing24),

                  // Submit Button
                  PrimaryButton(
                    text: _isSignUp ? 'Sign Up' : 'Sign In',
                    onPressed: _isLoading ? null : _submit,
                    isLoading: _isLoading,
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: AppDesignTokens.spacing16),

                  // Toggle Sign Up/Sign In
                  TextButton(
                    onPressed: () {
                      setState(() => _isSignUp = !_isSignUp);
                    },
                    child: Text(
                      _isSignUp
                          ? 'Already have an account? Sign In'
                          : 'Don\'t have an account? Sign Up',
                      style: AppTextStyles.bodyMedium(color: AppColors.primary),
                    ),
                  ).animate().fadeIn(delay: 700.ms),

                  const SizedBox(height: AppDesignTokens.spacing24),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: AppTextStyles.bodySmall(color: AppColors.grey400),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ).animate().fadeIn(delay: 800.ms),

                  const SizedBox(height: AppDesignTokens.spacing24),

                  // Google Sign In
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text('Continue with Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ).animate().fadeIn(delay: 900.ms),

                  const SizedBox(height: AppDesignTokens.spacing32),

                  // Skip for testing
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: Text(
                      'Skip for now',
                      style: AppTextStyles.bodySmall(color: AppColors.grey400),
                    ),
                  ).animate().fadeIn(delay: 1000.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
