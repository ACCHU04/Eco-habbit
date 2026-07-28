import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/engagement/widgets/hostel_widgets.dart';
import 'package:mobile_app/features/engagement/models/hostel_models.dart';

void main() {
  group('HostelCard', () {
    testWidgets('renders name, member count, and score', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HostelCard(
              name: 'Green Tower',
              totalScore: 1200,
              memberCount: 50,
              rank: 1,
            ),
          ),
        ),
      );

      expect(find.text('Green Tower'), findsOneWidget);
      expect(find.text('50 members'), findsOneWidget);
      expect(find.text('1200 pts'), findsOneWidget);
    });

    testWidgets('shows (Your Hostel) for user hostel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HostelCard(
              name: 'My Hostel',
              totalScore: 800,
              memberCount: 30,
              rank: 2,
              isUserHostel: true,
            ),
          ),
        ),
      );

      expect(find.text('My Hostel (Your Hostel)'), findsOneWidget);
    });

    testWidgets('renders rank number for rank > 3', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HostelCard(
              name: 'Hostel X',
              totalScore: 100,
              memberCount: 10,
              rank: 5,
            ),
          ),
        ),
      );

      expect(find.text('#5'), findsOneWidget);
    });

    testWidgets('renders medal emoji for rank 1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HostelCard(
              name: 'Best Hostel',
              totalScore: 999,
              memberCount: 40,
              rank: 1,
            ),
          ),
        ),
      );

      expect(find.text('🥇'), findsOneWidget);
    });

    testWidgets('shows average score', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HostelCard(
              name: 'Hostel',
              totalScore: 100,
              memberCount: 10,
              rank: 3,
            ),
          ),
        ),
      );

      expect(find.text('10 avg'), findsOneWidget);
    });
  });

  group('BattleCard', () {
    testWidgets('renders title, description, and status', (tester) async {
      final battle = HostelBattle(
        id: 'b1',
        title: 'Eco War',
        description: 'Battle of the hostels',
        status: 'active',
        metric: 'recycle',
        startsAt: DateTime.now().subtract(const Duration(days: 1)),
        endsAt: DateTime.now().add(const Duration(days: 5)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BattleCard(battle: battle)),
        ),
      );

      expect(find.text('Eco War'), findsOneWidget);
      expect(find.text('Battle of the hostels'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows VS text', (tester) async {
      final battle = HostelBattle(
        id: 'b1',
        title: 'Test',
        description: 'Desc',
        status: 'active',
        metric: 'm',
        startsAt: DateTime.now().subtract(const Duration(days: 1)),
        endsAt: DateTime.now().add(const Duration(days: 1)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BattleCard(battle: battle)),
        ),
      );

      expect(find.text('VS'), findsOneWidget);
    });

    testWidgets('shows time remaining for active battle', (tester) async {
      final battle = HostelBattle(
        id: 'b1',
        title: 'Active Battle',
        description: 'Desc',
        status: 'active',
        metric: 'm',
        startsAt: DateTime.now().subtract(const Duration(hours: 1)),
        endsAt: DateTime.now().add(const Duration(hours: 5)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BattleCard(battle: battle)),
        ),
      );

      expect(find.textContaining('left'), findsOneWidget);
    });

    testWidgets('shows Completed for completed status', (tester) async {
      final battle = HostelBattle(
        id: 'b1',
        title: 'Done',
        description: 'Completed battle',
        status: 'completed',
        metric: 'm',
        startsAt: DateTime.now().subtract(const Duration(days: 10)),
        endsAt: DateTime.now().subtract(const Duration(days: 5)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BattleCard(battle: battle)),
        ),
      );

      expect(find.text('Completed'), findsOneWidget);
    });
  });
}
