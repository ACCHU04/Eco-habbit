import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A themed progress bar with optional label, percentage text, and color.
///
/// ```dart
/// EcoProgressBar(
///   value: 0.7,
///   label: 'Quest Progress',
///   showPercentage: true,
/// )
/// ```
class EcoProgressBar extends StatelessWidget {
  const EcoProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercentage = false,
    this.color,
    this.backgroundColor,
    this.height = 8,
    this.borderRadius,
  });

  final double value;
  final String? label;
  final bool showPercentage;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final clamped = value.clamp(0.0, 1.0);
    final effectiveRadius = borderRadius ?? EcoTokens.radiusFull;
    final effectiveColor = color ?? cs.primary;
    final effectiveBg = backgroundColor ?? cs.primaryContainer;

    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: clamped,
          backgroundColor: effectiveBg,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          minHeight: height,
        ),
      ),
    );

    if (label == null && !showPercentage) return bar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: EcoTokens.spacing1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                if (showPercentage)
                  Text(
                    '${(clamped * 100).round()}%',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: effectiveColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
              ],
            ),
          ),
        bar,
      ],
    );
  }
}
