import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// An animated counter that smoothly transitions between numeric values.
///
/// ```dart
/// EcoAnimatedCounter(
///   value: 1250,
///   prefix: '\$',
///   suffix: ' CO₂ saved',
/// )
/// ```
class EcoAnimatedCounter extends StatelessWidget {
  const EcoAnimatedCounter({
    super.key,
    required this.value,
    this.prefix,
    this.suffix,
    this.style,
    this.duration,
    this.decimals = 0,
    this.curve = Curves.easeOutCubic,
  });

  final double value;
  final String? prefix;
  final String? suffix;
  final TextStyle? style;
  final Duration? duration;
  final int decimals;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? Theme.of(context).textTheme.headlineMedium;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration ?? EcoTokens.durationSlow,
      curve: curve,
      builder: (context, animatedValue, child) {
        final display = decimals > 0
            ? animatedValue.toStringAsFixed(decimals)
            : animatedValue.round().toString();

        return Text(
          '${prefix ?? ''}$display${suffix ?? ''}',
          style: effectiveStyle,
        );
      },
    );
  }
}
