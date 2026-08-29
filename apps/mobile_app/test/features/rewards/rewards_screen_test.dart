import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/rewards/screens/rewards_screen.dart';
import 'package:mobile_app/features/rewards/providers/rewards_provider.dart';
import 'package:mobile_app/features/rewards/models/reward_models.dart'
    as rm;
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

import '../../helpers/test_wrappers.dart';

void main() {
  group('RewardsScreen', () {
    Widget buildRewards({
      AsyncValue<rm.UserPoints> pointsState =
          const AsyncValue.data(rm.UserPoints(totalPoints: 500)),
      AsyncValue<List<rm.Badge>> badgesState = const AsyncValue.data([]),
      AsyncValue<List<rm.LeaderboardEntry>> leaderboardState = const AsyncValue.data([]),
    }) {
      return buildTestWidget(
        const RewardsScreen(),
        initialLocation: '/rewards',
        overrides: [
          authOverride(initial: const AsyncValue.data(AuthData(user: testUser))),
          pointsProvider.overrideWith(() => _FakePointsNotifier(pointsState)),
          badgesProvider.overrideWith(() => _FakeBadgesNotifier(badgesState)),
          leaderboardProvider.overrideWith(() => _FakeLeaderboardNotifier(leaderboardState)),
        ],
      );
    }

    testWidgets('renders tab bar with 3 tabs', (tester) async {
      await tester.pumpWidget(buildRewards());
      await tester.pumpAndSettle();

      expect(find.text('Points'), findsOneWidget);
      expect(find.text('Badges'), findsOneWidget);
      expect(find.text('Leaderboard'), findsOneWidget);
    });

    testWidgets('shows points total in Points tab', (tester) async {
      await tester.pumpWidget(buildRewards());
      await tester.pumpAndSettle();

      expect(find.text('500'), findsOneWidget);
      expect(find.text('Total Points'), findsOneWidget);
    });

    testWidgets('shows leaderboard entries in Leaderboard tab', (tester) async {
      await tester.pumpWidget(buildRewards(
        leaderboardState: const AsyncValue.data([
          rm.LeaderboardEntry(
            userId: 'u1',
            fullName: 'Alice',
            totalPoints: 1000,
            rank: 1,
          ),
          rm.LeaderboardEntry(
            userId: 'u2',
            fullName: 'Bob',
            totalPoints: 800,
            rank: 2,
          ),
        ]),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Leaderboard'));
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('1000 pts'), findsOneWidget);
    });
  });
}

class _FakePointsNotifier extends AsyncNotifier<rm.UserPoints>
    implements PointsNotifier {
  final AsyncValue<rm.UserPoints> _initial;
  _FakePointsNotifier(this._initial);
  @override
  Future<rm.UserPoints> build() async => _initial.value!;
}

class _FakeBadgesNotifier extends AsyncNotifier<List<rm.Badge>>
    implements BadgesNotifier {
  final AsyncValue<List<rm.Badge>> _initial;
  _FakeBadgesNotifier(this._initial);
  @override
  Future<List<rm.Badge>> build() async => _initial.value!;
}

class _FakeLeaderboardNotifier extends AsyncNotifier<List<rm.LeaderboardEntry>>
    implements LeaderboardNotifier {
  final AsyncValue<List<rm.LeaderboardEntry>> _initial;
  _FakeLeaderboardNotifier(this._initial);
  @override
  Future<List<rm.LeaderboardEntry>> build() async => _initial.value!;
}
