import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../core/constants/app_constants.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});
  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen>
    with TickerProviderStateMixin {
  int _countdown = AppConstants.defaultGracePeriodSeconds;
  Timer? _timer;
  late AnimationController _pulseCtrl;
  bool _alertSent = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdown > 0) {
        setState(() => _countdown--);
        HapticFeedback.mediumImpact();
      } else {
        _timer?.cancel();
        _sendAlert();
      }
    });
  }

  void _sendAlert() {
    if (_alertSent) return;
    _alertSent = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.send_rounded, color: AppColors.white, size: 20),
          SizedBox(width: 10),
          Expanded(
              child: Text('Emergency alert sent to your contacts!',
                  style: TextStyle(fontWeight: FontWeight.w600))),
        ]),
        backgroundColor: AppColors.criticalColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/home');
    });
  }

  void _cancelAlert() {
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: AppColors.white, size: 20),
          SizedBox(width: 10),
          Text('Alert cancelled.',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: AppColors.calmColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
    context.go('/home');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUrgent = _countdown < 5;
    final progress = _countdown / AppConstants.defaultGracePeriodSeconds;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A0000), Color(0xFF3D0000), Color(0xFF1A0000)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Warning
                  _WarningIcon()
                      .animate(onPlay: (c) => c.repeat())
                      .shake(duration: 600.ms, hz: 3, delay: 2000.ms),
                  const SizedBox(height: 28),

                  // Title
                  Text('MISSED CHECK-IN',
                          style: AppTextStyles.overline(
                                  color: AppColors.criticalLight
                                      .withValues(alpha: 0.8),
                                  weight: FontWeight.w800)
                              .copyWith(fontSize: 13, letterSpacing: 4))
                      .animate()
                      .fadeIn(),
                  const SizedBox(height: 8),
                  Text('Alerting contacts in',
                      style: AppTextStyles.bodyLarge(
                          color: AppColors.white.withValues(alpha: 0.6))),

                  const SizedBox(height: 32),

                  // Countdown ring
                  _CountdownRing(
                    countdown: _countdown,
                    progress: progress,
                    isUrgent: isUrgent,
                  ),
                  const SizedBox(height: 8),
                  Text('seconds',
                      style: AppTextStyles.bodyMedium(
                          color: AppColors.white.withValues(alpha: 0.4))),

                  const Spacer(flex: 2),

                  // Cancel
                  _SafeButton(onPressed: _cancelAlert)
                      .animate()
                      .fadeIn(delay: 300.ms)
                      .slideY(begin: 0.3),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WarningIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.criticalColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
            color: AppColors.criticalColor.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
              color: AppColors.criticalColor.withValues(alpha: 0.2),
              blurRadius: 40,
              spreadRadius: 10)
        ],
      ),
      child: const Icon(Icons.warning_rounded,
          size: 48, color: AppColors.criticalLight),
    );
  }
}

class _CountdownRing extends StatelessWidget {
  final int countdown;
  final double progress;
  final bool isUrgent;
  const _CountdownRing(
      {required this.countdown,
      required this.progress,
      required this.isUrgent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                color: AppColors.white.withValues(alpha: 0.08))),
        SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                color: isUrgent
                    ? AppColors.criticalLight
                    : AppColors.criticalColor)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text('$countdown',
              key: ValueKey(countdown),
              style: AppTextStyles.countdownTimer(
                  color: AppColors.white, fontSize: isUrgent ? 80 : 72)),
        ),
      ]),
    );
  }
}

class _SafeButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _SafeButton({required this.onPressed});
  @override
  State<_SafeButton> createState() => _SafeButtonState();
}

class _SafeButtonState extends State<_SafeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
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
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  color: AppColors.calmColor, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: AppColors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Text('I AM SAFE',
                style: AppTextStyles.headlineSmall(
                    color: AppColors.calmColor, weight: FontWeight.w800)),
          ]),
        ),
      ),
    );
  }
}
