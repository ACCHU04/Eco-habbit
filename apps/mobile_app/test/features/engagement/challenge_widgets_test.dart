import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/engagement/widgets/challenge_widgets.dart';
import 'package:mobile_app/features/engagement/models/challenge_models.dart';

void main() {
  group('ChallengeCard', () {
    FriendChallenge makeChallenge({
      String status = 'active',
      int goalCount = 5,
      int challengerProgress = 3,
      int challengeeProgress = 2,
    }) {
      return FriendChallenge(
        id: 'ch1',
        title: 'Recycle Race',
        description: 'Recycle 5 items',
        challenger: const FriendUser(id: 'u1', fullName: 'Alice'),
        challengee: const FriendUser(id: 'u2', fullName: 'Bob'),
        status: status,
        goalAction: 'recycle_item',
        goalCount: goalCount,
        challengerProgress: challengerProgress,
        challengeeProgress: challengeeProgress,
        endsAt: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now(),
      );
    }

    testWidgets('renders title and opponent name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChallengeCard(
              challenge: makeChallenge(),
              isChallenger: true,
            ),
          ),
        ),
      );

      expect(find.text('Recycle Race'), findsOneWidget);
      expect(find.text('vs Bob'), findsOneWidget);
    });

    testWidgets('shows status badge', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChallengeCard(
              challenge: makeChallenge(status: 'active'),
              isChallenger: true,
            ),
          ),
        ),
      );

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows progress text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChallengeCard(
              challenge: makeChallenge(),
              isChallenger: true,
            ),
          ),
        ),
      );

      expect(find.text('You: 3/5'), findsOneWidget);
      expect(find.text('Them: 2/5'), findsOneWidget);
    });

    testWidgets('shows XP and coin rewards', (tester) async {
      final c = FriendChallenge(
        id: 'ch1',
        title: 'Recycle Race',
        description: 'Recycle 5 items',
        challenger: const FriendUser(id: 'u1', fullName: 'Alice'),
        challengee: const FriendUser(id: 'u2', fullName: 'Bob'),
        status: 'active',
        goalAction: 'recycle_item',
        goalCount: 5,
        xpReward: 200,
        coinReward: 50,
        endsAt: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChallengeCard(
              challenge: c,
              isChallenger: true,
            ),
          ),
        ),
      );

      expect(find.text('200 XP'), findsOneWidget);
      expect(find.text('50 coins'), findsOneWidget);
    });

    testWidgets('swaps progress when isChallenger is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChallengeCard(
              challenge: makeChallenge(
                challengerProgress: 3,
                challengeeProgress: 2,
              ),
              isChallenger: false,
            ),
          ),
        ),
      );

      expect(find.text('You: 2/5'), findsOneWidget);
      expect(find.text('Them: 3/5'), findsOneWidget);
    });
  });

  group('FriendTile', () {
    testWidgets('renders friend name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FriendTile(
              name: 'Alice',
              friendshipId: 'f1',
            ),
          ),
        ),
      );

      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('renders remove button when onRemove provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FriendTile(
              name: 'Alice',
              friendshipId: 'f1',
              onRemove: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person_remove), findsOneWidget);
    });

    testWidgets('does not render remove button when onRemove is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FriendTile(
              name: 'Alice',
              friendshipId: 'f1',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person_remove), findsNothing);
    });

    testWidgets('calls onRemove when remove button tapped', (tester) async {
      bool removed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FriendTile(
              name: 'Alice',
              friendshipId: 'f1',
              onRemove: () => removed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.person_remove));
      expect(removed, isTrue);
    });

    testWidgets('renders first letter initial', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FriendTile(
              name: 'Alice',
              friendshipId: 'f1',
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });
  });

  group('FriendRequestTile', () {
    testWidgets('renders name and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FriendRequestTile(
              name: 'Bob',
              onAccept: () {},
              onDecline: () {},
            ),
          ),
        ),
      );

      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('wants to be your friend'), findsOneWidget);
    });

    testWidgets('renders accept and decline buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FriendRequestTile(
              name: 'Bob',
              onAccept: () {},
              onDecline: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('calls onAccept when accept tapped', (tester) async {
      bool accepted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FriendRequestTile(
              name: 'Bob',
              onAccept: () => accepted = true,
              onDecline: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.check_circle));
      expect(accepted, isTrue);
    });

    testWidgets('calls onDecline when decline tapped', (tester) async {
      bool declined = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FriendRequestTile(
              name: 'Bob',
              onAccept: () {},
              onDecline: () => declined = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.cancel));
      expect(declined, isTrue);
    });

    testWidgets('has tooltips on buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FriendRequestTile(
              name: 'Bob',
              onAccept: () {},
              onDecline: () {},
            ),
          ),
        ),
      );

      expect(find.byTooltip('Accept friend request'), findsOneWidget);
      expect(find.byTooltip('Decline friend request'), findsOneWidget);
    });
  });
}
