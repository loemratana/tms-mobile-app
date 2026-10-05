import 'package:flutter/material.dart';
import 'package:mobile_ecommerce/core/theme/app_colors.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({super.key, required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.black40,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: SizedBox(
          height: 48,
          child: Center(child: Image.asset(assetPath, width: 24, height: 24)),
        ),
      ),
    );
  }
}
