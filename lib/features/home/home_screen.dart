import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../services/background_timer_service.dart';

/// Home Dashboard Screen — 2026 Premium Design
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _performCheckIn() {
    HapticFeedback.heavyImpact();
    ref.read(backgroundTimerProvider.notifier).recordCheckIn();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.white, size: 16),
            ),
            const SizedBox(width: 12),
            const Text(
              'Check-in recorded! You\'re safe.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: AppColors.calmColor,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(backgroundTimerProvider);
    final timeRemaining = timerState.timeRemaining;
    final isOverdue = timerState.isOverdue;
    final shouldShowWarning = timerState.shouldShowWarning;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SafetyStatus status;
    if (isOverdue) {
      status = SafetyStatus.critical;
    } else if (shouldShowWarning) {
      status = SafetyStatus.warning;
    } else {
      status = SafetyStatus.calm;
    }

    return Scaffold(
      body: _buildBody(status, timeRemaining, isOverdue, isDark),
      bottomNavigationBar: _buildModernNav(isDark),
    );
  }

  Widget _buildBody(
    SafetyStatus status,
    Duration timeRemaining,
    bool isOverdue,
    bool isDark,
  ) {
    if (isOverdue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/alert');
      });
      return const SizedBox.shrink();
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Custom App Bar
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: _buildHeader(isDark),
            ),
          ),
        ),

        // Status Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildStatusCard(status, isDark)
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.15, curve: Curves.easeOutCubic),
          ),
        ),

        // Pulse Button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _buildPulseSection(status, timeRemaining)
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  curve: Curves.easeOutBack,
                ),
          ),
        ),

        // Quick Actions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: _buildQuickActions(isDark)
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.2, curve: Curves.easeOutCubic),
          ),
        ),

        // Recent Activity
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: _buildRecentActivity(isDark)
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.2, curve: Curves.easeOutCubic),
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;
    if (hour < 6) {
      greeting = 'Good Night';
      greetingIcon = Icons.nightlight_round;
    } else if (hour < 12) {
      greeting = 'Good Morning';
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      greetingIcon = Icons.wb_sunny;
    } else {
      greeting = 'Good Evening';
      greetingIcon = Icons.nights_stay_outlined;
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    greetingIcon,
                    size: 16,
                    color: AppColors.grey400,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    greeting,
                    style: AppTextStyles.labelMedium(
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Stay safe today',
                style: AppTextStyles.headlineSmall(
                  color: isDark ? AppColors.white : AppColors.grey900,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Settings button
        _HeaderIconButton(
          icon: Icons.settings_outlined,
          onTap: () => context.push('/settings'),
          isDark: isDark,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1);
  }

  Widget _buildStatusCard(SafetyStatus status, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            status.color.withValues(alpha: isDark ? 0.2 : 0.12),
            status.color.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDesignTokens.radius24),
        border: Border.all(
          color: status.color.withValues(alpha: isDark ? 0.3 : 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              status.icon,
              color: status.color,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status == SafetyStatus.calm
                      ? 'You are Safe'
                      : status == SafetyStatus.warning
                          ? 'Check-in Soon'
                          : 'Check-in Overdue',
                  style: AppTextStyles.titleMedium(
                    color: status.color,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status == SafetyStatus.calm
                      ? 'All systems are good. Keep it up!'
                      : status == SafetyStatus.warning
                          ? 'Your check-in window is closing.'
                          : 'Please check in immediately.',
                  style: AppTextStyles.bodySmall(
                    color: status.color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // Status dot pulse
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: status.color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.2),
                duration: 1500.ms,
              )
              .fade(begin: 0.5, end: 1.0, duration: 1500.ms),
        ],
      ),
    );
  }

  Widget _buildPulseSection(SafetyStatus status, Duration timeRemaining) {
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    final seconds = timeRemaining.inSeconds % 60;

    return Column(
      children: [
        // Check-in button
        Center(
          child: PulseCheckInButton(
            onPressed: _performCheckIn,
            statusText: "I'm Safe",
            status: status,
            size: 190,
          ),
        ),

        const SizedBox(height: 28),

        // Timer display
        Text(
          'NEXT CHECK-IN',
          style: AppTextStyles.overline(
            color: AppColors.grey400,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TimerBlock(value: hours.toString().padLeft(2, '0'), label: 'HRS'),
            _TimerSeparator(),
            _TimerBlock(
                value: minutes.toString().padLeft(2, '0'), label: 'MIN'),
            _TimerSeparator(),
            _TimerBlock(
                value: seconds.toString().padLeft(2, '0'), label: 'SEC'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            'QUICK ACTIONS',
            style: AppTextStyles.overline(
              color: AppColors.grey400,
              weight: FontWeight.w700,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.phone_in_talk_rounded,
                title: 'Fake Call',
                subtitle: 'Emergency exit',
                onTap: () => context.push('/fake-call'),
                gradient: [
                  AppColors.grey800,
                  AppColors.grey900,
                ],
                iconColor: AppColors.white,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.directions_walk_rounded,
                title: 'Walk With Me',
                subtitle: 'Live sharing',
                onTap: () => context.push('/walk-with-me'),
                gradient: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
                iconColor: AppColors.white,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(bool isDark) {
    return Container(
      decoration: GlassmorphismDecoration.safeCard(context),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTextStyles.titleSmall(
                  color: isDark ? AppColors.white : AppColors.grey900,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View All',
                  style: AppTextStyles.labelSmall(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ActivityItem(
            icon: Icons.check_circle_rounded,
            title: 'Check-in recorded',
            time: '2 hours ago',
            color: AppColors.calmColor,
            isDark: isDark,
          ),
          _buildActivityDivider(isDark),
          _ActivityItem(
            icon: Icons.person_add_rounded,
            title: 'Contact added',
            time: 'Yesterday',
            color: AppColors.primary,
            isDark: isDark,
          ),
          _buildActivityDivider(isDark),
          _ActivityItem(
            icon: Icons.tune_rounded,
            title: 'Settings updated',
            time: '2 days ago',
            color: AppColors.grey500,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: isDark
            ? AppColors.grey800.withValues(alpha: 0.5)
            : AppColors.grey100,
      ),
    );
  }

  Widget _buildModernNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.grey800.withValues(alpha: 0.5)
                : AppColors.grey200.withValues(alpha: 0.7),
            width: 0.5,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (index) {
          setState(() => _currentNavIndex = index);
          switch (index) {
            case 0:
              break;
            case 1:
              context.push('/contacts');
              setState(() => _currentNavIndex = 0);
              break;
            case 2:
              context.push('/settings');
              setState(() => _currentNavIndex = 0);
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ─── Private Widgets ────────────────────────────────────────────────

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.grey100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? AppColors.grey800.withValues(alpha: 0.5)
                : AppColors.grey200.withValues(alpha: 0.7),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.grey300 : AppColors.grey600,
        ),
      ),
    );
  }
}

class _TimerBlock extends StatelessWidget {
  final String value;
  final String label;

  const _TimerBlock({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.grey50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? AppColors.grey800.withValues(alpha: 0.5)
                  : AppColors.grey200,
            ),
          ),
          child: Text(
            value,
            style: AppTextStyles.countdownTimer(
              color: isDark ? AppColors.white : AppColors.grey900,
              fontSize: 28,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.overline(
            color: AppColors.grey400,
          ),
        ),
      ],
    );
  }
}

class _TimerSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 6, right: 6),
      child: Text(
        ':',
        style: AppTextStyles.headlineSmall(
          color: AppColors.grey300,
          weight: FontWeight.w300,
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final List<Color> gradient;
  final Color iconColor;
  final bool isDark;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.gradient,
    required this.iconColor,
    required this.isDark,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradient,
            ),
            borderRadius: BorderRadius.circular(AppDesignTokens.radius20),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.first.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 22),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: AppTextStyles.titleSmall(
                  color: AppColors.white,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.subtitle,
                style: AppTextStyles.bodySmall(
                  color: AppColors.white.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final Color color;
  final bool isDark;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium(
              color: isDark ? AppColors.grey200 : AppColors.grey700,
            ),
          ),
        ),
        Text(
          time,
          style: AppTextStyles.bodySmall(color: AppColors.grey400),
        ),
      ],
    );
  }
}
