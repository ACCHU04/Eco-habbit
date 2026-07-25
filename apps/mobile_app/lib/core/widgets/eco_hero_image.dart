import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A hero image with network support, placeholder, error fallback, and optional overlay.
///
/// ```dart
/// EcoHeroImage(
///   imageUrl: 'https://example.com/photo.jpg',
///   height: 200,
///   overlay: Text('Featured Item'),
/// )
/// ```
class EcoHeroImage extends StatelessWidget {
  const EcoHeroImage({
    super.key,
    this.imageUrl,
    this.iconFallback = Icons.image_outlined,
    this.height,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.overlay,
    this.backgroundColor,
  });

  final String? imageUrl;
  final IconData iconFallback;
  final double? height;
  final double? width;
  final double? borderRadius;
  final BoxFit fit;
  final Widget? overlay;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveRadius = borderRadius ?? EcoTokens.radiusMd;

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        color: backgroundColor ?? cs.surfaceContainer,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                placeholder: (_, __) => _Placeholder(
                  icon: iconFallback,
                  color: cs.onSurfaceVariant,
                ),
                errorWidget: (_, __, ___) => _Placeholder(
                  icon: iconFallback,
                  color: cs.onSurfaceVariant,
                ),
              )
            else
              _Placeholder(
                icon: iconFallback,
                color: cs.onSurfaceVariant,
              ),
            if (overlay != null)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white),
                    child: overlay!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(icon, size: EcoTokens.iconSizeXl, color: color),
    );
  }
}
