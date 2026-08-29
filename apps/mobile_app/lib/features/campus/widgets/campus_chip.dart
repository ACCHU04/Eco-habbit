import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/tokens.dart';
import '../providers/campus_provider.dart';

class CampusChip extends ConsumerWidget {
  final VoidCallback? onTap;

  const CampusChip({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campus = ref.watch(selectedCampusProvider);

    if (campus == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: EcoTokens.spacing2, vertical: EcoTokens.spacing1),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, size: EcoTokens.iconSizeSm, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: EcoTokens.spacing1),
            Text(
              campus.displayName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
