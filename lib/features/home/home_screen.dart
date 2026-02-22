import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../services/background_timer_service.dart';

/// Home Dashboard Screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;
  int _currentIndex = 0;

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
    // Record check-in
    ref.read(backgroundTimerProvider.notifier).recordCheckIn();

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white),
            SizedBox(width: 12),
            Text('Check-in recorded! Stay safe.'),
          ],
        ),
        backgroundColor: AppColors.calmColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _triggerFakeCall() {
    context.push('/fake-call');
  }

  void _startWalkWithMe() {
    context.push('/walk-with-me');
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(backgroundTimerProvider);
    final timeRemaining = timerState.timeRemaining;
    final isOverdue = timerState.isOverdue;
    final shouldShowWarning = timerState.shouldShowWarning;

    // Determine safety status
    SafetyStatus status;
    if (isOverdue) {
      status = SafetyStatus.critical;
    } else if (shouldShowWarning) {
      status = SafetyStatus.warning;
    } else {
      status = SafetyStatus.calm;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.contacts_outlined),
            onPressed: () => context.push('/contacts'),
            tooltip: 'Contacts',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: _buildBody(status, timeRemaining, isOverdue),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody(SafetyStatus status, Duration timeRemaining, bool isOverdue) {
    if (isOverdue) {
      // Navigate to alert screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/alert');
      });
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesignTokens.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting
            _buildGreeting(),

            const SizedBox(height: AppDesignTokens.spacing24),

            // Status Banner
            StatusBanner(
              status: status,
              title: status == SafetyStatus.calm
                  ? 'You are Safe'
                  : status == SafetyStatus.warning
                      ? 'Check-in Soon'
                      : 'Check-in Overdue',
              subtitle: status == SafetyStatus.calm
                  ? 'Keep checking in regularly'
                  : status == SafetyStatus.warning
                      ? 'Your check-in is due soon'
                      : 'Please check in now',
            ),

            const SizedBox(height: AppDesignTokens.spacing40),

            // Main Check-in Button
            Center(
              child: Column(
                children: [
                  PulseCheckInButton(
                    onPressed: _performCheckIn,
                    statusText: "I'm Safe",
                    status: status,
                    size: 200,
                  ),

                  const SizedBox(height: AppDesignTokens.spacing32),

                  // Countdown Timer
                  Text(
                    'Next check-in in:',
                    style: AppTextStyles.bodyLarge(color: AppColors.grey500),
                  ),
                  const SizedBox(height: AppDesignTokens.spacing8),
                  CountdownTimerWidget(
                    duration: timeRemaining,
                    color: status.color,
                    fontSize: 48,
                    showLabels: true,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

            const SizedBox(height: AppDesignTokens.spacing40),

            // Quick Actions
            _buildQuickActions(),

            const SizedBox(height: AppDesignTokens.spacing24),

            // Recent Activity Card
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTextStyles.titleMedium(color: AppColors.grey500),
        ),
        const SizedBox(height: 4),
        Text(
          'Stay safe today',
          style: AppTextStyles.headlineSmall(),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.titleSmall(),
        ),
        const SizedBox(height: AppDesignTokens.spacing16),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.phone_in_talk,
                title: 'Fake Call',
                subtitle: 'Trigger emergency call',
                onTap: _triggerFakeCall,
                color: AppColors.grey800,
              ),
            ),
            const SizedBox(width: AppDesignTokens.spacing16),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.directions_walk,
                title: 'Walk With Me',
                subtitle: 'Share location',
                onTap: _startWalkWithMe,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildRecentActivity() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTextStyles.titleSmall(),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppDesignTokens.spacing16),
          _ActivityItem(
            icon: Icons.check_circle,
            title: 'Check-in recorded',
            time: '2 hours ago',
            color: AppColors.calmColor,
          ),
          const Divider(height: 24),
          _ActivityItem(
            icon: Icons.person_add,
            title: 'Contact added',
            time: 'Yesterday',
            color: AppColors.primary,
          ),
          const Divider(height: 24),
          _ActivityItem(
            icon: Icons.settings,
            title: 'Settings updated',
            time: '2 days ago',
            color: AppColors.grey500,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              break; // Already on home
            case 1:
              context.push('/contacts');
              break;
            case 2:
              context.push('/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_outlined),
            activeIcon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDesignTokens.spacing16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
            const SizedBox(height: AppDesignTokens.spacing12),
            Text(
              title,
              style: AppTextStyles.titleSmall(),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall(color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: AppDesignTokens.spacing12),
        Expanded(
          child: Text(title, style: AppTextStyles.bodyMedium()),
        ),
        Text(
          time,
          style: AppTextStyles.bodySmall(color: AppColors.grey500),
        ),
      ],
    );
  }
}
