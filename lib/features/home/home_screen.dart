import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../services/background_timer_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _timer;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _doCheckIn() {
    HapticFeedback.heavyImpact();
    ref.read(backgroundTimerProvider.notifier).recordCheckIn();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: AppColors.white, size: 20),
          SizedBox(width: 10),
          Text('Check-in recorded!',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: AppColors.calmColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(backgroundTimerProvider);
    final remaining = timerState.timeRemaining;
    final isOverdue = timerState.isOverdue;
    final isWarning = timerState.shouldShowWarning;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isOverdue) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/alert'));
      return const SizedBox.shrink();
    }

    final status = isWarning ? SafetyStatus.warning : SafetyStatus.calm;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(isDark).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 20),

              // Greeting card (pastel pink like reference)
              _buildGreetingCard(isDark, status)
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOutCubic),
              const SizedBox(height: 20),

              // SOS Card (from reference — bold red/orange)
              _buildSOSCard(isDark, remaining)
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 500.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOutCubic),
              const SizedBox(height: 20),

              // Quick actions row
              _buildQuickActionsRow(isDark)
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOutCubic),
              const SizedBox(height: 20),

              // Activity
              _buildRecentActivity(isDark)
                  .animate()
                  .fadeIn(delay: 650.ms, duration: 500.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOutCubic),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  // ─── HEADER ─────────────────────────────────────────────────────
  Widget _buildHeader(bool isDark) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentDark]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.person, color: AppColors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting,
                    style: AppTextStyles.bodySmall(color: AppColors.grey400)),
                Text('Hello, Pearl 👋',
                    style: AppTextStyles.titleMedium(
                        color: isDark ? AppColors.white : AppColors.grey900,
                        weight: FontWeight.w700)),
              ],
            ),
          ),
          // Notification bell
          _HeaderBtn(
              icon: Icons.notifications_outlined, isDark: isDark, onTap: () {}),
          const SizedBox(width: 10),
          _HeaderBtn(
              icon: Icons.settings_outlined,
              isDark: isDark,
              onTap: () => context.push('/settings')),
        ],
      ),
    );
  }

  // ─── GREETING CARD (pastel pink like reference) ─────────────────
  Widget _buildGreetingCard(bool isDark, SafetyStatus status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1C2333), const Color(0xFF1A2535)]
                : [const Color(0xFFFCE7F3), const Color(0xFFFDF2F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: isDark
              ? Border.all(color: AppColors.grey800.withValues(alpha: 0.5))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Smiley (like reference)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.accent.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text('😊', style: TextStyle(fontSize: 28))),
            ),
            const SizedBox(height: 16),
            Text('How do you\nfeel today?',
                style: AppTextStyles.headlineSmall(
                    color: isDark ? AppColors.white : AppColors.grey900,
                    weight: FontWeight.w700)),
            const SizedBox(height: 12),
            // Pill buttons (like reference)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PillButton(
                    label: '😃 Safe',
                    isSelected: status == SafetyStatus.calm,
                    onTap: _doCheckIn),
                _PillButton(
                    label: '😰 Anxious', isSelected: false, onTap: () {}),
                _PillButton(label: '😴 Tired', isSelected: false, onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── SOS CARD (bold, from reference) ─────────────────────────────
  Widget _buildSOSCard(bool isDark, Duration remaining) {
    final h = remaining.inHours.toString().padLeft(2, '0');
    final m = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
              color: isDark
                  ? AppColors.grey800.withValues(alpha: 0.5)
                  : AppColors.grey200),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                      color: AppColors.grey300.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8)),
                ],
        ),
        child: Column(
          children: [
            // SOS Box (like reference image — red/orange)
            GestureDetector(
              onTap: _doCheckIn,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEA580C), Color(0xFFDC2626)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.sosOrange.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: Column(
                  children: [
                    Text('$h:$m:$s',
                        style: AppTextStyles.countdownTimer(
                            color: AppColors.white, fontSize: 48)),
                    const SizedBox(height: 4),
                    Text('TAP TO CHECK IN',
                        style: AppTextStyles.overline(
                                color: AppColors.white.withValues(alpha: 0.8))
                            .copyWith(letterSpacing: 3)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lower row
            Row(
              children: [
                Expanded(
                    child: _ActionChip(
                  icon: Icons.emergency,
                  label: 'Emergency',
                  color: AppColors.criticalColor,
                  onTap: () => context.go('/alert'),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _ActionChip(
                  icon: Icons.phone_in_talk,
                  label: 'Fake Call',
                  color: AppColors.grey600,
                  onTap: () => context.push('/fake-call'),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── QUICK ACTIONS ROW ───────────────────────────────────────────
  Widget _buildQuickActionsRow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
              child: _QuickCard(
            icon: Icons.directions_walk_rounded,
            title: 'Walk With Me',
            subtitle: 'Live sharing',
            gradient: [AppColors.primary, AppColors.primaryDark],
            onTap: () => context.push('/walk-with-me'),
          )),
          const SizedBox(width: 14),
          Expanded(
              child: _QuickCard(
            icon: Icons.people_rounded,
            title: 'Contacts',
            subtitle: 'Emergency list',
            gradient: [AppColors.blue, const Color(0xFF1D4ED8)],
            onTap: () => context.push('/contacts'),
          )),
        ],
      ),
    );
  }

  // ─── RECENT ACTIVITY ─────────────────────────────────────────────
  Widget _buildRecentActivity(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: GlassmorphismDecoration.safeCard(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activity',
                style: AppTextStyles.titleSmall(
                    color: isDark ? AppColors.white : AppColors.grey900)),
            const SizedBox(height: 16),
            _ActivityRow(
                icon: Icons.check_circle_rounded,
                title: 'Check-in recorded',
                time: '2 hours ago',
                color: AppColors.calmColor,
                isDark: isDark),
            Divider(
                color: isDark ? AppColors.grey800 : AppColors.grey100,
                height: 24),
            _ActivityRow(
                icon: Icons.person_add_rounded,
                title: 'Contact added',
                time: 'Yesterday',
                color: AppColors.blue,
                isDark: isDark),
            Divider(
                color: isDark ? AppColors.grey800 : AppColors.grey100,
                height: 24),
            _ActivityRow(
                icon: Icons.tune_rounded,
                title: 'Settings updated',
                time: '2 days ago',
                color: AppColors.grey500,
                isDark: isDark),
          ],
        ),
      ),
    );
  }

  // ─── BOTTOM NAV ──────────────────────────────────────────────────
  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: isDark
                    ? AppColors.grey800.withValues(alpha: 0.5)
                    : AppColors.grey200,
                width: 0.5)),
      ),
      child: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) {
          setState(() => _navIndex = i);
          switch (i) {
            case 1:
              context.push('/contacts');
              setState(() => _navIndex = 0);
            case 2:
              context.push('/settings');
              setState(() => _navIndex = 0);
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.people_outline_rounded),
              selectedIcon: Icon(Icons.people_rounded),
              label: 'Contacts'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings'),
        ],
      ),
    );
  }
}

