import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/notifications/screens/notifications_screen.dart';
import 'package:mobile_app/features/notifications/providers/notification_provider.dart';
import 'package:mobile_app/features/notifications/models/notification_model.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('NotificationsScreen', () {
    final testNotifications = PaginatedNotifications(
      notifications: [
        NotificationItem(
          id: 'n1',
          type: 'like_comment',
          title: 'New like on your post',
          body: 'Jane liked your recycling tip',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        NotificationItem(
          id: 'n2',
          type: 'marketplace_inquiry',
          title: 'New inquiry',
          body: 'Someone is interested in your listing',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          readAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
      page: 1,
      limit: 20,
      total: 2,
      totalPages: 1,
    );

    Widget buildNotifications({
      AsyncValue<PaginatedNotifications> notificationsState =
          const AsyncValue.data(PaginatedNotifications(
        notifications: [],
        page: 1,
        limit: 20,
        total: 0,
        totalPages: 0,
      )),
    }) {
      return buildTestWidget(
        const NotificationsScreen(),
        initialLocation: '/notifications',
        overrides: [
          notificationsProvider.overrideWith(
            () => _FakeNotificationsNotifier(notificationsState),
          ),
        ],
      );
    }

    testWidgets('renders AppBar with Mark all read action', (tester) async {
      await tester.pumpWidget(buildNotifications());
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Mark all read'), findsOneWidget);
    });

    testWidgets('shows loading indicator during initial load', (tester) async {
      await tester.pumpWidget(buildNotifications(
        notificationsState: const AsyncValue.loading(),
      ));
      // pump once (no pumpAndSettle) so we can see the loading state
      // before the notifier resolves
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows notification items when data is loaded', (tester) async {
      await tester.pumpWidget(buildNotifications(
        notificationsState: AsyncValue.data(testNotifications),
      ));
      await tester.pumpAndSettle();

      expect(find.text('New like on your post'), findsOneWidget);
      expect(find.text('New inquiry'), findsOneWidget);
      expect(find.text('Jane liked your recycling tip'), findsOneWidget);
    });
  });
}

class _FakeNotificationsNotifier extends AsyncNotifier<PaginatedNotifications>
    implements NotificationsNotifier {
  final AsyncValue<PaginatedNotifications>? _initial;
  _FakeNotificationsNotifier(this._initial);
  @override
  Future<PaginatedNotifications> build() async {
    final initial = _initial;
    if (initial == null || initial.isLoading) {
      await Completer<PaginatedNotifications>().future;
    }
    return initial!.value!;
  }
  @override
  Future<void> loadMore() async {}
}
