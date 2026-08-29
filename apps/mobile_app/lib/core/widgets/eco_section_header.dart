import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A section header with title, optional subtitle, and optional action link.
///
/// ```dart
/// EcoSectionHeader(
///   title: 'Today\'s Quest',
///   actionLabel: 'See All',
///   onAction: () {},
/// )
/// ```
class EcoSectionHeader extends StatelessWidget {
  const EcoSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing4,
        vertical: EcoTokens.spacing3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: EcoTokens.spacing1),
                    child: Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                  ),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(
                  horizontal: EcoTokens.spacing2,
                  vertical: EcoTokens.spacing1,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