// ─── SUB-WIDGETS ──────────────────────────────────────────────────

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _HeaderBtn(
      {required this.icon, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.grey100,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
              color: isDark
                  ? AppColors.grey800.withValues(alpha: 0.5)
                  : AppColors.grey200),
        ),
        child: Icon(icon,
            size: 20, color: isDark ? AppColors.grey300 : AppColors.grey600),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _PillButton(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary : AppColors.primary)
              : (isDark ? AppColors.darkCard : AppColors.white),
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusFull),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? AppColors.grey700 : AppColors.grey200),
        ),
        child: Text(label,
            style: AppTextStyles.labelMedium(
              color: isSelected
                  ? AppColors.white
                  : (isDark ? AppColors.grey300 : AppColors.grey600),
              weight: FontWeight.w600,
            )),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionChip(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardAlt : AppColors.grey50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark
                  ? AppColors.grey800.withValues(alpha: 0.5)
                  : AppColors.grey200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(label,
                style: AppTextStyles.labelMedium(
                    color: isDark ? AppColors.grey200 : AppColors.grey700,
                    weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _QuickCard extends StatefulWidget {
  final IconData icon;
  final String title, subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;
  const _QuickCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.gradient,
      required this.onTap});

  @override
  State<_QuickCard> createState() => _QuickCardState();
}

class _QuickCardState extends State<_QuickCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: widget.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: widget.gradient.first.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(widget.icon, color: AppColors.white, size: 22),
              ),
              const SizedBox(height: 14),
              Text(widget.title,
                  style: AppTextStyles.titleSmall(
                      color: AppColors.white, weight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(widget.subtitle,
                  style: AppTextStyles.bodySmall(
                      color: AppColors.white.withValues(alpha: 0.65))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String title, time;
  final Color color;
  final bool isDark;
  const _ActivityRow(
      {required this.icon,
      required this.title,
      required this.time,
      required this.color,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(11)),
        child: Icon(icon, color: color, size: 18),
      ),
      const SizedBox(width: 14),
      Expanded(
          child: Text(title,
              style: AppTextStyles.bodyMedium(
                  color: isDark ? AppColors.grey200 : AppColors.grey700))),
      Text(time, style: AppTextStyles.bodySmall(color: AppColors.grey400)),
    ]);
  }
}
