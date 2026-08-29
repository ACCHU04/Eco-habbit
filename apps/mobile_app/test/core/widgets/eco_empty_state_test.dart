import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/widgets/eco_empty_state.dart';

void main() {
  group('EcoEmptyState', () {
    testWidgets('renders icon, title, and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EcoEmptyState(
              icon: Icons.inbox_outlined,
              title: 'Nothing here',
              subtitle: 'Items will appear soon',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Items will appear soon'), findsOneWidget);
    });

    testWidgets('renders action button when actionLabel and onAction provided',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EcoEmptyState(
              icon: Icons.add,
              title: 'Empty',
              subtitle: 'Create something',
              actionLabel: 'Create',
              onAction: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Create'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      await tester.tap(find.text('Create'));
      expect(tapped, isTrue);
    });

    testWidgets('does not render button when actionLabel is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EcoEmptyState(
              icon: Icons.inbox_outlined,
              title: 'Empty',
              subtitle: 'Nothing yet',
            ),
          ),
        ),
      );

      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('does not render button when onAction is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EcoEmptyState(
              icon: Icons.inbox_outlined,
              title: 'Empty',
              subtitle: 'Nothing yet',
              actionLabel: 'Create',
            ),
          ),
        ),
      );

      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('uses custom iconColor when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EcoEmptyState(
              icon: Icons.star,
              title: 'Star',
              subtitle: 'Subtitle',
              iconColor: Colors.amber,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, Colors.amber);
    });
  });
}
