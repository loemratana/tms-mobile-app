import 'package:flutter/material.dart';

import 'app_loader.dart';

enum AppButtonVariant { primary, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final IconData? icon;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final onTap = isLoading ? null : onPressed;
    final child = isLoading ? _buildSpinner(context) : _buildLabel();

    final radius = BorderRadius.circular(borderRadius ?? 8);

    final buttonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(width ?? 0, height ?? 48)),
      fixedSize: width != null || height != null
          ? WidgetStatePropertyAll(Size(width ?? double.infinity, height ?? 48))
          : null,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: radius),
      ),
    );

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: onTap,
        style: buttonStyle.merge(
          FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
          ),
        ),
        child: child,
      ),

      AppButtonVariant.outlined => OutlinedButton(
        onPressed: onTap,
        style: buttonStyle.merge(
          OutlinedButton.styleFrom(foregroundColor: foregroundColor),
        ),
        child: child,
      ),

      AppButtonVariant.text => TextButton(
        onPressed: onTap,
        style: buttonStyle.merge(
          TextButton.styleFrom(foregroundColor: foregroundColor),
        ),
        child: child,
      ),
    };
  }

  Widget _buildLabel() {
    if (icon == null) {
      return Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildSpinner(BuildContext context) {
    final color =
        foregroundColor ??
        (variant == AppButtonVariant.primary
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.primary);

    return AppLoader.small(color: color);
  }
}
