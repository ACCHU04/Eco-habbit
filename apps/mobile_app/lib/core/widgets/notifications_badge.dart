import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/notifications/providers/notification_provider.dart';

class NotificationsBadge extends ConsumerWidget {
  final Widget child;
  const NotificationsBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadCountProvider).valueOrNull ?? 0;
    if (count == 0) return child;
    return Badge(
      label: count > 99 ? const Text('99+') : Text('$count'),
      child: child,
    );
  }
}
