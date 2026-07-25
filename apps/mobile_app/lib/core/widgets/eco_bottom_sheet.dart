import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/tokens.dart';

/// Shows a themed bottom sheet with optional title and actions.
///
/// Use the static [show] method for easy presentation.
///
/// ```dart
/// EcoBottomSheet.show(
///   context: context,
///   title: 'Share Listing',
///   child: ShareOptionsWidget(),
/// )
/// ```
class EcoBottomSheet extends StatelessWidget {
  const EcoBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
  });

  final String? title;
  final Widget child;
  final List<Widget>? actions;

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool isScrollControlled = false,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      builder: (_) => EcoBottomSheet(
        title: title,
        actions: actions,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: EcoTokens.spacing4,
            vertical: EcoTokens.spacing4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: EcoTokens.spacing4),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              child,
              if (actions != null && actions!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: EcoTokens.spacing4),
                  child: Row(
                    children: actions!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
