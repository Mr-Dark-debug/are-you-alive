import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../core/constants/app_constants.dart';

/// Alert Screen - Full screen countdown for grace period
class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen>
    with TickerProviderStateMixin {
  int _countdown = AppConstants.defaultGracePeriodSeconds;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _pulseController;
  late AnimationController _shakeController;

  bool _canVibrate = false;
  bool _alertSent = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _startAlertSequence();
  }

  void _initControllers() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  Future<void> _startAlertSequence() async {
    // Check vibration capability
    _canVibrate = await Vibration.hasVibrator();

    // Start vibration pattern
    if (_canVibrate) {
      _startVibrationPattern();
    }

    // Start countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;

          // Pulse vibration each second
          if (_canVibrate) {
            HapticFeedback.heavyImpact();
          }
        } else {
          _timer?.cancel();
          _triggerEmergencyAlert();
        }
      });
    });
  }

  void _startVibrationPattern() async {
    // Initial long vibration
    Vibration.vibrate();
    await Future.delayed(const Duration(milliseconds: 500));

    // Repeated pulse pattern
    for (int i = 0; i < 3; i++) {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _triggerEmergencyAlert() async {
    if (_alertSent) return;
    _alertSent = true;

    // Stop audio
    await _audioPlayer.stop();

    // Show alert sent confirmation
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.send, color: AppColors.white),
              SizedBox(width: 12),
              Text('Emergency alert sent to your contacts!'),
            ],
          ),
          backgroundColor: AppColors.criticalColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );

      // Navigate to home after a delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go('/home');
      }
    }
  }

  void _cancelAlert() async {
    _timer?.cancel();
    await _audioPlayer.stop();

    if (mounted) {
      // Show cancellation feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.white),
              SizedBox(width: 12),
              Text('Alert cancelled. Timer has been reset.'),
            ],
          ),
          backgroundColor: AppColors.calmColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      context.go('/home');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep screen on and prevent screen capture
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return PopScope(
      canPop: false, // Prevent back button
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.criticalGradientStart,
                AppColors.criticalGradientEnd,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Background pulse animation
                _buildBackgroundPulse(),

                // Main content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDesignTokens.spacing24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Warning Icon
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            size: 80,
                            color: AppColors.white,
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .shake(duration: 500.ms, hz: 4),

                        const SizedBox(height: AppDesignTokens.spacing32),

                        // Title
                        Text(
                          'MISSED CHECK-IN',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineMedium(
                            color: AppColors.white,
                            weight: FontWeight.bold,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: -0.2),

                        const SizedBox(height: AppDesignTokens.spacing8),

                        // Subtitle
                        Text(
                          'Alerting emergency contacts in:',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleMedium(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),

                        const SizedBox(height: AppDesignTokens.spacing40),

                        // Countdown
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            '$_countdown',
                            key: ValueKey(_countdown),
                            style: AppTextStyles.countdownTimer(
                              color: AppColors.white,
                              fontSize: 140,
                            ),
                          ),
                        )
                            .animate(
                              onPlay: (controller) =>
                                  _countdown < 10 ? controller.repeat() : null,
                            )
                            .scale(
                              begin: const Offset(1.05, 1.05),
                              end: const Offset(1, 1),
                              duration: 500.ms,
                            ),

                        const SizedBox(height: AppDesignTokens.spacing8),

                        Text(
                          'seconds',
                          style: AppTextStyles.titleLarge(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),

                        const Spacer(),

                        // Cancel Button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDesignTokens.spacing32,
                          ),
                          child: _SafeButton(
                            onPressed: _cancelAlert,
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),

                        const SizedBox(height: AppDesignTokens.spacing32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundPulse() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.5 + (_pulseController.value * 0.3),
                colors: [
                  AppColors.white.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom animated safe button
class _SafeButton extends StatefulWidget {
  const _SafeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_SafeButton> createState() => _SafeButtonState();
}

class _SafeButtonState extends State<_SafeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDesignTokens.spacing24,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDesignTokens.radius20),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.calmColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDesignTokens.spacing16),
              Text(
                'I AM SAFE',
                style: AppTextStyles.headlineSmall(
                  color: AppColors.calmColor,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated builder for pulse effect
class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
