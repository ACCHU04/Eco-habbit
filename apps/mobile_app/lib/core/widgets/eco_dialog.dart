import 'package:flutter/material.dart';

/// Shows a themed alert dialog with optional title, content, and actions.
///
/// Use the static [show] method for easy presentation.
///
/// ```dart
/// EcoDialog.show(
///   context: context,
///   title: 'Delete Listing?',
///   content: 'This cannot be undone.',
///   confirmLabel: 'Delete',
///   onConfirm: () => Navigator.pop(context),
/// )
/// ```
class EcoDialog extends StatelessWidget {
  const EcoDialog({
    super.key,
    this.title,
    this.content,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  final String? title;
  final Widget? content;
  final String? confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? content,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => EcoDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: content,
      actions: [
        if (cancelLabel != null || onCancel != null)
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text(cancelLabel ?? 'Cancel'),
          ),
        if (confirmLabel != null || onConfirm != null)
          FilledButton(
            onPressed: onConfirm ?? () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isDestructive ? cs.error : cs.primary,
            ),
            child: Text(confirmLabel ?? 'Confirm'),
          ),
      ],
    );
  }
}
