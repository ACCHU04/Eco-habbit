import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/notifications/data/notification_repository.dart';
import 'package:mobile_app/features/notifications/models/notification_model.dart';

class NotificationsNotifier extends AsyncNotifier<PaginatedNotifications> {
  @override
  Future<PaginatedNotifications> build() async {
    return ref.read(notificationRepositoryProvider).getNotifications();
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;
    state = AsyncValue.data(current);
    try {
      final next = await ref.read(notificationRepositoryProvider).getNotifications(
        page: current.page + 1,
        limit: current.limit,
      );
      state = AsyncValue.data(PaginatedNotifications(
        notifications: [...current.notifications, ...next.notifications],
        page: next.page,
        limit: next.limit,
        total: next.total,
        totalPages: next.totalPages,
      ));
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }
}

final notificationsProvider = AsyncNotifierProvider<NotificationsNotifier, PaginatedNotifications>(
  NotificationsNotifier.new,
);

class UnreadCountNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    return ref.read(notificationRepositoryProvider).getUnreadCount();
  }
}

final unreadCountProvider = AsyncNotifierProvider<UnreadCountNotifier, int>(
  UnreadCountNotifier.new,
);
