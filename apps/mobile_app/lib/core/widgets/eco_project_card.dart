import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_card.dart';
import 'package:mobile_app/core/widgets/eco_hero_image.dart';

/// A DIY project card with image, title, difficulty, time estimate, and likes.
///
/// ```dart
/// EcoProjectCard(
///   title: 'Tire Planter',
///   imageUrl: 'https://...',
///   difficulty: 'Easy',
///   timeEstimate: '45 min',
///   likes: 89,
///   onTap: () {},
/// )
/// ```
class EcoProjectCard extends StatelessWidget {
  const EcoProjectCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.difficulty,
    this.timeEstimate,
    this.likes = 0,
    this.steps,
    this.onTap,
  });

  final String title;
  final String? imageUrl;
  final String? difficulty;
  final String? timeEstimate;
  final int likes;
  final int? steps;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return EcoCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          EcoHeroImage(
            imageUrl: imageUrl,
            height: 120,
            iconFallback: Icons.build_outlined,
          ),
          Padding(
            padding: const EdgeInsets.all(EcoTokens.spacing3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: EcoTokens.spacing2),
                Row(
                  children: [
                    if (difficulty != null) ...[
                      Icon(Icons.signal_cellular_alt, size: EcoTokens.iconSizeSm, color: cs.onSurfaceVariant),
                      const SizedBox(width: EcoTokens.spacing1),
                      Text(
                        difficulty!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                    if (timeEstimate != null) ...[
                      const SizedBox(width: EcoTokens.spacing3),
                      Icon(Icons.access_time, size: EcoTokens.iconSizeSm, color: cs.onSurfaceVariant),
                      const SizedBox(width: EcoTokens.spacing1),
                      Text(
                        timeEstimate!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                    const Spacer(),
                    Icon(Icons.favorite_outline, size: EcoTokens.iconSizeSm, color: cs.onSurfaceVariant),
                    const SizedBox(width: EcoTokens.spacing1),
                    Text(
                      '$likes',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
