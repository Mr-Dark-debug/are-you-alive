import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
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
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authNotifier = ref.read(authServiceProvider.notifier);
      bool success;

      if (_isSignUp) {
        success = await authNotifier.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        success = await authNotifier.signInWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      if (!mounted) return;

      if (success) {
        context.go('/home');
      } else {
        final authState = ref.read(authServiceProvider);
        setState(() {
          _errorMessage =
              authState.error ?? 'Authentication failed. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final authNotifier = ref.read(authServiceProvider.notifier);
    final success = await authNotifier.signInWithGoogle();
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) context.go('/home');
    }
  }

  void _skipToHome() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.white : AppColors.grey900;
    final subtextColor = isDark ? AppColors.grey400 : AppColors.grey500;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),

                    // Logo
                    _buildLogo(isDark).animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(0.7, 0.7),
                        curve: Curves.easeOutBack),
                    const SizedBox(height: 16),
                    Text('Are You Alive',
                            style:
                                AppTextStyles.headlineLarge(color: textColor))
                        .animate()
                        .fadeIn(delay: 200.ms),
                    const SizedBox(height: 6),
                    Text('Your safety, our priority',
                            style:
                                AppTextStyles.bodyMedium(color: subtextColor))
                        .animate()
                        .fadeIn(delay: 300.ms),

                    const SizedBox(height: 40),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.criticalBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.criticalLight
                                  .withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.criticalColor, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(_errorMessage!,
                                    style: AppTextStyles.bodySmall(
                                        color: AppColors.criticalColor))),
                          ],
                        ),
                      ),

                    // Form card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: isDark
                                ? AppColors.grey800.withValues(alpha: 0.5)
                                : AppColors.grey200),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                    color: AppColors.grey300
                                        .withValues(alpha: 0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8)),
                              ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Mode toggle
                          _buildModeToggle(isDark),
                          const SizedBox(height: 24),

                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'you@example.com',
                              prefixIcon: Icon(Icons.email_outlined, size: 20),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Enter your email';
                              }
                              if (!v.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: '••••••••',
                              prefixIcon:
                                  const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Enter your password';
                              }
                              if (v.length < 6) {
                                return 'Min 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Submit
                          SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSubmit,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: AppColors.white))
                                  : Text(
                                      _isSignUp ? 'Create Account' : 'Sign In'),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                height: 1,
                                color: isDark
                                    ? AppColors.grey800
                                    : AppColors.grey200)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('or',
                              style:
                                  AppTextStyles.bodySmall(color: subtextColor)),
                        ),
                        Expanded(
                            child: Container(
                                height: 1,
                                color: isDark
                                    ? AppColors.grey800
                                    : AppColors.grey200)),
                      ],
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 20),

                    // Google
                    SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _handleGoogleSignIn,
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text('Continue with Google'),
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 16),

                    // Skip
                    TextButton(
                      onPressed: _skipToHome,
                      child: Text('Skip for now →',
                          style: AppTextStyles.bodySmall(color: subtextColor)),
                    ).animate().fadeIn(delay: 800.ms),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8)),
        ],
      ),
      child:
          const Icon(Icons.favorite_rounded, color: AppColors.white, size: 40),
    );
  }

  Widget _buildModeToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull),
      ),
      child: Row(
        children: [
          Expanded(
              child: _ModeTab(
            text: 'Sign In',
            isActive: !_isSignUp,
            onTap: () => setState(() => _isSignUp = false),
          )),
          Expanded(
              child: _ModeTab(
            text: 'Sign Up',
            isActive: _isSignUp,
            onTap: () => setState(() => _isSignUp = true),
          )),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  const _ModeTab(
      {required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull),
        ),
        alignment: Alignment.center,
        child: Text(text,
            style: AppTextStyles.labelMedium(
              color: isActive ? AppColors.white : AppColors.grey500,
              weight: FontWeight.w600,
            )),
      ),
    );
  }
}
