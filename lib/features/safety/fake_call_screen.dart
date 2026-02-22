import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

/// Fake Call Screen - Simulates a realistic incoming call
class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({super.key});

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _callTimer;
  int _callDuration = 0;
  bool _isCallAnswered = false;
  bool _canVibrate = false;

  @override
  void initState() {
    super.initState();
    _initCall();
  }

  Future<void> _initCall() async {
    _canVibrate = await Vibration.hasVibrator();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Start ringing
    _startRinging();
  }

  Future<void> _startRinging() async {
    // Vibrate pattern for incoming call
    if (_canVibrate) {
      _startVibrationPattern();
    }

    // Auto-end call after 30 seconds
    _callTimer = Timer(const Duration(seconds: 30), () {
      if (!_isCallAnswered && mounted) {
        _endCall();
      }
    });
  }

  void _startVibrationPattern() async {
    while (!_isCallAnswered && mounted) {
      Vibration.vibrate();
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  void _answerCall() {
    setState(() {
      _isCallAnswered = true;
    });

    _pulseController.stop();

    // Start call timer
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _callDuration++;
      });

      // Auto-end after 2 minutes
      if (_callDuration >= 120) {
        timer.cancel();
        _endCall();
      }
    });
  }

  void _endCall() {
    _pulseController.dispose();
    _audioPlayer.stop();
    _callTimer?.cancel();
    Navigator.of(context).pop();
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioPlayer.dispose();
    _callTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      backgroundColor: AppColors.grey900,
      body: SafeArea(
        child: _isCallAnswered ? _buildActiveCall() : _buildIncomingCall(),
      ),
    );
  }

  Widget _buildIncomingCall() {
    return Column(
      children: [
        const SizedBox(height: 60),

        // Caller info
        Column(
          children: [
            // Profile picture
            _buildProfilePicture()
                .animate(onPlay: (c) => c.repeat())
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1500.ms,
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: 1500.ms,
                ),

            const SizedBox(height: 24),

            // Caller name
            Text(
              'John Smith',
              style: AppTextStyles.headlineMedium(color: AppColors.white),
            ),

            const SizedBox(height: 8),

            // Call type
            Text(
              'Mobile',
              style: AppTextStyles.bodyLarge(color: AppColors.grey400),
            ),
          ],
        ),

        const Spacer(),

        // Call actions
        Padding(
          padding: const EdgeInsets.all(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Decline button
              _CallActionButton(
                icon: Icons.call_end,
                label: 'Decline',
                color: AppColors.criticalColor,
                onPressed: _endCall,
              ),

              // Answer button
              _CallActionButton(
                icon: Icons.call,
                label: 'Answer',
                color: AppColors.calmColor,
                onPressed: _answerCall,
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildActiveCall() {
    return Column(
      children: [
        const SizedBox(height: 60),

        // Call info
        Column(
          children: [
            // Static profile picture
            _buildProfilePicture(),

            const SizedBox(height: 24),

            // Caller name
            Text(
              'John Smith',
              style: AppTextStyles.headlineMedium(color: AppColors.white),
            ),

            const SizedBox(height: 8),

            // Call duration
            Text(
              _formatDuration(_callDuration),
              style: AppTextStyles.titleMedium(color: AppColors.grey400),
            ),
          ],
        ),

        const Spacer(),

        // Call controls
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // Mute and Speaker row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCallControl(
                    icon: Icons.mic_off,
                    label: 'Mute',
                    onTap: () {},
                  ),
                  _buildCallControl(
                    icon: Icons.volume_up,
                    label: 'Speaker',
                    onTap: () {},
                  ),
                  _buildCallControl(
                    icon: Icons.dialpad,
                    label: 'Keypad',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // End call button
              GestureDetector(
                onTap: _endCall,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.criticalColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call_end,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'End Call',
                style: AppTextStyles.bodyMedium(color: AppColors.grey400),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grey700,
        border: Border.all(
          color: AppColors.grey600,
          width: 3,
        ),
      ),
      child: const Icon(
        Icons.person,
        size: 60,
        color: AppColors.grey400,
      ),
    );
  }

  Widget _buildCallControl({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.grey800,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall(color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}

class _CallActionButton extends StatelessWidget {
  const _CallActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.bodyMedium(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
