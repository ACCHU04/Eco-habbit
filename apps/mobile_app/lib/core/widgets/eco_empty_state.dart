import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// An empty state placeholder with icon, title, subtitle, and optional action.
///
/// ```dart
/// EcoEmptyState(
///   icon: Icons.inbox_outlined,
///   title: 'No listings yet',
///   subtitle: 'Start by scanning an item',
///   actionLabel: 'Scan Item',
///   onAction: () {},
/// )
/// ```
class EcoEmptyState extends StatelessWidget {
  const EcoEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(EcoTokens.spacing7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: EcoTokens.iconSizeXl * 2,
              color: iconColor ?? cs.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: EcoTokens.spacing4),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: EcoTokens.spacing2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: EcoTokens.spacing5),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: EcoTokens.iconSizeSm),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
