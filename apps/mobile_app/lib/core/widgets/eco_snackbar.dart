import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/colors.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// Themed snackbar helpers.
///
/// ```dart
/// EcoSnackBar.show(
///   context,
///   message: 'Item listed successfully!',
///   type: EcoSnackBarType.success,
/// )
/// ```
enum EcoSnackBarType { info, success, warning, error }

class EcoSnackBar {
  EcoSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    EcoSnackBarType type = EcoSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final cs = Theme.of(context).colorScheme;
    final icon = switch (type) {
      EcoSnackBarType.info => Icons.info_outline,
      EcoSnackBarType.success => Icons.check_circle_outline,
      EcoSnackBarType.warning => Icons.warning_amber_outlined,
      EcoSnackBarType.error => Icons.error_outline,
    };
    final iconColor = switch (type) {
      EcoSnackBarType.info => cs.primary,
      EcoSnackBarType.success => EcoColors.success,
      EcoSnackBarType.warning => EcoColors.warning,
      EcoSnackBarType.error => cs.error,
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: iconColor, size: EcoTokens.iconSizeMd),
              const SizedBox(width: EcoTokens.spacing3),
              Expanded(child: Text(message)),
            ],
          ),
          duration: duration,
          action: action,
        ),
      );
  }
}
