import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A horizontal row of selectable filter chips.
///
/// ```dart
/// EcoFilterRow(
///   options: ['All', 'Textbooks', 'Electronics', 'Furniture'],
///   selectedIndex: 0,
///   onSelected: (i) {},
/// )
/// ```
class EcoFilterRow extends StatelessWidget {
  const EcoFilterRow({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.scrollable = true,
    this.padding,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? const EdgeInsets.symmetric(
      horizontal: EcoTokens.spacing4,
    );

    if (scrollable) {
      return SizedBox(
        height: 44,
        child: ListView.separated(
          padding: effectivePadding,
          scrollDirection: Axis.horizontal,
          itemCount: options.length,
          separatorBuilder: (_, __) => const SizedBox(width: EcoTokens.spacing2),
          itemBuilder: (_, index) {
            final isSelected = index == selectedIndex;
            return FilterChip(
              label: Text(options[index]),
              selected: isSelected,
              onSelected: (_) => onSelected(index),
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            );
          },
        ),
      );
    }

    return Padding(
      padding: effectivePadding,
      child: Wrap(
        spacing: EcoTokens.spacing2,
        runSpacing: EcoTokens.spacing2,
        children: List.generate(options.length, (index) {
          final isSelected = index == selectedIndex;
          return FilterChip(
            label: Text(options[index]),
            selected: isSelected,
            onSelected: (_) => onSelected(index),
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            checkmarkColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          );
        }),
      ),
    );
  }
}
