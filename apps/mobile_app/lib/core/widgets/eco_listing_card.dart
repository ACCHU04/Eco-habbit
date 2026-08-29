import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_card.dart';

/// A marketplace listing card with image, title, price, condition, and seller.
///
/// ```dart
/// EcoListingCard(
///   title: 'Calculus Textbook',
///   price: '₹350',
///   imageUrl: 'https://...',
///   condition: 'Good',
///   category: 'Textbooks',
///   onTap: () {},
/// )
/// ```
class EcoListingCard extends StatelessWidget {
  const EcoListingCard({
    super.key,
    required this.title,
    required this.price,
    this.imageUrl,
    this.condition,
    this.category,
    this.sellerName,
    this.onTap,
    this.onFavorite,
    this.isFavorited = false,
  });

  final String title;
  final String price;
  final String? imageUrl;
  final String? condition;
  final String? category;
  final String? sellerName;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorited;

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
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: cs.surfaceContainer,
                          child: const Icon(Icons.image_outlined),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: cs.surfaceContainer,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                      )
                    : Container(
                        color: cs.surfaceContainer,
                        child: const Icon(Icons.image_outlined),
                      ),
              ),
              if (condition != null)
                Positioned(
                  top: EcoTokens.spacing2,
                  left: EcoTokens.spacing2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: EcoTokens.spacing2,
                      vertical: EcoTokens.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                    ),
                    child: Text(
                      condition!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              if (onFavorite != null)
                Positioned(
                  top: EcoTokens.spacing2,
                  right: EcoTokens.spacing2,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(EcoTokens.spacing1),
                      decoration: BoxDecoration(
                        color: cs.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_outline,
                        color: isFavorited ? EcoColors.error : cs.onSurfaceVariant,
                        size: EcoTokens.iconSizeMd,
                      ),
                    ),
                  ),
                ),
            ],
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
                const SizedBox(height: EcoTokens.spacing1),
                Row(
                  children: [
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: EcoColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const Spacer(),
                    if (category != null)
                      Text(
                        category!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
                if (sellerName != null) ...[
                  const SizedBox(height: EcoTokens.spacing2),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: EcoTokens.iconSizeSm, color: cs.onSurfaceVariant),
                      const SizedBox(width: EcoTokens.spacing1),
                      Text(
                        sellerName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
