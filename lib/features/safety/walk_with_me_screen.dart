import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

class WalkWithMeScreen extends StatefulWidget {
  const WalkWithMeScreen({super.key});
  @override
  State<WalkWithMeScreen> createState() => _WalkWithMeScreenState();
}

class _WalkWithMeScreenState extends State<WalkWithMeScreen> {
  final _destinationController = TextEditingController();
  int _estimatedMinutes = 15;
  bool _isActive = false;
  int _elapsedSeconds = 0;
  Timer? _timer;

  void _startJourney() {
    if (_destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a destination'),
          backgroundColor: AppColors.warningColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() {
      _isActive = true;
      _elapsedSeconds = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  void _endSafely() {
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: AppColors.white, size: 20),
          SizedBox(width: 10),
          Text('Arrived safely!'),
        ]),
        backgroundColor: AppColors.calmColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
    setState(() => _isActive = false);
  }

  void _triggerSOS() {
    _timer?.cancel();
    context.go('/alert');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverdue = _elapsedSeconds > _estimatedMinutes * 60;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Walk With Me'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_isActive) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('End Journey?'),
                  content:
                      const Text('Are you sure you want to end this journey?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _endSafely();
                          Navigator.pop(context);
                        },
                        child: const Text('End')),
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _isActive
          ? _buildActiveJourney(isDark, isOverdue)
          : _buildSetup(isDark),
    );
  }

  Widget _buildSetup(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                      'Share your live location with contacts during a journey.',
                      style: AppTextStyles.bodySmall(
                          color: AppColors.primaryDark))),
            ]),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 28),

          // Destination
          TextFormField(
            controller: _destinationController,
            decoration: const InputDecoration(
              labelText: 'Where are you going?',
              hintText: 'e.g., Home, Office, Gym',
              prefixIcon: Icon(Icons.location_on_outlined, size: 20),
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 24),

          // Estimated time
          Text('ESTIMATED TIME',
              style: AppTextStyles.overline(color: AppColors.grey400)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [10, 15, 30, 45, 60].map((m) {
              final label = m >= 60 ? '${m ~/ 60} hr' : '$m min';
              return GestureDetector(
                onTap: () => setState(() => _estimatedMinutes = m),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _estimatedMinutes == m
                        ? AppColors.primary
                        : (isDark ? AppColors.darkCard : AppColors.white),
                    borderRadius:
                        BorderRadius.circular(AppDesignTokens.radiusFull),
                    border: _estimatedMinutes == m
                        ? null
                        : Border.all(
                            color:
                                isDark ? AppColors.grey700 : AppColors.grey200),
                    boxShadow: _estimatedMinutes == m
                        ? [
                            BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ]
                        : null,
                  ),
                  child: Text(label,
                      style: AppTextStyles.labelMedium(
                          color: _estimatedMinutes == m
                              ? AppColors.white
                              : (isDark
                                  ? AppColors.grey300
                                  : AppColors.grey600),
                          weight: FontWeight.w600)),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 200.ms),

          const Spacer(),

          // Start
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _startJourney,
              icon: const Icon(Icons.directions_walk_rounded, size: 22),
              label: const Text('Start Journey'),
            ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActiveJourney(bool isDark, bool isOverdue) {
    final mins = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    final estSeconds = _estimatedMinutes * 60;
    final progress = (_elapsedSeconds / estSeconds).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Overdue warning
          if (isOverdue)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.criticalBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.criticalLight.withValues(alpha: 0.3)),
              ),
              child: Row(children: [
                const Icon(Icons.warning_rounded,
                    color: AppColors.criticalColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                    child: Text('You\'re past your estimated arrival time!',
                        style: AppTextStyles.bodySmall(
                            color: AppColors.criticalColor,
                            weight: FontWeight.w600))),
              ]),
            ).animate().fadeIn().shake(duration: 500.ms),

          // Destination
          Container(
            padding: const EdgeInsets.all(20),
            decoration: GlassmorphismDecoration.safeCard(context),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.location_on,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Heading to',
                      style: AppTextStyles.bodySmall(color: AppColors.grey400)),
                  Text(_destinationController.text,
                      style: AppTextStyles.titleSmall(
                          color: isDark ? AppColors.white : AppColors.grey900)),
                ],
              )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? AppColors.criticalBackground
                      : AppColors.calmBackground,
                  borderRadius:
                      BorderRadius.circular(AppDesignTokens.radiusFull),
                ),
                child: Text(isOverdue ? 'OVERDUE' : 'ACTIVE',
                    style: AppTextStyles.labelSmall(
                        color: isOverdue
                            ? AppColors.criticalColor
                            : AppColors.calmColor,
                        weight: FontWeight.w700)),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // Timer
          Text('$mins:$secs',
              style: AppTextStyles.countdownTimer(
                  color: isDark ? AppColors.white : AppColors.grey900,
                  fontSize: 56)),
          const SizedBox(height: 8),
          Text('Elapsed • Est. $_estimatedMinutes min',
              style: AppTextStyles.bodySmall(color: AppColors.grey400)),

          const SizedBox(height: 24),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppColors.grey800 : AppColors.grey200,
              color: isOverdue ? AppColors.criticalColor : AppColors.primary,
              minHeight: 6,
            ),
          ),

          const Spacer(),

          // Actions
          Row(children: [
            Expanded(
                child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _endSafely,
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: const Text('Arrived Safe'),
              ),
            )),
            const SizedBox(width: 14),
            SizedBox(
              height: 56,
              width: 56,
              child: ElevatedButton(
                onPressed: _triggerSOS,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.criticalColor,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Icon(Icons.sos_rounded,
                    color: AppColors.white, size: 24),
              ),
            ),
          ]),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
