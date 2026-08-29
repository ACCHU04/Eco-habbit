import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A gradient banner with optional title, subtitle, and child content.
///
/// Used for hero sections, empty states, and promotional banners.
///
/// ```dart
/// EcoGradientBanner(
///   title: 'Welcome back, Chandu!',
///   subtitle: 'Complete today\'s quest to earn coins',
///   gradientColors: [EcoColors.primary, EcoColors.secondary],
///   child: EcoButton(label: 'Start Quest', onPressed: () {}),
/// )
/// ```
class EcoGradientBanner extends StatelessWidget {
  const EcoGradientBanner({
    super.key,
    this.title,
    this.subtitle,
    this.gradientColors,
    this.child,
    this.padding,
    this.borderRadius,
  });

  final String? title;
  final String? subtitle;
  final List<Color>? gradientColors;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = gradientColors ?? [cs.primary, cs.tertiary];
    final effectiveRadius = borderRadius ?? EcoTokens.radiusLg;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(EcoTokens.spacing5),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              if (title != null && subtitle != null)
                const SizedBox(height: EcoTokens.spacing2),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                ),
              if (child != null)
                Padding(
                  padding: const EdgeInsets.only(top: EcoTokens.spacing4),
                  child: child!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
