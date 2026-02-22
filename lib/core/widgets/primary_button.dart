import 'package:flutter/material.dart';
import '../theme.dart';

/// A primary button with animations and loading state
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.iconPosition = IconPosition.left,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final IconPosition iconPosition;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed =
        (widget.isEnabled && !widget.isLoading) ? widget.onPressed : null;

    return GestureDetector(
      onTapDown: effectiveOnPressed != null ? _handleTapDown : null,
      onTapUp: effectiveOnPressed != null ? _handleTapUp : null,
      onTapCancel: effectiveOnPressed != null ? _handleTapCancel : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: AppDesignTokens.durationFast,
        child: SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 56,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : effectiveOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor ?? AppColors.primary,
              foregroundColor: widget.textColor ?? AppColors.white,
              disabledBackgroundColor: AppColors.grey300,
              disabledForegroundColor: AppColors.grey500,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.icon == null) {
      return Text(
        widget.text,
        style: AppTextStyles.labelLarge(
          color: widget.textColor ?? AppColors.white,
          weight: FontWeight.w600,
        ),
      );
    }

    final iconWidget = Icon(widget.icon, size: 20);
    final textWidget = Text(
      widget.text,
      style: AppTextStyles.labelLarge(
        color: widget.textColor ?? AppColors.white,
        weight: FontWeight.w600,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widget.iconPosition == IconPosition.left
          ? [iconWidget, const SizedBox(width: 8), textWidget]
          : [textWidget, const SizedBox(width: 8), iconWidget],
    );
  }
}

/// Secondary outline button
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          side: BorderSide(
            color: isEnabled
                ? (borderColor ?? AppColors.primary)
                : AppColors.grey300,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radius16),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: AppTextStyles.labelLarge(
                      color: textColor ?? AppColors.primary,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: AppTextStyles.labelLarge(
                  color: textColor ?? AppColors.primary,
                  weight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// Text button with icon
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }
}

enum IconPosition { left, right }
