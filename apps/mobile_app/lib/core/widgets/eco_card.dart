import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A themed card container with consistent radius, elevation, and padding.
///
/// Wraps a [Card] and applies [EcoTokens] radius and elevation.
///
/// ```dart
/// EcoCard(
///   child: Text('Content'),
/// )
/// ```
class EcoCard extends StatelessWidget {
  const EcoCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevation,
    this.color,
    this.borderColor,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? elevation;
  final Color? color;
  final Color? borderColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveRadius = borderRadius ?? EcoTokens.radiusMd;

    return Card(
      margin: margin ?? EdgeInsets.zero,
      elevation: elevation ?? EcoTokens.elevationXs,
      color: color ?? cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveRadius),
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: 1)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: Padding(
          padding: padding ?? EcoTokens.paddingCard,
          child: child,
        ),
      ),
    );
  }
}
