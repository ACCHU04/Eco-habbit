import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/engagement/widgets/leaderboard_widgets.dart';

void main() {
  group('LeaderboardRankBadge', () {
    testWidgets('renders gold medal for rank 1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LeaderboardRankBadge(rank: 1)),
        ),
      );
      expect(find.text('🥇'), findsOneWidget);
    });

    testWidgets('renders silver medal for rank 2', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LeaderboardRankBadge(rank: 2)),
        ),
      );
      expect(find.text('🥈'), findsOneWidget);
    });

    testWidgets('renders bronze medal for rank 3', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LeaderboardRankBadge(rank: 3)),
        ),
      );
      expect(find.text('🥉'), findsOneWidget);
    });

    testWidgets('renders numeric rank for rank > 3', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LeaderboardRankBadge(rank: 10)),
        ),
      );
      expect(find.text('#10'), findsOneWidget);
    });

    testWidgets('renders rank 42 correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LeaderboardRankBadge(rank: 42)),
        ),
      );
      expect(find.text('#42'), findsOneWidget);
    });
  });

  group('LeaderboardTile', () {
    testWidgets('renders name and score', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeaderboardTile(
              rank: 5,
              name: 'Alice',
              score: 100,
            ),
          ),
        ),
      );
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('100 pts'), findsOneWidget);
    });

    testWidgets('shows (You) for current user', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeaderboardTile(
              rank: 1,
              name: 'Me',
              score: 50,
              isCurrentUser: true,
            ),
          ),
        ),
      );
      expect(find.text('Me (You)'), findsOneWidget);
    });

    testWidgets('uses custom scoreLabel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeaderboardTile(
              rank: 3,
              name: 'Bob',
              score: 200,
              scoreLabel: 'pts',
            ),
          ),
        ),
      );
      expect(find.text('200 pts'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LeaderboardTile(
              rank: 1,
              name: 'Alice',
              score: 100,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
    });
  });

  group('FilterChipRow', () {
    testWidgets('renders all labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterChipRow(
              labels: const ['All', 'Campus', 'Hostel'],
              values: const ['all', 'campus', 'hostel'],
              selected: 'all',
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Campus'), findsOneWidget);
      expect(find.text('Hostel'), findsOneWidget);
    });

    testWidgets('calls onSelected with correct value', (tester) async {
      String? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterChipRow(
              labels: const ['A', 'B'],
              values: const ['a', 'b'],
              selected: 'a',
              onSelected: (v) => selected = v,
            ),
          ),
        ),
      );

      await tester.tap(find.text('B'));
      expect(selected, 'b');
    });
  });

  group('PeriodChipRow', () {
    testWidgets('renders Weekly, Monthly, All Time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PeriodChipRow(
              selected: 'weekly',
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Weekly'), findsOneWidget);
      expect(find.text('Monthly'), findsOneWidget);
      expect(find.text('All Time'), findsOneWidget);
    });
  });
}
