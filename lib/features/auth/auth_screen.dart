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
  bool _obscurePassword = true;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDesignTokens.maxContentWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo area
                    _buildLogoSection(isDark),
                    const SizedBox(height: 48),

                    // Form fields
                    _buildFormFields(isDark),
                    const SizedBox(height: 28),

                    // Submit button
                    PrimaryButton(
                      text: _isSignUp ? 'Create Account' : 'Sign In',
                      onPressed: _isLoading ? null : _submit,
                      isLoading: _isLoading,
                    ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

                    const SizedBox(height: 16),

                    // Toggle mode
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() => _isSignUp = !_isSignUp);
                        },
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodyMedium(
                              color: AppColors.grey500,
                            ),
                            children: [
                              TextSpan(
                                text: _isSignUp
                                    ? 'Already have an account? '
                                    : 'Don\'t have an account? ',
                              ),
                              TextSpan(
                                text: _isSignUp ? 'Sign In' : 'Sign Up',
                                style: AppTextStyles.labelLarge(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

                    const SizedBox(height: 32),

                    // Divider
                    _buildDivider(isDark),
                    const SizedBox(height: 24),

                    // Social buttons
                    _buildSocialButtons(isDark),
                    const SizedBox(height: 32),

                    // Skip button
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/home'),
                        child: Text(
                          'Skip for now',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.grey400,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(bool isDark) {
    return Column(
      children: [
        // Animated heart icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite_rounded,
            size: 40,
            color: AppColors.white,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),

        const SizedBox(height: 24),

        Text(
          'Are You Alive',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineLarge(
            color: isDark ? AppColors.white : AppColors.grey900,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

        const SizedBox(height: 8),

        Text(
          'Your safety, our priority',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge(color: AppColors.grey400),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildFormFields(bool isDark) {
    return Column(
      children: [
        // Email Field
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email address',
            hintText: 'you@example.com',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.grey400,
              size: 20,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@') || !value.contains('.')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

        const SizedBox(height: 16),

        // Password Field
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: '••••••••',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.grey400,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey400,
                size: 20,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
          obscureText: _obscurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: isDark ? AppColors.grey800 : AppColors.grey200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'or continue with',
            style: AppTextStyles.bodySmall(color: AppColors.grey400),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: isDark ? AppColors.grey800 : AppColors.grey200,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }

  Widget _buildSocialButtons(bool isDark) {
    return _SocialButton(
      onPressed: _isLoading ? null : _signInWithGoogle,
      isDark: isDark,
      icon: Icons.g_mobiledata,
      label: 'Continue with Google',
    ).animate().fadeIn(delay: 900.ms, duration: 400.ms);
  }
}

class _SocialButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isDark;
  final IconData icon;
  final String label;

  const _SocialButton({
    required this.onPressed,
    required this.isDark,
    required this.icon,
    required this.label,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed!();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
            border: Border.all(
              color: widget.isDark
                  ? AppColors.grey700.withValues(alpha: 0.5)
                  : AppColors.grey200,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 28, color: AppColors.grey600),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: AppTextStyles.labelLarge(
                  color: widget.isDark ? AppColors.grey200 : AppColors.grey700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
