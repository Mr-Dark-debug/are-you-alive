import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';

/// A reusable card with glassmorphism effect support
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.showShadow = true,
    this.useGlassmorphism = false,
    this.glassOpacity = 0.1,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? elevation;
  final bool showShadow;
  final bool useGlassmorphism;
  final double glassOpacity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? AppDesignTokens.radius16;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkCard : AppColors.lightCard);

    Widget cardContent = Padding(
      padding: padding ?? const EdgeInsets.all(AppDesignTokens.spacing16),
      child: child,
    );

    if (useGlassmorphism) {
      cardContent = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: glassOpacity),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: cardContent,
          ),
        ),
      );
    } else {
      cardContent = Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: isDark
                        ? AppColors.black.withValues(alpha: 0.3)
                        : AppColors.grey400.withValues(alpha: 0.15),
                    blurRadius: elevation ?? 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: cardContent,
      );
    }

    if (margin != null) {
      cardContent = Padding(padding: margin!, child: cardContent);
    }

    if (onTap != null || onLongPress != null) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(radius),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// A glassmorphism overlay widget
class GlassOverlay extends StatelessWidget {
  const GlassOverlay({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.2,
    this.color,
    this.borderRadius,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final Color? color;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDesignTokens.radius24;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: (color ?? AppColors.white).withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: (color ?? AppColors.white).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
