import 'package:flutter/material.dart';
import '../theme.dart';

/// Section header widget for grouping settings or list items
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.padding,
  });

  final String title;
  final Widget? action;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.fromLTRB(
            AppDesignTokens.spacing16,
            AppDesignTokens.spacing24,
            AppDesignTokens.spacing16,
            AppDesignTokens.spacing8,
          ),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.labelMedium(
              color: AppColors.grey500,
              weight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// Section divider
class SectionDivider extends StatelessWidget {
  const SectionDivider({
    super.key,
    this.padding,
  });

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: AppDesignTokens.spacing8,
            horizontal: AppDesignTokens.spacing16,
          ),
      child: const Divider(height: 1),
    );
  }
}

/// Spacer widget with configurable height
class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer(this.height, {super.key});

  final double height;

  const VerticalSpacer.small({Key? key})
      : this(AppDesignTokens.spacing8, key: key);
  const VerticalSpacer.medium({Key? key})
      : this(AppDesignTokens.spacing16, key: key);
  const VerticalSpacer.large({Key? key})
      : this(AppDesignTokens.spacing24, key: key);
  const VerticalSpacer.extraLarge({Key? key})
      : this(AppDesignTokens.spacing32, key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

/// Horizontal spacer widget
class HorizontalSpacer extends StatelessWidget {
  const HorizontalSpacer(this.width, {super.key});

  final double width;

  const HorizontalSpacer.small({Key? key})
      : this(AppDesignTokens.spacing8, key: key);
  const HorizontalSpacer.medium({Key? key})
      : this(AppDesignTokens.spacing16, key: key);
  const HorizontalSpacer.large({Key? key})
      : this(AppDesignTokens.spacing24, key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
