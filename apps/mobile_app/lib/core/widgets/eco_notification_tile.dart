import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A notification tile with icon, title, body, time, and read state.
///
/// ```dart
/// EcoNotificationTile(
///   icon: Icons.emoji_events,
///   title: 'New Badge Unlocked!',
///   body: 'You earned the "Recycling Champion" badge',
///   timeAgo: '5m ago',
///   onTap: () {},
/// )
/// ```
class EcoNotificationTile extends StatelessWidget {
  const EcoNotificationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.timeAgo,
    this.iconColor,
    this.onTap,
    this.read = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? timeAgo;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool read;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? cs.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: EcoTokens.spacing4,
          vertical: EcoTokens.spacing3,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: effectiveIconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: effectiveIconColor, size: EcoTokens.iconSizeMd),
            ),
            const SizedBox(width: EcoTokens.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: read ? FontWeight.w400 : FontWeight.w600,
                              ),
                        ),
                      ),
                      if (!read)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: EcoTokens.spacing1),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (timeAgo != null) ...[
                    const SizedBox(height: EcoTokens.spacing1),
                    Text(
                      timeAgo!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
