import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A themed chip for tags, filters, and categories.
///
/// Supports selectable state, leading icon, and delete action.
///
/// ```dart
/// EcoChip(
///   label: 'Textbooks',
///   selected: true,
///   onSelected: (v) {},
/// )
/// ```
class EcoChip extends StatelessWidget {
  const EcoChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.icon,
    this.color,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool?>? onSelected;
  final VoidCallback? onDeleted;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (onSelected != null) {
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        avatar: icon != null ? Icon(icon, size: EcoTokens.iconSizeSm) : null,
        selectedColor: color ?? cs.primaryContainer,
        checkmarkColor: cs.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
          side: BorderSide(
            color: selected ? (color ?? cs.primary) : cs.outline,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: EcoTokens.spacing2,
          vertical: EcoTokens.spacing1,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      );
    }

    return Chip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: EcoTokens.iconSizeSm) : null,
      deleteIcon: onDeleted != null
          ? const Icon(Icons.close, size: EcoTokens.iconSizeSm)
          : null,
      onDeleted: onDeleted,
      backgroundColor: color ?? cs.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
        side: BorderSide(color: cs.outline),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: EcoTokens.spacing2,
        vertical: EcoTokens.spacing1,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
