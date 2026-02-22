import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/date_formatters.dart';

/// A countdown timer display widget
class CountdownTimerWidget extends StatefulWidget {
  const CountdownTimerWidget({
    super.key,
    required this.duration,
    this.onComplete,
    this.style = CountdownStyle.normal,
    this.color,
    this.showLabels = true,
    this.fontSize,
  });

  final Duration duration;
  final VoidCallback? onComplete;
  final CountdownStyle style;
  final Color? color;
  final bool showLabels;
  final double? fontSize;

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Duration _remaining;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _tick();
          _controller.repeat();
        }
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _remaining = widget.duration;
      _completed = false;
    }
  }

  void _tick() {
    if (_completed) return;

    setState(() {
      if (_remaining.inSeconds > 0) {
        _remaining = _remaining - const Duration(seconds: 1);
      } else {
        _completed = true;
        _controller.stop();
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.style == CountdownStyle.large) {
      return _buildLargeStyle();
    }
    return _buildNormalStyle();
  }

  Widget _buildNormalStyle() {
    final textColor = widget.color ?? AppColors.grey900;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TimeUnit(
          value: _remaining.inHours,
          label: 'Hours',
          color: textColor,
          showLabel: widget.showLabels,
          fontSize: widget.fontSize ?? 32,
        ),
        _buildSeparator(textColor),
        _TimeUnit(
          value: _remaining.inMinutes % 60,
          label: 'Minutes',
          color: textColor,
          showLabel: widget.showLabels,
          fontSize: widget.fontSize ?? 32,
        ),
        _buildSeparator(textColor),
        _TimeUnit(
          value: _remaining.inSeconds % 60,
          label: 'Seconds',
          color: textColor,
          showLabel: widget.showLabels,
          fontSize: widget.fontSize ?? 32,
        ),
      ],
    );
  }

  Widget _buildLargeStyle() {
    final textColor = widget.color ?? AppColors.white;
    final fontSize = widget.fontSize ?? 120;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Text(
          DateFormatters.formatCountdown(_remaining),
          style: AppTextStyles.countdownTimer(
            color: textColor.withValues(alpha: 0.3),
            fontSize: fontSize,
          ),
        ),
        // Main text
        AnimatedSwitcher(
          duration: AppDesignTokens.durationFast,
          child: Text(
            DateFormatters.formatCountdown(_remaining),
            key: ValueKey(_remaining.inSeconds),
            style: AppTextStyles.countdownTimer(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: AppTextStyles.displaySmall(
          color: color,
          weight: FontWeight.w300,
        ),
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  const _TimeUnit({
    required this.value,
    required this.label,
    required this.color,
    required this.showLabel,
    this.fontSize = 32,
  });

  final int value;
  final String label;
  final Color color;
  final bool showLabel;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: AppDesignTokens.durationFast,
          child: Text(
            value.toString().padLeft(2, '0'),
            key: ValueKey(value),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall(color: color.withValues(alpha: 0.7)),
          ),
        ],
      ],
    );
  }
}

/// Simple countdown display (non-animated)
class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay({
    super.key,
    required this.duration,
    this.color,
    this.fontSize = 24,
  });

  final Duration duration;
  final Color? color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? Theme.of(context).textTheme.bodyLarge?.color;

    return Text(
      DateFormatters.formatDuration(duration),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

enum CountdownStyle { normal, large }
