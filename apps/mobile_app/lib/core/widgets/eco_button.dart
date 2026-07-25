import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

enum EcoButtonSize { sm, md, lg }

enum EcoButtonVariant { filled, outlined, text, tonal }

/// A reusable button that follows EcoTokens sizing and shape conventions.
///
/// Supports four variants and three sizes. All sizing derives from [EcoTokens].
///
/// ```dart
/// EcoButton(
///   label: 'List Item',
///   icon: Icons.add,
///   onPressed: () {},
/// )
/// ```
class EcoButton extends StatelessWidget {
  const EcoButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = EcoButtonVariant.filled,
    this.size = EcoButtonSize.md,
    this.loading = false,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final EcoButtonVariant variant;
  final EcoButtonSize size;
  final bool loading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final height = switch (size) {
      EcoButtonSize.sm => EcoTokens.buttonHeightSm,
      EcoButtonSize.md => EcoTokens.buttonHeightMd,
      EcoButtonSize.lg => EcoTokens.buttonHeightLg,
    };
    final textStyle = switch (size) {
      EcoButtonSize.sm => Theme.of(context).textTheme.labelMedium,
      EcoButtonSize.md => Theme.of(context).textTheme.labelLarge,
      EcoButtonSize.lg => Theme.of(context).textTheme.titleSmall,
    };
    final iconSize = switch (size) {
      EcoButtonSize.sm => EcoTokens.iconSizeSm,
      EcoButtonSize.md => EcoTokens.iconSizeMd,
      EcoButtonSize.lg => EcoTokens.iconSizeLg,
    };
    final horizontalPadding = switch (size) {
      EcoButtonSize.sm => EcoTokens.spacing3,
      EcoButtonSize.md => EcoTokens.spacing4,
      EcoButtonSize.lg => EcoTokens.spacing5,
    };

    final effectiveOnPressed = loading ? null : onPressed;

    Widget child = loading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == EcoButtonVariant.filled ||
                        variant == EcoButtonVariant.tonal
                    ? cs.onPrimary
                    : cs.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: iconSize),
                SizedBox(
                  width: size == EcoButtonSize.sm
                      ? EcoTokens.spacing1
                      : EcoTokens.spacing2,
                ),
              ],
              Text(label, style: textStyle),
            ],
          );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(EcoTokens.radiusSm),
    );

    Widget button = switch (variant) {
      EcoButtonVariant.filled => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, height),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: shape,
            elevation: EcoTokens.elevationNone,
          ),
          child: child,
        ),
      EcoButtonVariant.outlined => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(0, height),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: shape,
          ),
          child: child,
        ),
      EcoButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(0, height),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: shape,
          ),
          child: child,
        ),
      EcoButtonVariant.tonal => FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(0, height),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: shape,
            elevation: EcoTokens.elevationNone,
          ),
          child: child,
        ),
    };

    if (fullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
