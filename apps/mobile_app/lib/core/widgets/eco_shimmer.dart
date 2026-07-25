import 'package:flutter/material.dart';

/// A shimmer effect wrapper for skeleton loading states.
///
/// Uses a gradient animation to create a shimmering effect over the child.
///
/// ```dart
/// EcoShimmer(
///   enabled: isLoading,
///   child: Container(height: 100, color: Colors.grey),
/// )
/// ```
class EcoShimmer extends StatefulWidget {
  const EcoShimmer({
    super.key,
    required this.enabled,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  final bool enabled;
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  @override
  State<EcoShimmer> createState() => _EcoShimmerState();
}

class _EcoShimmerState extends State<EcoShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.period,
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(EcoShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final cs = Theme.of(context).colorScheme;
    final base = widget.baseColor ?? cs.surfaceContainer;
    final highlight = widget.highlightColor ?? cs.surface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
