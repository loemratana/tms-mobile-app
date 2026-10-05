import 'package:flutter/material.dart';

/// A circular progress indicator styled to the app's primary color.
///
/// Use the default constructor for a full page/section loading state, and
/// [AppLoader.small] wherever a compact spinner is needed (e.g. inside
/// [AppButton] while it's loading).
class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.color})
    : size = 36,
      strokeWidth = 3;

  const AppLoader.small({super.key, this.color})
    : size = 18,
      strokeWidth = 2;

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
