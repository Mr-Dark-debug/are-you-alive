import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({super.key});
  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  bool _isInCall = false;
  int _callSeconds = 0;
  Timer? _callTimer;
  bool _isMuted = false;
  bool _isSpeaker = false;

  void _answerCall() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isInCall = true;
    });
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _callSeconds++);
    });
  }

  void _declineOrEnd() {
    _callTimer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isInCall
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFF0F172A), const Color(0xFF1E293B)],
          ),
        ),
        child: SafeArea(
          child: _isInCall ? _buildInCallUI() : _buildRingingUI(),
        ),
      ),
    );
  }

  Widget _buildRingingUI() {
    return Column(
      children: [
        const Spacer(flex: 3),

        // Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.accentDark]),
            shape: BoxShape.circle,
          ),
          child: const Center(
              child: Text('J',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white))),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.05, 1.05),
            duration: 1200.ms),

        const SizedBox(height: 20),
        Text('Jennifer Smith',
            style: AppTextStyles.titleLarge(color: AppColors.white)),
        const SizedBox(height: 6),
        Text('Incoming Call...',
                style: AppTextStyles.bodyMedium(color: AppColors.grey400))
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1500.ms, color: AppColors.grey500),

        const Spacer(flex: 4),

        // Answer / Decline buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CallActionButton(
                icon: Icons.call_end,
                color: AppColors.criticalColor,
                label: 'Decline',
                onTap: _declineOrEnd,
              ),
              _CallActionButton(
                icon: Icons.call,
                color: AppColors.calmColor,
                label: 'Answer',
                onTap: _answerCall,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildInCallUI() {
    final mins = (_callSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_callSeconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        const Spacer(flex: 2),

        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.accentDark]),
            shape: BoxShape.circle,
          ),
          child: const Center(
              child: Text('J',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white))),
        ),
        const SizedBox(height: 16),
        Text('Jennifer Smith',
            style: AppTextStyles.titleLarge(color: AppColors.white)),
        const SizedBox(height: 6),
        Text('$mins:$secs',
            style: AppTextStyles.bodyMedium(color: AppColors.calmColor)),

        const Spacer(flex: 2),

        // Call controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SmallButton(
                  icon: _isMuted ? Icons.mic_off : Icons.mic,
                  isActive: _isMuted,
                  label: 'Mute',
                  onTap: () => setState(() => _isMuted = !_isMuted)),
              _SmallButton(
                  icon: Icons.dialpad,
                  isActive: false,
                  label: 'Keypad',
                  onTap: () {}),
              _SmallButton(
                  icon: _isSpeaker ? Icons.volume_up : Icons.volume_down,
                  isActive: _isSpeaker,
                  label: 'Speaker',
                  onTap: () => setState(() => _isSpeaker = !_isSpeaker)),
            ],
          ),
        ),

        const SizedBox(height: 48),

        // End call
        GestureDetector(
          onTap: _declineOrEnd,
          child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.criticalColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call_end, color: AppColors.white, size: 28),
          ),
        ),

        const SizedBox(height: 60),
      ],
    );
  }
}

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _CallActionButton(
      {required this.icon,
      required this.color,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 64,
          height: 64,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4))
          ]),
          child: Icon(icon, color: AppColors.white, size: 28),
        ),
        const SizedBox(height: 10),
        Text(label, style: AppTextStyles.bodySmall(color: AppColors.grey400)),
      ]),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final String label;
  final VoidCallback onTap;
  const _SmallButton(
      {required this.icon,
      required this.isActive,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.white.withValues(alpha: 0.2)
                : AppColors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.labelSmall(color: AppColors.grey400)),
      ]),
    );
  }
}
