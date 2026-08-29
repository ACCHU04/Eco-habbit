import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_avatar.dart';
import 'package:mobile_app/features/community/models/post.dart' show PostType;

/// A community post card with author, content preview, type badge, and engagement.
///
/// ```dart
/// EcoPostCard(
///   authorName: 'Chandu',
///   content: 'Just built a planter from old tires!',
///   postType: PostType.diy,
///   likes: 24,
///   comments: 8,
///   timeAgo: '2h ago',
///   onTap: () {},
/// )
/// ```
class EcoPostCard extends StatelessWidget {
  const EcoPostCard({
    super.key,
    required this.authorName,
    required this.content,
    required this.postType,
    this.authorAvatarUrl,
    this.likes = 0,
    this.comments = 0,
    this.timeAgo,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onLongPress,
    this.onBookmark,
    this.imageUrls = const [],
    this.isLiked = false,
    this.isBookmarked = false,
  });

  final String authorName;
  final String content;
  final PostType postType;
  final String? authorAvatarUrl;
  final int likes;
  final int comments;
  final String? timeAgo;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onLongPress;
  final VoidCallback? onBookmark;
  final List<String> imageUrls;
  final bool isLiked;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (typeLabel, typeColor) = switch (postType) {
      PostType.diy => ('DIY', EcoColors.postTypeDiy),
      PostType.tip => ('Tip', EcoColors.postTypeTip),
      PostType.marketplace => ('Marketplace', EcoColors.postTypeMarketplace),
    };

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EcoTokens.radiusMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(EcoTokens.spacing3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  EcoAvatar(
                    imageUrl: authorAvatarUrl,
                    name: authorName,
                    size: EcoAvatarSize.sm,
                  ),
                  const SizedBox(width: EcoTokens.spacing3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorName,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        if (timeAgo != null)
                          Text(
                            timeAgo!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: EcoTokens.spacing2,
                      vertical: EcoTokens.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                    ),
                    child: Text(
                      typeLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: typeColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: EcoTokens.spacing3),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (imageUrls.isNotEmpty) ...[
                const SizedBox(height: EcoTokens.spacing3),
                if (imageUrls.length == 1)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: imageUrls.first,
                        fit: BoxFit.cover,
                        memCacheWidth: 800,
                        placeholder: (_, __) => Container(
                          color: cs.surfaceContainer,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: cs.surfaceContainer,
                          child: const Icon(Icons.image_outlined),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: imageUrls.length.clamp(0, 4),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[index],
                            fit: BoxFit.cover,
                            memCacheWidth: 800,
                            placeholder: (_, __) => Container(
                              color: cs.surfaceContainer,
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: cs.surfaceContainer,
                              child: const Icon(Icons.image_outlined),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: EcoTokens.spacing3),
              Row(
                children: [
                  InkWell(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked ? EcoColors.error : cs.onSurfaceVariant,
                          size: EcoTokens.iconSizeMd,
                        ),
                        const SizedBox(width: EcoTokens.spacing1),
                        Text(
                          '$likes',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: EcoTokens.spacing5),
                  InkWell(
                    onTap: onComment,
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: cs.onSurfaceVariant,
                          size: EcoTokens.iconSizeMd,
                        ),
                        const SizedBox(width: EcoTokens.spacing1),
                        Text(
                          '$comments',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onBookmark,
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                      color: isBookmarked ? EcoColors.warning : cs.onSurfaceVariant,
                      size: EcoTokens.iconSizeMd,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
