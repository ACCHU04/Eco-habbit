import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_card.dart';

/// A stat card with icon, value, label, and optional trend indicator.
///
/// ```dart
/// EcoStatCard(
///   icon: Icons.water_drop,
///   value: '12.5k',
///   label: 'Liters Saved',
///   trend: '+15%',
///   trendUp: true,
/// )
/// ```
class EcoStatCard extends StatelessWidget {
  const EcoStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.trend,
    this.trendUp,
    this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final String? trend;
  final bool? trendUp;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return EcoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor ?? cs.primary, size: EcoTokens.iconSizeLg),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: EcoTokens.spacing1),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          if (trend != null) ...[
            const SizedBox(height: EcoTokens.spacing2),
            Row(
              children: [
                Icon(
                  trendUp == true ? Icons.trending_up : Icons.trending_down,
                  size: EcoTokens.iconSizeSm,
                  color: trendUp == true ? EcoColors.success : EcoColors.error,
                ),
                const SizedBox(width: EcoTokens.spacing1),
                Text(
                  trend!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: trendUp == true ? EcoColors.success : EcoColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
