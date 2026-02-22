import 'package:flutter/material.dart';
import '../theme.dart';

/// Premium badge widget for upcoming features
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({
    super.key,
    this.text = 'PREMIUM',
    this.size = BadgeSize.small,
    this.onTap,
  });

  final String text;
  final BadgeSize size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double fontSize;
    EdgeInsetsGeometry padding;

    switch (size) {
      case BadgeSize.small:
        fontSize = 9;
        padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
        break;
      case BadgeSize.medium:
        fontSize = 10;
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
        break;
      case BadgeSize.large:
        fontSize = 11;
        padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.premiumGold, Color(0xFFD97706)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: AppColors.premiumGold.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

/// Coming soon badge
class ComingSoonBadge extends StatelessWidget {
  const ComingSoonBadge({
    super.key,
    this.text = 'Coming Soon',
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.grey600,
          ),
        ),
      ),
    );
  }
}

/// Beta badge
class BetaBadge extends StatelessWidget {
  const BetaBadge({
    super.key,
    this.text = 'BETA',
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: AppColors.info,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

enum BadgeSize { small, medium, large }
