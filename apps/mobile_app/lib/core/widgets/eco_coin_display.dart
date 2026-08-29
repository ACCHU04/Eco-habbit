import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// Displays a Green Coin amount with an optional coin icon and label.
///
/// ```dart
/// EcoCoinDisplay(amount: 250, label: 'Balance')
/// ```
class EcoCoinDisplay extends StatelessWidget {
  const EcoCoinDisplay({
    super.key,
    required this.amount,
    this.label,
    this.size = EcoCoinDisplaySize.md,
    this.showIcon = true,
    this.animate = false,
  });

  final int amount;
  final String? label;
  final EcoCoinDisplaySize size;
  final bool showIcon;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconSize = switch (size) {
      EcoCoinDisplaySize.sm => EcoTokens.iconSizeSm,
      EcoCoinDisplaySize.md => EcoTokens.iconSizeMd,
      EcoCoinDisplaySize.lg => EcoTokens.iconSizeLg,
    };
    final fontSize = switch (size) {
      EcoCoinDisplaySize.sm => 12.0,
      EcoCoinDisplaySize.md => 16.0,
      EcoCoinDisplaySize.lg => 24.0,
    };
    final text = amount >= 1000
        ? '${(amount / 1000).toStringAsFixed(1)}k'
        : '$amount';

    Widget widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon)
          Icon(Icons.monetization_on, color: EcoColors.coinGold, size: iconSize),
        if (showIcon) SizedBox(width: size == EcoCoinDisplaySize.sm ? EcoTokens.spacing1 : EcoTokens.spacing1),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: fontSize,
                color: EcoColors.coinGold,
                fontWeight: FontWeight.w700,
              ),
        ),
        if (label != null) ...[
          const SizedBox(width: EcoTokens.spacing1),
          Text(
            label!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );

    if (animate) {
      widget = widget.animate().fadeIn(duration: EcoTokens.durationFast).slideX(begin: -0.2);
    }

    return widget;
  }
}

enum EcoCoinDisplaySize { sm, md, lg }
