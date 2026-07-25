import 'package:flutter/material.dart';

class EcoColors {
  EcoColors._();

  // ── Primary ──
  static const primary = Color(0xFF10B981);
  static const primaryLight = Color(0xFF34D399);
  static const primaryDark = Color(0xFF059669);
  static const primaryContainer = Color(0xFFD1FAE5);
  static const onPrimaryContainer = Color(0xFF065F46);
  static const onPrimary = Colors.white;

  // ── Secondary ──
  static const secondary = Color(0xFF0D9488);
  static const secondaryLight = Color(0xFF2DD4BF);
  static const secondaryContainer = Color(0xFFCCFBF1);
  static const onSecondaryContainer = Color(0xFF134E4A);

  // ── Tertiary / Coin ──
  static const tertiary = Color(0xFFF59E0B);
  static const tertiaryLight = Color(0xFFFBBF24);
  static const tertiaryContainer = Color(0xFFFEF3C7);
  static const onTertiaryContainer = Color(0xFF78350F);

  // ── Neutral (Light) ──
  static const backgroundLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFF9FAFB);
  static const surfaceContainerLight = Color(0xFFF3F4F6);
  static const onBackgroundLight = Color(0xFF111827);
  static const onSurfaceLight = Color(0xFF1F2937);
  static const onSurfaceVariantLight = Color(0xFF6B7280);
  static const outlineLight = Color(0xFFD1D5DB);
  static const outlineVariantLight = Color(0xFFE5E7EB);

  // ── Neutral (Dark) ──
  static const backgroundDark = Color(0xFF0F1419);
  static const surfaceDark = Color(0xFF1A1F25);
  static const surfaceContainerDark = Color(0xFF232830);
  static const onBackgroundDark = Color(0xFFF3F4F6);
  static const onSurfaceDark = Color(0xFFE5E7EB);
  static const onSurfaceVariantDark = Color(0xFF9CA3AF);
  static const outlineDark = Color(0xFF4B5563);
  static const outlineVariantDark = Color(0xFF374151);

  // ── Semantic ──
  static const error = Color(0xFFDC2626);
  static const errorLight = Color(0xFFEF4444);
  static const errorContainer = Color(0xFFFEE2E2);
  static const onErrorContainer = Color(0xFF991B1B);
  static const success = Color(0xFF059669);
  static const successContainer = Color(0xFFD1FAE5);
  static const info = Color(0xFF2563EB);
  static const infoContainer = Color(0xFFDBEAFE);
  static const warning = Color(0xFFF59E0B);
  static const warningContainer = Color(0xFFFEF3C7);

  // ── Coins / XP / Streak ──
  static const coinGold = Color(0xFFF59E0B);
  static const coinGoldLight = Color(0xFFFCD34D);
  static const coinGoldDark = Color(0xFFD97706);
  static const xpPurple = Color(0xFF8B5CF6);
  static const xpPurpleLight = Color(0xFFA78BFA);
  static const xpPurpleDark = Color(0xFF7C3AED);
  static const streakFlame = Color(0xFFEF4444);
  static const streakFlameLight = Color(0xFFF87171);
  static const streakFlameDark = Color(0xFFDC2626);

  // ── Difficulty badges ──
  static const difficultyEasy = Color(0xFF22C55E);
  static const difficultyMedium = Color(0xFFF59E0B);
  static const difficultyHard = Color(0xFFEF4444);
  static const difficultyLegendary = Color(0xFF8B5CF6);

  // ── Impact ──
  static const impactCarbon = Color(0xFF10B981);
  static const impactWater = Color(0xFF3B82F6);
  static const impactWaste = Color(0xFFF97316);
  static const impactEnergy = Color(0xFFEAB308);

  // ── Post type ──
  static const postTypeDiy = Color(0xFF8B5CF6);
  static const postTypeTip = Color(0xFF3B82F6);
  static const postTypeMarketplace = Color(0xFF10B981);

  // ── Surface tint for dark mode cards ──
  static const surfaceTintDark = Color(0xFF10B981);
}

typedef AppColors = EcoColors;
