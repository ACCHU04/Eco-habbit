import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A bottom navigation bar with 5 items and a center Scan FAB.
///
/// ```dart
/// EcoBottomNav(
///   currentIndex: 0,
///   onTap: (i) {},
///   onScanTap: () {},
/// )
/// ```
class EcoBottomNav extends StatelessWidget {
  const EcoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onScanTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onScanTap;

  static const _icons = [
    Icons.home_outlined,
    Icons.storefront_outlined,
    Icons.camera_alt_outlined,
    Icons.forum_outlined,
    Icons.person_outlined,
  ];
  static const _activeIcons = [
    Icons.home,
    Icons.storefront,
    Icons.camera_alt,
    Icons.forum,
    Icons.person,
  ];
  static const _labels = ['Home', 'Market', 'Scan', 'Community', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: cs.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: EcoTokens.elevationSm * 2,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(5, (index) {
                if (index == 2) {
                  return const SizedBox(width: 72);
                }
                final isSelected = index == currentIndex;
                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? _activeIcons[index] : _icons[index],
                          color: isSelected ? cs.primary : cs.onSurfaceVariant,
                          size: EcoTokens.iconSizeMd,
                        ),
                        const SizedBox(height: EcoTokens.spacing1),
                        Text(
                          _labels[index],
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isSelected ? cs.primary : cs.onSurfaceVariant,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 28,
            child: GestureDetector(
              onTap: onScanTap,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [EcoColors.primary, EcoColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: EcoColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: EcoTokens.iconSizeLg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
