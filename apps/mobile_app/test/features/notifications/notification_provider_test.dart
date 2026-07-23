import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/features/notifications/data/notification_repository.dart';
import 'package:mobile_app/features/notifications/models/notification_model.dart';
import 'package:mobile_app/features/notifications/providers/notification_provider.dart';

@GenerateMocks([NotificationRepository])
import 'notification_provider_test.mocks.dart';

void main() {
  late MockNotificationRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockNotificationRepository();
    container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('NotificationsNotifier', () {
    test('loads notifications', () async {
      when(mockRepo.getNotifications(unreadOnly: anyNamed('unreadOnly'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => PaginatedNotifications(
            notifications: [
              NotificationItem(id: '1', type: 'like_comment', title: 'Liked', body: 'Post liked', createdAt: DateTime(2026)),
            ],
            page: 1, limit: 20, total: 1, totalPages: 1,
          ));

      final result = await container.read(notificationsProvider.future);

      expect(result.notifications, hasLength(1));
      expect(result.notifications[0].title, 'Liked');
    });

    test('loads more pages', () async {
      when(mockRepo.getNotifications(unreadOnly: anyNamed('unreadOnly'), page: 1, limit: 20))
          .thenAnswer((_) async => PaginatedNotifications(
            notifications: [
              NotificationItem(id: '1', type: 'like_comment', title: 'N1', body: 'Body', createdAt: DateTime(2026)),
            ],
            page: 1, limit: 20, total: 2, totalPages: 2,
          ));
      when(mockRepo.getNotifications(unreadOnly: anyNamed('unreadOnly'), page: 2, limit: 20))
          .thenAnswer((_) async => PaginatedNotifications(
            notifications: [
              NotificationItem(id: '2', type: 'reward_achievement', title: 'N2', body: 'Body', createdAt: DateTime(2026)),
            ],
            page: 2, limit: 20, total: 2, totalPages: 2,
          ));

      await container.read(notificationsProvider.future);
      await container.read(notificationsProvider.notifier).loadMore();

      final result = container.read(notificationsProvider).value;
      expect(result!.notifications, hasLength(2));
    });

    test('handles API failure', () async {
      when(mockRepo.getNotifications(unreadOnly: anyNamed('unreadOnly'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenThrow(Exception('Network error'));

      expect(
        () => container.read(notificationsProvider.future),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('UnreadCountNotifier', () {
    test('loads unread count', () async {
      when(mockRepo.getUnreadCount()).thenAnswer((_) async => 5);

      final result = await container.read(unreadCountProvider.future);

      expect(result, 5);
    });

    test('returns zero when no unread', () async {
      when(mockRepo.getUnreadCount()).thenAnswer((_) async => 0);

      final result = await container.read(unreadCountProvider.future);

      expect(result, 0);
    });
  });

  group('Invalidation', () {
    test('markAllAsRead invalidates both providers', () async {
      when(mockRepo.getNotifications(unreadOnly: anyNamed('unreadOnly'), page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => const PaginatedNotifications(
            notifications: [], page: 1, limit: 20, total: 0, totalPages: 1,
          ));
      when(mockRepo.getUnreadCount()).thenAnswer((_) async => 0);
      when(mockRepo.markAllAsRead()).thenAnswer((_) async {});

      await container.read(notificationsProvider.future);
      await container.read(unreadCountProvider.future);

      await container.read(notificationRepositoryProvider).markAllAsRead();

      container.invalidate(notificationsProvider);
      container.invalidate(unreadCountProvider);

      verify(mockRepo.markAllAsRead()).called(1);
    });
  });
}
