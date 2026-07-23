import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/profile/screens/profile_screen.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/profile/providers/profile_provider.dart';
import 'package:mobile_app/features/profile/models/user_stats.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('ProfileScreen', () {
    Widget buildProfile({
      AsyncValue<AuthData> authState =
          const AsyncValue.data(AuthData(user: testUser)),
      AsyncValue<UserStats> statsState = const AsyncValue.data(UserStats(
        listingsCount: 5,
        totalPoints: 250,
        badgesCount: 3,
        badges: ['first_sale', 'recycler', 'creator'],
      )),
    }) {
      return buildTestWidget(
        const ProfileScreen(),
        initialLocation: '/profile',
        overrides: [
          authOverride(initial: authState),
          profileStatsProvider.overrideWith(
            () => _FakeProfileStatsNotifier(statsState),
          ),
        ],
        destinationRoutes: {
          '/settings': (_, __) => const Scaffold(body: Text('settings-page')),
          '/my-listings': (_, __) => const Scaffold(body: Text('my-listings-page')),
          '/rewards': (_, __) => const Scaffold(body: Text('rewards-page')),
          '/notifications': (_, __) => const Scaffold(body: Text('notifications-page')),
        },
      );
    }

    testWidgets('renders user initials in CircleAvatar', (tester) async {
      await tester.pumpWidget(buildProfile());
      await tester.pumpAndSettle();

      expect(find.text('TU'), findsOneWidget);
    });

    testWidgets('displays user name and college', (tester) async {
      await tester.pumpWidget(buildProfile());
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Test College'), findsOneWidget);
    });

    testWidgets('shows stats section with listings, points, and badges', (tester) async {
      await tester.pumpWidget(buildProfile());
      await tester.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
      expect(find.text('250'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Listings'), findsOneWidget);
      expect(find.text('Points'), findsWidgets);
      expect(find.text('Badges'), findsOneWidget);
    });
  });
}

class _FakeProfileStatsNotifier extends AsyncNotifier<UserStats>
    implements ProfileStatsNotifier {
  final AsyncValue<UserStats> _initial;
  _FakeProfileStatsNotifier(this._initial);
  @override
  Future<UserStats> build() async => _initial.value!;
  @override
  Future<void> reload() async {}
}
