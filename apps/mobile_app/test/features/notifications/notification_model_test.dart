import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/notifications/models/notification_model.dart';

void main() {
  group('NotificationItem', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'n1',
        'type': 'like',
        'title': 'New like',
        'body': 'Someone liked your post',
        'created_at': '2026-07-23T10:00:00Z',
        'read_at': '2026-07-23T11:00:00Z',
        'data': {'post_id': 'p1'},
      };
      final item = NotificationItem.fromJson(json);
      expect(item.id, 'n1');
      expect(item.type, 'like');
      expect(item.title, 'New like');
      expect(item.body, 'Someone liked your post');
      expect(item.readAt, isNotNull);
      expect(item.data, {'post_id': 'p1'});
    });

    test('fromJson defaults to empty strings when fields missing', () {
      final item = NotificationItem.fromJson({});
      expect(item.id, '');
      expect(item.type, '');
      expect(item.title, '');
      expect(item.body, '');
      expect(item.readAt, isNull);
      expect(item.data, isNull);
    });

    test('fromJson parses unread notification (read_at is null)', () {
      final json = {
        'id': 'n1',
        'type': 'comment',
        'title': 'Title',
        'body': 'Body',
        'created_at': '2026-07-23T10:00:00Z',
      };
      final item = NotificationItem.fromJson(json);
      expect(item.isUnread, true);
    });

    test('fromJson parses read notification (read_at present)', () {
      final json = {
        'id': 'n1',
        'type': 'comment',
        'title': 'Title',
        'body': 'Body',
        'created_at': '2026-07-23T10:00:00Z',
        'read_at': '2026-07-23T11:00:00Z',
      };
      final item = NotificationItem.fromJson(json);
      expect(item.isUnread, false);
    });

    test('isUnread returns true when readAt is null', () {
      final item = NotificationItem(
        id: '1',
        type: 'like',
        title: 'T',
        body: 'B',
        createdAt: DateTime(2026),
      );
      expect(item.isUnread, true);
    });

    test('isUnread returns false when readAt is set', () {
      final item = NotificationItem(
        id: '1',
        type: 'like',
        title: 'T',
        body: 'B',
        createdAt: DateTime(2026),
        readAt: DateTime(2026),
      );
      expect(item.isUnread, false);
    });
  });

  group('PaginatedNotifications', () {
    test('hasMore returns true when page < totalPages', () {
      const paginated = PaginatedNotifications(
        notifications: [],
        page: 1,
        limit: 20,
        total: 50,
        totalPages: 3,
      );
      expect(paginated.hasMore, true);
    });

    test('hasMore returns false on last page', () {
      const paginated = PaginatedNotifications(
        notifications: [],
        page: 3,
        limit: 20,
        total: 50,
        totalPages: 3,
      );
      expect(paginated.hasMore, false);
    });

    test('hasMore returns false when single page', () {
      const paginated = PaginatedNotifications(
        notifications: [],
        page: 1,
        limit: 20,
        total: 5,
        totalPages: 1,
      );
      expect(paginated.hasMore, false);
    });
  });
}
