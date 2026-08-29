import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/notifications/models/notification_model.dart';

class NotificationRepository {
  final ApiClient _api;
  NotificationRepository(this._api);

  Future<PaginatedNotifications> getNotifications({
    bool unreadOnly = false,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (unreadOnly) params['unread_only'] = true;
    final response = await _api.get('/notifications', queryParameters: params);
    final data = response.data['data'] as List<dynamic>;
    final pagination = response.data['pagination'] as Map<String, dynamic>;
    return PaginatedNotifications(
      notifications: data.map((e) => NotificationItem.fromJson(e)).toList(),
      page: pagination['page'] as int? ?? page,
      limit: pagination['limit'] as int? ?? limit,
      total: pagination['total'] as int? ?? 0,
      totalPages: pagination['total_pages'] as int? ?? 1,
    );
  }

  Future<int> getUnreadCount() async {
    final response = await _api.get('/notifications/unread-count');
    return response.data['unread_count'] as int? ?? 0;
  }

  Future<void> markAsRead(String id) async {
    await _api.post('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _api.post('/notifications/read-all');
  }
}

final notificationRepositoryProvider = Provider((ref) {
  return NotificationRepository(ref.read(apiClientProvider));
});
