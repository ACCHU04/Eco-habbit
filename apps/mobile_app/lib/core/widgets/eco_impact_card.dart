import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import 'package:mobile_app/core/widgets/eco_card.dart';

/// Displays an environmental impact metric with icon, value, unit, and comparison.
///
/// ```dart
/// EcoImpactCard(
///   type: EcoImpactType.co2,
///   value: 2.4,
///   unit: 'kg',
///   comparison: 'Equivalent to 48 phone charges',
/// )
/// ```
enum EcoImpactType { co2, water, waste, energy }

class EcoImpactCard extends StatelessWidget {
  const EcoImpactCard({
    super.key,
    required this.type,
    required this.value,
    required this.unit,
    this.comparison,
    this.onTap,
  });

  final EcoImpactType type;
  final double value;
  final String unit;
  final String? comparison;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (type) {
      EcoImpactType.co2 => (
          Icons.cloud_outlined,
          'CO₂ Saved',
          EcoColors.impactCarbon,
        ),
      EcoImpactType.water => (
          Icons.water_drop_outlined,
          'Water Saved',
          EcoColors.impactWater,
        ),
      EcoImpactType.waste => (
          Icons.delete_outline,
          'Waste Diverted',
          EcoColors.impactWaste,
        ),
      EcoImpactType.energy => (
          Icons.bolt_outlined,
          'Energy Saved',
          EcoColors.impactEnergy,
        ),
    };

    final displayValue = value >= 1000
        ? '${(value / 1000).toStringAsFixed(1)}k'
        : value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);

    return EcoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(EcoTokens.spacing2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
                ),
                child: Icon(icon, color: color, size: EcoTokens.iconSizeMd),
              ),
              const SizedBox(width: EcoTokens.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      '$displayValue $unit',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comparison != null) ...[
            const SizedBox(height: EcoTokens.spacing3),
            Text(
              comparison!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
