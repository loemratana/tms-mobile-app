import 'package:flutter/material.dart';

abstract final class AppColors {
  // ─────────────────────────────────────────────
  // Brand
  // ─────────────────────────────────────────────

  static const primary = Color(0xFF4F46E5);
  static const primaryDark = Color(0xFF3730A3);
  static const primaryLight = Color(0xFFE0E7FF);

  static const primaryMaterial = MaterialColor(0xFF4F46E5, {
    50: Color(0xFFEEF2FF),
    100: Color(0xFFE0E7FF),
    200: Color(0xFFC7D2FE),
    300: Color(0xFFA5B4FC),
    400: Color(0xFF818CF8),
    500: Color(0xFF4F46E5),
    600: Color(0xFF4338CA),
    700: Color(0xFF3730A3),
    800: Color(0xFF312E81),
    900: Color(0xFF1E1B4B),
  });

  // ─────────────────────────────────────────────
  // Neutral
  // ─────────────────────────────────────────────

  static const black = Color(0xFF111827);
  static const black80 = Color(0xFF374151);
  static const black60 = Color(0xFF6B7280);
  static const black40 = Color.fromARGB(255, 253, 195, 171);
  static const black20 = Color(0xFFD1D5DB);
  static const black10 = Color(0xFFE5E7EB);
  static const black5 = Color(0xFFF3F4F6);

  static const white = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────
  // Background
  // ─────────────────────────────────────────────

  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const lightGrey = Color(0xFFF3F4F6);
  static const grey = Color(0xFF9CA3AF);
  static const darkGrey = Color(0xFF1F2937);

  // ─────────────────────────────────────────────
  // Semantic
  // ─────────────────────────────────────────────

  static const success = Color(0xFF16A34A);
  static const successLight = Color(0xFFDCFCE7);

  static const warning = Color(0xFFD97706);
  static const warningLight = Color(0xFFFEF3C7);

  static const error = Color(0xFFDC2626);
  static const errorLight = Color(0xFFFEE2E2);

  static const info = Color(0xFF2563EB);
  static const infoLight = Color(0xFFDBEAFE);
}
