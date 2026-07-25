import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// Displays a daily streak counter with a flame icon.
///
/// ```dart
/// EcoStreakDisplay(days: 14)
/// ```
class EcoStreakDisplay extends StatelessWidget {
  const EcoStreakDisplay({
    super.key,
    required this.days,
    this.size = EcoStreakDisplaySize.md,
    this.showLabel = true,
  });

  final int days;
  final EcoStreakDisplaySize size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final iconSize = switch (size) {
      EcoStreakDisplaySize.sm => EcoTokens.iconSizeSm,
      EcoStreakDisplaySize.md => EcoTokens.iconSizeMd,
      EcoStreakDisplaySize.lg => EcoTokens.iconSizeLg,
    };
    final fontSize = switch (size) {
      EcoStreakDisplaySize.sm => 12.0,
      EcoStreakDisplaySize.md => 16.0,
      EcoStreakDisplaySize.lg => 24.0,
    };

    final isActive = days > 0;
    final color = isActive ? EcoColors.streakFlame : Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_fire_department,
          color: color,
          size: iconSize,
        ),
        const SizedBox(width: EcoTokens.spacing1),
        Text(
          '$days',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: color,
            height: 1,
          ),
        ),
        if (showLabel && size != EcoStreakDisplaySize.sm)
          Padding(
            padding: const EdgeInsets.only(left: EcoTokens.spacing1),
            child: Text(
              days == 1 ? 'day' : 'days',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
            ),
          ),
      ],
    );
  }
}

enum EcoStreakDisplaySize { sm, md, lg }
