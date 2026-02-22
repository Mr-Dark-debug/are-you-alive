import 'package:flutter/material.dart';
import '../theme.dart';
import 'premium_badge.dart';

/// A settings toggle tile with optional subtitle
class ToggleTile extends StatelessWidget {
  const ToggleTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.isEnabled = true,
    this.showPremiumBadge = false,
    this.onPremiumTap,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final bool isEnabled;
  final bool showPremiumBadge;
  final VoidCallback? onPremiumTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: AppTextStyles.titleSmall(
          color: isEnabled ? null : AppColors.grey400,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.bodySmall(
                color: isEnabled ? AppColors.grey500 : AppColors.grey400,
              ),
            )
          : null,
      trailing: showPremiumBadge
          ? PremiumBadge(onTap: onPremiumTap)
          : Switch(
              value: value,
              onChanged: isEnabled ? onChanged : null,
              activeThumbColor: AppColors.primary,
            ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacing16,
        vertical: AppDesignTokens.spacing4,
      ),
      onTap: showPremiumBadge
          ? onPremiumTap
          : (isEnabled && onChanged != null)
              ? () => onChanged!(!value)
              : null,
    );
  }
}

/// A settings list tile with navigation
class NavigationTile extends StatelessWidget {
  const NavigationTile({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showChevron = true,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: AppTextStyles.titleSmall()),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.bodySmall(color: AppColors.grey500),
            )
          : null,
      trailing: trailing ??
          (showChevron
              ? const Icon(
                  Icons.chevron_right,
                  color: AppColors.grey400,
                )
              : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacing16,
        vertical: AppDesignTokens.spacing4,
      ),
    );
  }
}

/// A clickable tile with premium badge
class PremiumTile extends StatelessWidget {
  const PremiumTile({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: AppTextStyles.titleSmall()),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.bodySmall(color: AppColors.grey500),
            )
          : null,
      trailing: const PremiumBadge(),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacing16,
        vertical: AppDesignTokens.spacing4,
      ),
    );
  }
}
