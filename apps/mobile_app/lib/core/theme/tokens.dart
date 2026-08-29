import 'package:flutter/material.dart';

abstract final class EcoTokens {
  // Spacing (8px grid)
  static const double spacing0 = 0;
  static const double spacing1 = 4;
  static const double spacing2 = 8;
  static const double spacing3 = 12;
  static const double spacing4 = 16;
  static const double spacing5 = 20;
  static const double spacing6 = 24;
  static const double spacing7 = 32;
  static const double spacing8 = 40;
  static const double spacing9 = 48;
  static const double spacing10 = 56;
  static const double spacing12 = 64;

  // Border radius
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  // Animation durations
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);

  // Touch targets (WCAG 2.5.8 — 44px minimum)
  static const double touchTargetMin = 44;
  static const double touchTargetComfortable = 48;

  // Component sizes
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 56;
  static const double iconSizeSm = 16;
  static const double iconSizeMd = 24;
  static const double iconSizeLg = 32;
  static const double iconSizeXl = 48;

  // Elevation
  static const double elevationNone = 0;
  static const double elevationXs = 1;
  static const double elevationSm = 2;
  static const double elevationMd = 4;
  static const double elevationLg = 8;

  // EdgeInsets helpers
  static const EdgeInsets paddingPage = EdgeInsets.all(spacing4);
  static const EdgeInsets paddingCard = EdgeInsets.all(spacing3);
  static const EdgeInsets paddingButtonH = EdgeInsets.symmetric(horizontal: spacing4);
  static const EdgeInsets paddingButtonV = EdgeInsets.symmetric(vertical: spacing3);

  static const EdgeInsets marginPageH = EdgeInsets.symmetric(horizontal: spacing4);
  static const EdgeInsets marginSectionV = EdgeInsets.only(bottom: spacing6);
}
