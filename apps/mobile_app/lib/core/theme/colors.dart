import 'package:flutter/material.dart';

class EcoColors {
  // Primary
  static const primary = Color(0xFF10B981);
  static const primaryLight = Color(0xFF34D399);
  static const primaryDark = Color(0xFF059669);
  static const primaryContainer = Color(0xFFD1FAE5);
  static const onPrimaryContainer = Color(0xFF065F46);

  // Secondary
  static const secondary = Color(0xFF0D9488);
  static const secondaryContainer = Color(0xFFCCFBF1);
  static const tertiary = Color(0xFFF59E0B);
  static const tertiaryContainer = Color(0xFFFEF3C7);

  // Neutral (Light Mode)
  static const backgroundLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFF9FAFB);
  static const onBackgroundLight = Color(0xFF111827);
  static const onSurfaceLight = Color(0xFF1F2937);
  static const outlineLight = Color(0xFFD1D5DB);

  // Neutral (Dark Mode)
  static const backgroundDark = Color(0xFF121212);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const onBackgroundDark = Color(0xFFF3F4F6);
  static const onSurfaceDark = Color(0xFFE5E7EB);
  static const outlineDark = Color(0xFF4B5563);

  // Semantic
  static const error = Color(0xFFDC2626);
  static const errorContainer = Color(0xFFFEE2E2);
  static const onErrorContainer = Color(0xFF991B1B);
  static const success = Color(0xFF059669);
  static const successContainer = Color(0xFFD1FAE5);
  static const info = Color(0xFF2563EB);
  static const infoContainer = Color(0xFFDBEAFE);
}

typedef AppColors = EcoColors;
