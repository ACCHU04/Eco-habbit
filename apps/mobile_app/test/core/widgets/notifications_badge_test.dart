import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/widgets/notifications_badge.dart';
import 'package:mobile_app/features/notifications/providers/notification_provider.dart';

void main() {
  group('NotificationsBadge', () {
    testWidgets('renders child without badge when count is 0', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unreadCountProvider.overrideWith(() => _FakeUnreadCountNotifier(0)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: NotificationsBadge(child: Icon(Icons.notifications)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.byType(Badge), findsNothing);
    });

    testWidgets('shows badge with count when unread > 0', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unreadCountProvider.overrideWith(() => _FakeUnreadCountNotifier(3)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: NotificationsBadge(child: Icon(Icons.notifications)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.byType(Badge), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('shows 99+ when count exceeds 99', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unreadCountProvider.overrideWith(() => _FakeUnreadCountNotifier(150)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: NotificationsBadge(child: Icon(Icons.notifications)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('99+'), findsOneWidget);
    });
  });
}

class _FakeUnreadCountNotifier extends AsyncNotifier<int>
    implements UnreadCountNotifier {
  final int _count;
  _FakeUnreadCountNotifier(this._count);
  @override
  Future<int> build() async => _count;
}
