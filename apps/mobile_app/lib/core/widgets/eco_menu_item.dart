import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A menu item with icon, label, optional trailing widget, and tap handler.
///
/// ```dart
/// EcoMenuItem(
///   icon: Icons.settings,
///   label: 'Settings',
///   onTap: () {},
/// )
/// ```
class EcoMenuItem extends StatelessWidget {
  const EcoMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveIconColor = destructive ? EcoColors.error : iconColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: EcoTokens.spacing4,
          vertical: EcoTokens.spacing3,
        ),
        child: Row(
          children: [
            Icon(icon, color: effectiveIconColor ?? cs.onSurfaceVariant, size: EcoTokens.iconSizeMd),
            const SizedBox(width: EcoTokens.spacing3),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: destructive ? EcoColors.error : null,
                    ),
              ),
            ),
            if (trailing != null) trailing!,
            Icon(
              Icons.chevron_right,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
              size: EcoTokens.iconSizeMd,
            ),
          ],
        ),
      ),
    );
  }
}
