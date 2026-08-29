import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// Displays a user's level with an XP progress ring.
///
/// ```dart
/// EcoLevelBadge(level: 7, xpProgress: 0.65)
/// ```
class EcoLevelBadge extends StatelessWidget {
  const EcoLevelBadge({
    super.key,
    required this.level,
    this.xpProgress = 0,
    this.size = EcoLevelBadgeSize.md,
    this.showLabel = true,
  });

  final int level;
  final double xpProgress;
  final EcoLevelBadgeSize size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dimension = switch (size) {
      EcoLevelBadgeSize.sm => 36.0,
      EcoLevelBadgeSize.md => 48.0,
      EcoLevelBadgeSize.lg => 64.0,
    };
    final fontSize = switch (size) {
      EcoLevelBadgeSize.sm => 12.0,
      EcoLevelBadgeSize.md => 16.0,
      EcoLevelBadgeSize.lg => 24.0,
    };
    final strokeWidth = switch (size) {
      EcoLevelBadgeSize.sm => 2.5,
      EcoLevelBadgeSize.md => 3.0,
      EcoLevelBadgeSize.lg => 4.0,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: dimension,
          height: dimension,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: xpProgress.clamp(0.0, 1.0),
                strokeWidth: strokeWidth,
                backgroundColor: cs.primaryContainer,
                valueColor: const AlwaysStoppedAnimation<Color>(EcoColors.xpPurple),
              ),
              Center(
                child: Text(
                  '$level',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: EcoColors.xpPurple,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showLabel && size != EcoLevelBadgeSize.sm)
          Padding(
            padding: const EdgeInsets.only(top: EcoTokens.spacing1),
            child: Text(
              'Lvl $level',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: EcoColors.xpPurple,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
      ],
    );
  }
}

enum EcoLevelBadgeSize { sm, md, lg }
