import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A single stat item with an icon, value, and label.
///
/// ```dart
/// EcoStatItem(
///   icon: Icons.recycling,
///   value: '42',
///   label: 'Items Recycled',
/// )
/// ```
class EcoStatItem extends StatelessWidget {
  const EcoStatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
    this.valueColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: EcoTokens.iconSizeLg),
        const SizedBox(height: EcoTokens.spacing1),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
