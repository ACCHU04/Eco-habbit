import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A themed search bar with optional leading/trailing icons and hint text.
///
/// ```dart
/// EcoSearchBar(
///   hint: 'Search items, projects, posts...',
///   onChanged: (v) {},
/// )
/// ```
class EcoSearchBar extends StatelessWidget {
  const EcoSearchBar({
    super.key,
    this.controller,
    this.hint,
    this.leadingIcon = Icons.search,
    this.trailingIcon,
    this.onTrailingTap,
    this.onChanged,
    this.onSubmitted,
    this.autoFocus = false,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? hint;
  final IconData leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autoFocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: EcoTokens.touchTargetComfortable,
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: EcoTokens.spacing3),
            child: Icon(leadingIcon, color: cs.onSurfaceVariant, size: EcoTokens.iconSizeMd),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autoFocus,
              enabled: enabled,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: EcoTokens.spacing2,
                  vertical: EcoTokens.spacing3,
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (trailingIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: EcoTokens.spacing2),
              child: IconButton(
                icon: Icon(trailingIcon, size: EcoTokens.iconSizeMd),
                onPressed: onTrailingTap,
              ),
            ),
        ],
      ),
    );
  }
}
