import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';

/// A large pulse button for check-in action
class PulseCheckInButton extends StatefulWidget {
  const PulseCheckInButton({
    super.key,
    required this.onPressed,
    required this.statusText,
    required this.status,
    this.size = 200,
    this.isEnabled = true,
  });

  final VoidCallback onPressed;
  final String statusText;
  final SafetyStatus status;
  final double size;
  final bool isEnabled;

  @override
  State<PulseCheckInButton> createState() => _PulseCheckInButtonState();
}

class _PulseCheckInButtonState extends State<PulseCheckInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.status.color;

    return GestureDetector(
      onTap: widget.isEnabled ? widget.onPressed : null,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulse ring
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: widget.size + (_pulseController.value * 30),
                  height: widget.size + (_pulseController.value * 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor.withValues(alpha: 0.1),
                  ),
                );
              },
            ),
            // Middle glow ring
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: widget.size + 10,
                  height: widget.size + 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.3 + (_pulseController.value * 0.2)),
                        blurRadius: 30,
                        spreadRadius: 5 + (_pulseController.value * 10),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Main button
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    statusColor,
                    _darkenColor(statusColor, 0.1),
                  ],
                  stops: const [0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: AppColors.white,
                    size: widget.size * 0.25,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.statusText,
                    style: AppTextStyles.titleMedium(
                      color: AppColors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkerLightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(darkerLightness).toColor();
  }
}

/// Animated builder for pulse effect (simple version)
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

/// Simplified SOS button
class SOSButton extends StatelessWidget {
  const SOSButton({
    super.key,
    required this.onPressed,
    this.size = 80,
  });

  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.criticalColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.criticalColor.withValues(alpha: 0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_rounded,
              color: AppColors.white,
              size: 28,
            ),
            Text(
              'SOS',
              style: AppTextStyles.labelSmall(
                color: AppColors.white,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 800.ms,
        )
        .then()
        .scale(
          begin: const Offset(1.05, 1.05),
          end: const Offset(1, 1),
          duration: 800.ms,
        );
  }
}

/// Fake call trigger button
class FakeCallButton extends StatelessWidget {
  const FakeCallButton({
    super.key,
    required this.onPressed,
    this.size = 60,
  });

  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.grey800,
          border: Border.all(
            color: AppColors.grey600,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.phone_in_talk,
          color: AppColors.white,
          size: 28,
        ),
      ),
    );
  }
}
