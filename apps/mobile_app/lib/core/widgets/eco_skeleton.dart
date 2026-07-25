import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A skeleton loading placeholder that shows content shapes while data loads.
///
/// Wrap any widget tree in [EcoSkeleton] to show a skeletonized version.
///
/// ```dart
/// EcoSkeleton(
///   enabled: isLoading,
///   child: Column(
///     children: [
///       Text('Title'),
///       Text('Subtitle'),
///     ],
///   ),
/// )
/// ```
class EcoSkeleton extends StatelessWidget {
  const EcoSkeleton({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      ignoreContainers: false,
      textBoneBorderRadius: TextBoneBorderRadius(
        BorderRadius.circular(EcoTokens.radiusXs),
      ),
      child: child,
    );
  }
}

/// A skeleton placeholder for a list tile with avatar, title, and subtitle lines.
class EcoSkeletonTile extends StatelessWidget {
  const EcoSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Bone(
      borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
      width: double.infinity,
      height: 72,
    );
  }
}

/// A skeleton placeholder for a card with arbitrary content.
class EcoSkeletonCard extends StatelessWidget {
  const EcoSkeletonCard({super.key, this.height = 200});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Bone(
      borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
      width: double.infinity,
      height: height,
    );
  }
}
