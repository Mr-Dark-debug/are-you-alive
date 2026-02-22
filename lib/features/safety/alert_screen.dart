import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../core/constants/app_constants.dart';

/// Alert Screen - Full screen immersive countdown for grace period
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
  late AnimationController _borderController;

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
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  Future<void> _startAlertSequence() async {
    _canVibrate = await Vibration.hasVibrator();

    if (_canVibrate) {
      _startVibrationPattern();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
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
    Vibration.vibrate();
    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < 3; i++) {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _triggerEmergencyAlert() async {
    if (_alertSent) return;
    _alertSent = true;

    await _audioPlayer.stop();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.send_rounded, color: AppColors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Emergency alert sent to your contacts!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.criticalColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.white),
              SizedBox(width: 12),
              Text(
                'Alert cancelled. You\'re safe!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: AppColors.calmColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final progress = _countdown / AppConstants.defaultGracePeriodSeconds;
    final isUrgent = _countdown < 5;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A0000),
                Color(0xFF3D0000),
                Color(0xFF1A0000),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Animated background rings
                _buildBackgroundPulse(),

                // Main content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),

                        // Warning icon with glow
                        _buildWarningIcon(isUrgent),

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          'MISSED CHECK-IN',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.overline(
                            color:
                                AppColors.criticalLight.withValues(alpha: 0.8),
                            weight: FontWeight.w800,
                          ).copyWith(
                            fontSize: 14,
                            letterSpacing: 4,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: -0.2),

                        const SizedBox(height: 12),

                        Text(
                          'Alerting contacts in',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleMedium(
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Countdown with ring
                        _buildCountdownRing(progress, isUrgent),

                        const SizedBox(height: 12),

                        Text(
                          'seconds',
                          style: AppTextStyles.bodyLarge(
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Cancel Button
                        _SafeButton(onPressed: _cancelAlert),

                        const SizedBox(height: 40),
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

  Widget _buildWarningIcon(bool isUrgent) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.criticalColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.criticalColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.criticalColor.withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: const Icon(
        Icons.warning_rounded,
        size: 48,
        color: AppColors.criticalLight,
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shake(duration: 600.ms, hz: 3, delay: 2000.ms);
  }

  Widget _buildCountdownRing(double progress, bool isUrgent) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          // Progress ring
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              color:
                  isUrgent ? AppColors.criticalLight : AppColors.criticalColor,
            ),
          ),
          // Countdown number
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              '$_countdown',
              key: ValueKey(_countdown),
              style: AppTextStyles.countdownTimer(
                color: AppColors.white,
                fontSize: isUrgent ? 80 : 72,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(
          onPlay: (controller) => isUrgent ? controller.repeat() : null,
        )
        .scale(
          begin: isUrgent ? const Offset(1.04, 1.04) : const Offset(1, 1),
          end: const Offset(1, 1),
          duration: 500.ms,
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
                radius: 0.4 + (_pulseController.value * 0.3),
                colors: [
                  AppColors.criticalColor.withValues(alpha: 0.08),
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDesignTokens.radius20),
            boxShadow: [
              BoxShadow(
                color: AppColors.white.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.calmColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'I AM SAFE',
                style: AppTextStyles.headlineSmall(
                  color: AppColors.calmColor,
                  weight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.3, curve: Curves.easeOutCubic);
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
