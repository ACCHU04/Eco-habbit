import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// A small count or status indicator badge.
///
/// Shows a [count] number inside a rounded container, or a dot if no count.
///
/// ```dart
/// EcoBadge(
///   count: 3,
///   child: Icon(Icons.notifications),
/// )
/// ```
class EcoBadge extends StatelessWidget {
  const EcoBadge({
    super.key,
    this.count,
    required this.child,
    this.backgroundColor,
    this.textColor,
    this.showDot = false,
  });

  final int? count;
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? cs.error;
    final fg = textColor ?? cs.onError;

    final bool hasBadge = (count != null && count! > 0) || showDot;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (hasBadge)
          Positioned(
            right: -6,
            top: -6,
            child: count != null && count! > 0
                ? Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(EcoTokens.radiusFull),
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count! > 99 ? '99+' : '$count',
                      style: TextStyle(
                        color: fg,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  )
                : Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}
