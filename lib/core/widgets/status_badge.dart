import 'package:flutter/material.dart';
import '../theme.dart';

/// Status badge widget for showing safety status
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    required this.text,
    this.showIcon = true,
    this.size = BadgeSize.medium,
  });

  final SafetyStatus status;
  final String text;
  final bool showIcon;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    final statusColor = status.color;
    final bgColor = status.backgroundColor;

    double fontSize;
    double iconSize;
    EdgeInsetsGeometry padding;
    double borderRadius;

    switch (size) {
      case BadgeSize.small:
        fontSize = 11;
        iconSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
        borderRadius = AppDesignTokens.radius8;
        break;
      case BadgeSize.medium:
        fontSize = 13;
        iconSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
        borderRadius = AppDesignTokens.radius12;
        break;
      case BadgeSize.large:
        fontSize = 15;
        iconSize = 18;
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        borderRadius = AppDesignTokens.radius16;
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              _getIcon(),
              size: iconSize,
              color: statusColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (status) {
      case SafetyStatus.calm:
        return Icons.check_circle;
      case SafetyStatus.warning:
        return Icons.warning_amber;
      case SafetyStatus.critical:
        return Icons.error;
    }
  }
}

/// Large status banner for home screen
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.status,
    required this.title,
    this.subtitle,
    this.action,
  });

  final SafetyStatus status;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final statusColor = status.color;
    final bgColor = status.backgroundColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesignTokens.spacing16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(),
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium(
                    color: statusColor,
                    weight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall(
                      color: statusColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (status) {
      case SafetyStatus.calm:
        return Icons.shield;
      case SafetyStatus.warning:
        return Icons.timer;
      case SafetyStatus.critical:
        return Icons.warning_rounded;
    }
  }
}

enum BadgeSize { small, medium, large }
